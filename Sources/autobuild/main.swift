import Foundation
import dep

//let args        = Array(Process.arguments)
let args = ["/Users/liang/Dropbox/OSX/autobuild/.build/debug/autobuild", "-e", "/Users/liang/Dropbox/OSX/autobuild/Utilities/build.sh"]//, "--chdir", "/Users/liang/Dropbox/OSX/autobuil"]
print(args)
do {
    try main(args)
} catch AutobuildError.InvalidParameter(let hint) {
    print(hint)
    exit(1)
} catch let error {
    print("autobuild:", error)
    exit(1)
}
