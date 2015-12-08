import Foundation

import libc
import POSIX
import dep
import CommandLine
import HaskellSwift

public var globalCanFswatch = true
public var globalFswatchTask : NSTask? = nil

public extension NSString {
    func rstrip() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.newlineCharacterSet())
    }
}

func which(program: String) -> String? {
    let s = (try? popen(["/usr/bin/which", program]))
    let line = s?.rstrip()
    return line
}

func readline(fileHandle: NSFileHandle) -> String? {
    guard let line = NSString(data:fileHandle.availableData, encoding:NSUTF8StringEncoding) else {
        return nil
    }
    
    let name = line.rstrip()
    return name
}

func initTask(arguments: [String]) -> NSTask {
    let task        = NSTask()
    task.launchPath = head(arguments)
    task.arguments  = tail(arguments)
    task.standardOutput = NSPipe()

    return task
}

func monitor(arguments: [String], action: String -> Void) {
    let task        = initTask(arguments)

    task.terminationHandler = { (aTask: NSTask) -> Void in
        wait(nil)
        Log.error("Terminated subprocesses")
        exit(1)
    }

    globalFswatchTask = task
    Async.background {
        task.launch()
    }

    while (globalCanFswatch) {
        let fileHandle  = task.standardOutput!.fileHandleForReading
        if let line     = readline(fileHandle) {
            action(line)
        }
    }
    task.terminate()
}

private struct Options {
    let chdir = StringOption(shortFlag: "c",
        longFlag: "chdir",
        helpMessage: "Change working directory before any other operation")
    
    let executable = StringOption(shortFlag: "e",
        longFlag: "execute",
        helpMessage: "Execute build script for each file change")
    
    let help = BoolOption(shortFlag: "h",
        longFlag: "help",
        helpMessage: "Print the help message")
}

func shouldExecute(line: String) -> Bool {
    if let ext  = NSURL(string: line)?.pathExtension?.lowercaseString {
        if ext.lowercaseString == "swift" {
            return true
        }
    }
    return false
}

func executeSyncTask(executable: String) {
    print(executable)
    let notified    = dispatch_semaphore_create(0)
    let task        = NSTask()
    task.launchPath = executable
    task.terminationHandler = { (aTask: NSTask) -> Void in
        dispatch_semaphore_signal(notified)
    }
    
    task.launch()
    task.waitUntilExit()
    
    dispatch_semaphore_wait(notified, DISPATCH_TIME_FOREVER)
}

func handleLine(line: String, executable: String?) {
    if executable != nil && !shouldExecute(line) {
        return
    }
    
    print(line)
    executeSyncTask(executable!)
}

func monitorFSEvents(dir: String, executable: String?) {
    guard let fswatch = which("fswatch") else {
        print("Please install fswatch at first:")
        print("brew install fswatch")
        exit(1)
    }
    
    let arguments = [fswatch.rstrip(), dir]
    Log.info("Start monitoring \(dir)")
    
    let lineHandler = { (line: String) in
        handleLine(line, executable: executable)
    }
    
    monitor(arguments, action: lineHandler)
}

func main(args: [String]) throws {
    let cli         = CommandLine(arguments: args)
    let options     = Options()
    cli.addOptions(options.help, options.chdir, options.executable)
    
    do {
        try cli.parse()
    } catch {
        cli.printUsage(error)
        exit(EX_USAGE)
    }
    
    if let dir = options.chdir.value {
        try POSIX.chdir(dir)
    }
    
    guard let rootd = options.chdir.value ?? (try? getcwd()) else {
        print("please use -c to indicate the root directory of your project")
        exit(1)
    }
    
    monitorFSEvents(rootd, executable: options.executable.value)
}

//let args        = Array(Process.arguments)
let args = ["/Users/liang/Dropbox/OSX/autobuild/.build/debug/autobuild", "-e", "/Users/liang/Dropbox/OSX/autobuild/Utilities/build.sh"]//, "--chdir", "/Users/liang/Dropbox/OSX/autobuil"]
print(args)

func ignoreterm(_: Int32)  {
    print("term")
}

func ignoreint(pid: Int32)  {
    Log.error("\nTerminating subprocesses")
    globalCanFswatch = false
    if globalFswatchTask != nil {
        globalFswatchTask!.terminate()
    }
    wait(nil)
}

signal(SIGTERM, ignoreterm)
signal(SIGINT, ignoreint)

do {
    try main(args)
} catch {
    print("autobuild:", error)
    exit(1)
}

