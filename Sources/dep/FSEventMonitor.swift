import Foundation
import libc
import POSIX
import HaskellSwift

public extension NSString {
    func rstrip() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.newlineCharacterSet())
    }
}

public struct FSEventMonitor {
    public let task: NSTask
    public var canMonitor = true
    public let action: String -> Void

    public init(arguments: [String], action: String -> Void) {
        self.action     = action

        task                = NSTask()
        task.launchPath     = fswatchPath()
        task.arguments      = arguments
        task.standardOutput = NSPipe()
    }

    func fswatchPath() -> String? {
        guard let path = which("fswatch") else {
            print("Please install fswatch at first:")
            print("brew install fswatch")
            exit(1)
        }
        return path.rstrip()
    }

    public func run() {
        task.terminationHandler = { (aTask: NSTask) -> Void in
            wait(nil)
            Log.error("Terminated subprocesses")
            exit(1)
        }

        Async.background {
            self.task.launch()
        }

        while (canMonitor) {
            let fileHandle  = task.standardOutput!.fileHandleForReading
            if let line     = readline(fileHandle) {
                action(line)
            }
        }
        task.terminate()
    }

    public mutating func terminate() {
        canMonitor = false
        task.terminate()
    }

    private func readline(fileHandle: NSFileHandle) -> String? {
        guard let s = NSString(data:fileHandle.availableData, encoding:NSUTF8StringEncoding) else {
            return nil
        }

        let line = s.rstrip()
        return line
    }

    private func which(program: String) -> String? {
        let s = (try? popen(["/usr/bin/which", program]))
        let line = s?.rstrip()
        return line
    }
}
