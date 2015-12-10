import Foundation

public struct SyncTask {
    public static func execute(launchPath: String) {
        execute(launchPath, arguments:[])
    }

    public static func execute(launchPath: String, arguments: [String]) {
        //Init Task
        let semaphore   = dispatch_semaphore_create(0)
        let task        = NSTask()
        task.launchPath = launchPath
        task.arguments  = arguments
        task.terminationHandler = { (aTask: NSTask) -> Void in
            dispatch_semaphore_signal(semaphore)
        }

        //Launch Task
        task.launch()

        //Wait for Task
        task.waitUntilExit()
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
    }
}

