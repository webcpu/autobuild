import XCTest

@testable import dep

//class LogTests: XCTestCase , XCTestCaseProvider {

class LogTests: XCTestCase {
    //var allTests : [(String, () -> ())] {
        //return [
            //("testError", testError)
        //]
    //}
    func testVerbose() {
        Log.verbose("verbose")
    }

    func testDebug() {
        Log.debug("debug")
    }

    func testInfo() {
        Log.info("info")
    }

    func testWarning() {
        Log.warning("warning")
    }

    func testError() {
        Log.error("error")
    }

    func testSevere() {
        Log.error("severe")
    }
}
