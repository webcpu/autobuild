import XCTest
@testable import dep

class SyncTaskTests: XCTestCase {
    func testLaunch() {
        SyncTask.execute("/bin/ls")
        SyncTask.execute("/bin/ls", arguments: [])
        SyncTask.execute("/bin/ls", arguments: ["./"])
    }
}

