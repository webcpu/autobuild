import XCTest

@testable import dep

class AutobuildTests: XCTestCase {
    let autobuild = "/Users/liang/Dropbox/OSX/autobuild/.build/debug/autobuild"
    
    func testHelp() {
        let args = [autobuild, "--help"]
        do {
            try main(args)
        } catch let error {
            XCTFail("Unexpected error")
        }
    }

    func testInvalidUsage() {
        let args = [autobuild]
        do {
            try main(args)
            XCTFail("It was expected to fail because of invalid usage")
        } catch AutobuildError.InvalidParameter(let hint) {
        } catch let error {
            XCTFail("Unexpected error, it was expected to fail because of invalid usage")
        }
    }
    
    func testInvalidUsageWithoutScript() {
        let args = [autobuild, "-s"]
        do {
            try main(args)
            XCTFail("It was expected to fail because of invalid usage")
        } catch AutobuildError.InvalidUsage {
        } catch let error {
            XCTFail("Unexpected error, it was expected to fail because of invalid usage")
        }
    }
    
    func testInvalidParameterWithInvalidScript() {
        let args = [autobuild, "-s", "NotExistingFile"]
        do {
            try main(args)
            XCTFail("It was expected to fail because of invalid usage")
        } catch AutobuildError.InvalidParameter(let hint) {
        } catch let error {
            XCTFail("Unexpected error, it was expected to fail because of invalid usage")
        }
    }

    func testInvalidParameterWithInvalidDirectory() {
        let args = [autobuild, "-s", "/bin/ls", "--chdir", "NotExistDirectory"]
        do {
            try main(args)
            XCTFail("It was expected to fail because of invalid usage")
        } catch AutobuildError.InvalidParameter(let hint) {
        } catch let error {
            XCTFail("Unexpected error, it was expected to fail because of invalid usage")
        }
    }
}

