import Foundation
import libc
import POSIX
import CommandLine

public enum AutobuildError: Swift.Error {
    case InvalidUsage
    case InvalidParameter(hint: String)
}

private struct Options {
    let chdir = StringOption(shortFlag: "c",
        longFlag: "chdir",
        helpMessage: "Change working directory before any other operation")

    let executable = StringOption(shortFlag: "s",
                                  longFlag: "script",
                                  required: true,
                                  helpMessage: "Build script path")

    let types = StringOption(shortFlag: "t",
                             longFlag: "types",
                             helpMessage: "file extensions to be monitored, such as \"{swift,m,h}\".If there is no file extensions specified, all kinds of files in the working directory will be monitored.")

    let help = BoolOption(shortFlag: "h",
                          longFlag: "help",
                          helpMessage: "print usage\nautobuild (-c|--chdir workingdirectory) (-s|--script scriptpath) (-t|--types fileextensions)\nExecute build script automatically when any specified files in working directory are modified.\nExample:\nautobuild -c ./ -s ./build.sh -t \"{swift,m,h}\"")
}

var eventMonitor : FSEventMonitor? = nil

//MARK: main
public func main(_ args: [String]) throws {
    let cli         = CommandLine(arguments: args)
    let options     = Options()
    cli.addOptions(options.chdir, options.executable, options.types, options.help)

    //parse options
    do {
        try cli.parse()
    } catch {
        cli.printUsage(error)
        throw AutobuildError.InvalidUsage
    }

    //validate arguments
    let shouldHelp: Bool = options.help.value || (options.chdir.value == nil && options.executable.value == nil)
    if shouldHelp {
        cli.printUsage()
        return
    }

    let rootd = options.chdir.value ?? getcwd()

    //Check if it's a directory and the directory exsists
    if !isDirectory(rootd) {
        let hint = "The project root directory doesn't exist"
        throw AutobuildError.InvalidParameter(hint: hint)
    }

    guard let executable = options.executable.value  else {
        let hint = "Please use -s to indicate the build script path"
        throw AutobuildError.InvalidParameter(hint: hint)
    }

    let types = options.types.value ?? ""
    let fileExtensions = types.components(separatedBy: ",").map({$0.trimmingCharacters(in: CharacterSet(charactersIn: "{ \t}"))}).map({$0.lowercased()}).filter({$0.characters.count > 0})

    //Check if file exists.
    if !isExecutableFile(executable) {
        let hint = "The build script isn't executable or doesn't exist"
        throw AutobuildError.InvalidParameter(hint: hint)
    }

    //Monitor file changes
    try monitor(rootd, executable, fileExtensions)
}

func isExecutableFile(_ path: String) -> Bool {
    let manager         = FileManager.default
    var isDir: ObjCBool = false
    let fileExists      = manager.fileExists(atPath: path, isDirectory: &isDir)
    let executable      = manager.isExecutableFile(atPath: path)
    return  fileExists && !isDir.boolValue && executable
}

func isDirectory(_ path: String) -> Bool {
    let manager         = FileManager.default
    var isDir: ObjCBool = false
    let fileExists      = manager.fileExists(atPath: path, isDirectory: &isDir)
    return  fileExists && isDir.boolValue
}

//MARK: monitor
func monitor(_ dir: String, _ executable: String, _ fileExtensions: [String]) throws {
    Log.info("Start monitoring:\ndir: \(dir)\nfile extensions: \(fileExtensions)")

    try POSIX.chdir(dir)

    installSignalHandlers()

    let lineHandler = { (content: String) in handleModifiedFiles(content, executable, fileExtensions) }
    eventMonitor = FSEventMonitor(arguments: [dir], action: lineHandler)
    eventMonitor?.run()
}

func isFile(_ fileExtension: String, _ line: String) -> Bool {
    let url = URL(fileURLWithPath: line)
    let filename = url.lastPathComponent
    let ext = url.pathExtension.lowercased()
    return !filename.hasPrefix(".") && ext == fileExtension
}

func handleModifiedFiles(_ content: String, _ executable: String, _ fileExtensions: [String]) {
    let lines = content.components(separatedBy: .newlines)
    let hasSubsetOfFileExtensions = { (path: String) -> Bool in
        return fileExtensions.count == 0 ? true : fileExtensions.filter({isFile($0, path)}).count > 0
    }
    if lines.filter(hasSubsetOfFileExtensions).count > 0 {
        SyncTask.execute(executable)
    }
}

func installSignalHandlers() {
    signal(SIGINT, terminateProcessTree)
}

func terminateProcessTree(pid: Int32)  {
    Log.error(closure: "\nTerminating subprocesses")
    if eventMonitor != nil {
        eventMonitor!.canMonitor = false
        eventMonitor!.terminate()
    }
    wait(nil)
}

