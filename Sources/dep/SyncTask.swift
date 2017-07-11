import Foundation

public struct SyncTask {
    public static func execute(_ launchPath: String) {
        execute(launchPath, arguments:[])
    }

    public static func execute(_ launchPath: String, arguments: [String]) {
        //Init Task
        let semaphore   = DispatchSemaphore(value: 0)
        let task        = Process()
        task.launchPath = launchPath
        task.arguments  = arguments
        task.terminationHandler = { (aTask: Process) -> Void in
            semaphore.signal()
        }

        //Launch Task
        task.launch()

        //Wait for Task
        task.waitUntilExit()
        semaphore.wait(timeout: DispatchTime.distantFuture)
    }
}

