import Foundation
import libc
import POSIX
import CommandLine

enum VendingMachineError: Swift.Error {
    case InvalidSelection
    case InsufficientFunds(coinsNeeded: Int)
    case OutOfStock
}

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
        helpMessage: "Build script path")

    let help = BoolOption(shortFlag: "h",
        longFlag: "help",
        helpMessage: "Print the help message")
}

var eventMonitor : FSEventMonitor? = nil

//MARK: main
public func main(_ args: [String]) throws {
    let cli         = CommandLine(arguments: args)
    let options     = Options()
    cli.addOptions(options.chdir, options.executable, options.help)

    //parse options
    do {
        try cli.parse()
    } catch {
        cli.printUsage(error)
        throw AutobuildError.InvalidUsage
    }

    //validate arguments
    if options.help.value {
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

    //Check if file exsists.
    if !isExecutableFile(executable) {
        let hint = "The build script isn't executable or doesn't exist"
        throw AutobuildError.InvalidParameter(hint: hint)
    }

    //Monitor file changes
    try monitor(rootd, executable)
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
func monitor(_ dir: String, _ executable: String) throws {
    Log.info("Start monitoring \(dir)")

    try POSIX.chdir(dir)

    installSignalHandlers()

    let lineHandler = { (line: String) in
        handleLine1(line, executable)
    }

    eventMonitor = FSEventMonitor(arguments: [dir], action: lineHandler)
    eventMonitor?.run()
}

func isSwiftFile(_ line: String) -> Bool {
    let ext  = URL(fileURLWithPath: line).pathExtension.lowercased()
    print(ext)
    return  ext == "swift"
}

func handleLine(_ line: String, _ executable: String) {
    if !isSwiftFile(line) {
        return
    }

    print(line)
    //SyncTask.execute(executable)
    let arguments = [executable]
    try? popen(arguments, redirectStandardError: true, environment:[:]) { line in
        print(line)
        print(line.characters.count)
    }
}

func handleLine1(_ line: String, _ executable: String) {
    if !isSwiftFile(line) {
        return
    }

    print(line)
    SyncTask.execute(executable)
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

