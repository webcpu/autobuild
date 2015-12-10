import Foundation
import libc
import POSIX
import CommandLine
import HaskellSwift

private struct Options {
    let chdir = StringOption(shortFlag: "c",
        longFlag: "chdir",
        helpMessage: "Change working directory before any other operation")

    let executable = StringOption(shortFlag: "s",
        longFlag: "s",
        helpMessage: "Build script path")

    let help = BoolOption(shortFlag: "h",
        longFlag: "help",
        helpMessage: "Print the help message")
}

var eventMonitor : FSEventMonitor? = nil

//MARK: main
public func main(args: [String]) {
    let cli         = CommandLine(arguments: args)
    let options     = Options()
    cli.addOptions(options.help, options.chdir, options.executable)

    //parse options
    do {
        try cli.parse()
    } catch {
        cli.printUsage(error)
        exit(EX_USAGE)
    }

    //validate arguments
    let rootd      = options.chdir.value ?? (try? getcwd())
    guard let executable = options.executable.value  else {
        let hint = "please use use -s to indicate the build script path"
        print(hint)
        exit(1)
    }

    //monitor file changes
    do {
        try monitor(rootd!, executable: executable)
    } catch {
        print("autobuild:", error)
        exit(1)
    }
}

//MARK: monitor
func monitor(dir: String, executable: String) throws {
    Log.info("Start monitoring \(dir)")

    try POSIX.chdir(dir)

    installSignalHandlers()

    let lineHandler = { (line: String) in
        handleLine(line, executable: executable)
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

