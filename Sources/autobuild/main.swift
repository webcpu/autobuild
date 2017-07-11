import Foundation
import dep

let args        = Array(CommandLine.arguments)
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


