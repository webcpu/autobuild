import XCTest

@testable import dep

class AutobuildTests: XCTestCase {
    func testOptions() {
        let args = ["/Users/liang/Dropbox/OSX/autobuild/.build/debug/autobuild",
                    "-s",
                    "/Users/liang/Dropbox/OSX/autobuild/Utilities/build.sh"]//, "--chdir", "/Users/liang/Dropbox/OSX/autobuil"]
         main(args)
    }
}

