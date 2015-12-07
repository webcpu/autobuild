import Foundation

import libc
import POSIX
import CommandLine
import HaskellSwift

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

func popen(arguments: [String], lineHandler: String -> Void) {
    let task        = initTask(arguments)
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
        task.launch()
        dispatch_async(dispatch_get_main_queue(), {
            print("Task is termintated")
        })
    })
    
    //let handler = { (line: String) in
    //if let ext  = NSURL(string: line)?.pathExtension?.lowercaseString {
    //if ext.lowercaseString == "swift" {
    //print(line)
    //}
    //}
    //}
    
    while (true) {
        if let name = readline(task.standardOutput!.fileHandleForReading) {
            lineHandler(name)
        }
    }
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

func monitorFSEvents(dir: String, executable: String?) {
    guard let fswatch = which("fswatch") else {
        print("Please install fswatch at first:")
        print("brew install fswatch")
        exit(1)
    }
    
    let arguments = [fswatch.rstrip(), dir] //"/Users/liang/Dropbox/OSX/autobuild"]
    print("Start monitoring \(dir)")
   
    let lineHandler = { (line: String) in
        if let ext  = NSURL(string: line)?.pathExtension?.lowercaseString {
            if ext.lowercaseString == "swift" {
                print(line)
                if executable != nil {
                    _ = try? popen([executable!])
                }
            }
        }
    }
    //popen(arguments, lineHandler: lineHandler)
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
do {
    try main(args)
} catch {
    print("autobuild:", error)
    exit(1)
}


