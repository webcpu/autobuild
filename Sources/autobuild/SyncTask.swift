import Foundation

public struct SyncTask {
    public static func execute(_ launchPath: String) {
        execute(launchPath, [])
    }

    public static func execute(_ launchPath: String, _ arguments: [String]) {
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
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }
}

