import Foundation
import libc
import POSIX
import CommandLineKit
import HaskellSwift

public enum AutobuildError: Swift.Error {
    case InvalidUsage
    case InvalidParameter(hint: String)
    case OtherError
}

private let chdirHelpMessage      = "Change working directory before any other operation"
private let executableHelpMessage = "Build script path"
private let helpHelpMessage       = "print usage\nautobuild (-c|--chdir workingdirectory) (-s|--script scriptpath) (-t|--types fileextensions)\nExecute build script automatically when any specified files in working directory are modified.\nExample:\nautobuild -c ./ -s ./build.sh -t \"{swift,m,h}\""
private let typesHelpMesage       = "file extensions to be monitored, such as \"{swift,m,h}\".If there is no file extensions specified, all kinds of files in working directory will be monitored."

private struct Options {
    let chdir = StringOption(shortFlag: "c",
                             longFlag: "chdir",
                             helpMessage: chdirHelpMessage)

    let executable = StringOption(shortFlag: "s",
                                  longFlag: "script",
                                  required: true,
                                  helpMessage: executableHelpMessage)

    let types = StringOption(shortFlag: "t",
                             longFlag: "types",
                             helpMessage: typesHelpMesage)

    let help = BoolOption(shortFlag: "h",
                          longFlag: "help",
                          helpMessage: helpHelpMessage)
}

var eventMonitor : FSEventMonitor? = nil

struct MonitorOption {
    let workingDirectory: String
    let executable: String
    let fileExtensions: [String]
}

//MARK: - main
public func autobuild(_ args: [String]) {
    let result = parse(args) >>>= createMonitorOption >>>= validateMonitorOption >>>= monitor
    printResult(result)
}

//MARK: - printResult
func printResult(_ result: Either<AutobuildError, Bool>) {
    guard isLeft(result) else {
        Darwin.exit(0)
    }

    let err: AutobuildError = fromLeft(result)
    switch err {
    case .InvalidUsage:
        Darwin.exit(1)
    case .InvalidParameter(let hint):
        print(hint)
    default:
        break
    }
    Darwin.exit(1)
}

//MARK: - parse
private func parse(_ args: [String]) -> Either<AutobuildError, Options> {
    let commandLine = CommandLineKit.CommandLine(arguments: args)
    let options     = Options()
    commandLine.addOptions(options.chdir, options.executable, options.types, options.help)

    //parse options
    do {
        try commandLine.parse()
    } catch {
        commandLine.printUsage(error)
        return Left(AutobuildError.InvalidUsage)
    }

    //validate arguments
    if shouldHelp(options) {
        commandLine.printUsage()
    }

    return Right(options)
}

private func shouldHelp(_ options: Options) -> Bool {
    let isInvalidParameters = all(isNothing, [options.chdir.value, options.executable.value])
    return options.help.value || isInvalidParameters
}

//MARK: - createMonitorOption
private func createMonitorOption(_ options: Options) -> Either<AutobuildError, MonitorOption> {
    let workingDirectory = options.chdir.value ?? getcwd()
    let executable       = options.executable.value!
    let fileExtensions   = getFileExtensions(options)
    let option           = MonitorOption(workingDirectory: workingDirectory, executable: executable, fileExtensions: fileExtensions)
    return Right(option)
}

//MARK: -getFileExtensions
private func getFileExtensions(_ options: Options) -> [String] {
    let f = getNotNullFileExtensions .. optionsToFileExtensions
    return f(options)
}

private func getNotNullFileExtensions(_ fileExtensions: [String]) -> [String] {
    let f = filter(not .. null) .. map(map(toLower) .. trimCharacters)
    return f(fileExtensions)
}

private func optionsToFileExtensions(_ options: Options) -> [String] {
    let getTypes      = {(options: Options) in options.types.value  ?? ""}
    let getExtensions = {splitWith({$0 == ","}, $0)}
    return (getExtensions .. getTypes)(options)
}

private func trimCharacters(_ s: String) -> String {
    return s.trimmingCharacters(in: CharacterSet(charactersIn: "{ \t}"))
}

//MARK: - validateMonitorOption
private func validateMonitorOption(_ option: MonitorOption) -> Either<AutobuildError, MonitorOption> {
    return validateWorkingDirectory(option) >>>= validateExecutable
}

private func validateWorkingDirectory(_ option: MonitorOption) -> Either<AutobuildError, MonitorOption> {
    //Check if it's a directory and the directory exists
    let hint = "The project root directory doesn't exist"
    return isDirectory(option.workingDirectory) ? Right(option) : Left(AutobuildError.InvalidParameter(hint: hint))
}

private func validateExecutable(_ option: MonitorOption) -> Either<AutobuildError, MonitorOption> {
    //Check if file exists.
    let hint = "The build script isn't executable or doesn't exist"
    return isExecutableFile(option.executable) ? Right(option) : Left(AutobuildError.InvalidParameter(hint: hint))
}

//MARK: -isExecutableFile
func isExecutableFile(_ path: String) -> Bool {
    return fileExists(path) && !isDirectory(path) && _isExecutableFile(path)
}

func _isExecutableFile(_ path: String) -> Bool {
    return FileManager.default.isExecutableFile(atPath: path)
}

func isDirectory(_ path: String) -> Bool {
    var isDir: ObjCBool = false
    let fileExists      = FileManager.default.fileExists(atPath: path, isDirectory: &isDir)
    return  fileExists && isDir.boolValue
}

//MARK: - monitor
private func monitor(_ option: MonitorOption) -> Either<AutobuildError, Bool> {
    Log.info("Start monitoring:\nWorking directory: \(option.workingDirectory)\nFile extensions: \(option.fileExtensions)")

    changeWorkingDirectory(option.workingDirectory)
    installSignalHandlers()

    _monitor(option.workingDirectory, option.executable, option.fileExtensions)
    return Right(true)
}

//MARK: changeWorkingDirectory
func changeWorkingDirectory(_ dir: String) {
    dir >>>= getWorkingDirectory >>>= _changeWorkingDirectory
}

func getWorkingDirectory(_ dir: String) -> String? {
    let initialWorkingDirectory = URL(fileURLWithPath: POSIX.getiwd()).absoluteString
    let workingDirectory        = URL(fileURLWithPath: dir).absoluteString
    return initialWorkingDirectory != workingDirectory ? workingDirectory : nil
}

func _changeWorkingDirectory(_ dir: String) {
    do {
        try POSIX.chdir(dir)
    } catch {
        Log.info("changeWorkingDirectory: \(error)")
    }
}

//MARK: installSignalHandlers
func installSignalHandlers() {
    signal(SIGINT, terminateProcessTree)
}

func terminateProcessTree(pid: Int32)  {
    Log.error(closure: "\nTerminating subprocesses")
    eventMonitor >>>= _terminateProcessTree
}

func _terminateProcessTree(monitor: FSEventMonitor) {
    eventMonitor!.canMonitor = false
    eventMonitor!.terminate()
    wait(nil)
}

//MARK: _monitor
func _monitor(_ dir: String, _ executable: String, _ fileExtensions: [String]) {
    eventMonitor    = FSEventMonitor(arguments: [dir], action: handleFiles(executable, fileExtensions))
    eventMonitor?.run()
}

func handleFiles(_ executable: String, _ fileExtensions: [String]) -> (String) -> Void {
    return {( content: String) in handleModifiedFiles(content, executable, fileExtensions) }
}

func handleModifiedFiles(_ content: String, _ executable: String, _ fileExtensions: [String]) {
    isFileModified(fileExtensions, content) ? SyncTask.execute("/bin/bash", [executable]) : ()
}

func isFileModified(_ fileExtensions: [String], _ content: String) -> Bool {
    let getModifiedFiles: (String) -> [String] = filter(anyFileExtensions(fileExtensions)) .. lines
    let isModified: ([String]) -> Bool         = not .. null .. map({Log.info($0)})
    let f                                      = isModified .. getModifiedFiles
    return f(content)
}

func anyFileExtensions(_ fileExtensions: [String]) -> (String) -> Bool {
    return  { path in null(fileExtensions) ? true : _anyFileExtensions(fileExtensions, path) }
}

func _anyFileExtensions(_ fileExtensions: [String], _ path: String) -> Bool {
    let f = not .. null .. filter({isFile($0, path)})
    return f(fileExtensions)
}

func isFile(_ fileExtension: String, _ path: String) -> Bool {
    let ext1 = map(toLower, takeExtension(path))
    let ext2 = ("." + fileExtension)
    return ext1 == ext2
}
