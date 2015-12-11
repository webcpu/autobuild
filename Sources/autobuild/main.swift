import Foundation
import dep

let args        = Array(Process.arguments)
//let args = ["/Users/liang/Dropbox/OSX/autobuild/", "-s", "/Users/liang/Dropbox/OSX/autobuild/Utilities/build.sh"]//, "--chdir", "/Users/liang/Dropbox/OSX/autobuil"]
print(args)
do {
    try main(args)
} catch AutobuildError.InvalidUsage {
    exit(1)
} catch AutobuildError.InvalidParameter(let hint) {
    print(hint)
    exit(1)
} catch let error {
    print("autobuild:", error)
    exit(1)
}

