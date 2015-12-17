import Foundation
import libc
import POSIX
import CommandLine

enum VendingMachineError: ErrorType {
    case InvalidSelection
    case InsufficientFunds(coinsNeeded: Int)
    case OutOfStock
}

public enum AutobuildError: ErrorType {
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
public func main(args: [String]) throws {
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

    guard let rootd = options.chdir.value ?? (try? getcwd()) else {
        let hint = "The project root directory is invalid"
        throw AutobuildError.InvalidParameter(hint: hint)
    }

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
    try monitor(rootd, executable: executable)
}

func isExecutableFile(path: String) -> Bool {
    let manager         = NSFileManager.defaultManager()
    var isDir: ObjCBool = false
    let fileExists      = manager.fileExistsAtPath(path, isDirectory: &isDir)
    let executable      = manager.isExecutableFileAtPath(path)
    return  fileExists && !isDir && executable
}

func isDirectory(path: String) -> Bool {
    let manager         = NSFileManager.defaultManager()
    var isDir: ObjCBool = false
    let fileExists      = manager.fileExistsAtPath(path, isDirectory: &isDir)
    return  fileExists && isDir
}

//MARK: monitor
func monitor(dir: String, executable: String) throws {
    Log.info("Start monitoring \(dir)")

    try POSIX.chdir(dir)

    installSignalHandlers()

    let lineHandler = { (line: String) in
        handleLine1(line, executable: executable)
    }

    eventMonitor = FSEventMonitor(arguments: [dir], action: lineHandler)
    eventMonitor?.run()
}

func isSwiftFile(line: String) -> Bool {
    if let ext  = NSURL(string: line)?.pathExtension?.lowercaseString {
        if ext.lowercaseString == "swift" {
            return true
        }
    }
    return false
}

func handleLine(line: String, executable: String) {
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

func handleLine1(line: String, executable: String) {
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
    Log.error("\nTerminating subprocesses")
    if eventMonitor != nil {
        eventMonitor!.canMonitor = false
        eventMonitor!.terminate()
    }
    wait(nil)
}

