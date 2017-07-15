import Foundation
import libc
import POSIX

public extension NSString {
    func rstrip() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.newlines)
    }
}

public struct FSEventMonitor {
    public let task: Process
    public var canMonitor = true
    public let action: (String) -> Void

    public init(arguments: [String], action: @escaping (String) -> Void) {
        self.action     = action

        task                = Process()
        task.launchPath     = fswatchPath()
        task.arguments      = arguments
        task.standardOutput = Pipe()
    }

    func fswatchPath() -> String? {
        var path    = which("fswatch")
        if path == nil {
            let defaultPath = "/usr/local/bin/fswatch"
            let result  = isExecutableFile(defaultPath)
            if result == true {
                path = defaultPath
            } else {
                print("Please install fswatch at first:")
                print("brew install fswatch")
                abort()
            }
        }

        return path!.rstrip()
    }

    public func run() {
        task.terminationHandler = { (aTask: Process) -> Void in
            wait(nil)
            Log.error(closure: "Terminated subprocesses")
            abort()
        }

        Async.background {
            self.task.launch()
        }

        while (canMonitor) {
            let fileHandle  = (task.standardOutput! as AnyObject).fileHandleForReading
            if let line     = readline(fileHandle: fileHandle!) {
                action(line)
            }
        }
        task.terminate()
    }

    public mutating func terminate() {
        canMonitor = false
        task.terminate()
    }

    private func readline(fileHandle: FileHandle) -> String? {
        guard let s = NSString(data:fileHandle.availableData, encoding:String.Encoding.utf8.rawValue) else {
            return nil
        }

        let line = s.rstrip()
        return line
    }

    private func which(_ program: String) -> String? {
        let s = (try? popen(["/usr/bin/which", program]))
        let line = s?.rstrip()
        return line
    }
}
