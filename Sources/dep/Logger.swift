import Foundation

    
struct ConsoleColor {
    private static let escape   = "\u{001b}"
    private static let reset    = escape + "[0m"
    private static let blue     = escape + "[34m"
    private static let red      = escape + "[31m"
    private static let white    = escape + "[37m"
    private static let yellow   = escape + "[33m"
    private static let magenta  = escape + "[35m"
    private static let cyan     = escape + "[36m"

    static let verbose  = cyan
    static let debug    = blue
    static let info     = white
    static let warning  = yellow
    static let error    = red
    static let severe   = magenta
}

public struct Log {
    private static func log(@autoclosure closure: () -> String?, color: String) {
        let s       = closure() ?? "nil"
        let text    = color + s +  ConsoleColor.reset
        print(text)
    }

    public static func verbose(@autoclosure closure: () -> String?) {
        log(closure, color: ConsoleColor.verbose)
    }

    public static func debug(@autoclosure closure: () -> String?) {
        log(closure, color: ConsoleColor.debug)
    }

    public static func info(@autoclosure closure: () -> String?) {
        log(closure, color: ConsoleColor.info)
    }

    public static func warning(@autoclosure closure: () -> String?) {
        log(closure, color: ConsoleColor.warning)
    }

    public static func error(@autoclosure closure: () -> String?) {
        log(closure, color: ConsoleColor.error)
    }

    static func severe(@autoclosure closure: () -> String?) {
        log(closure, color: ConsoleColor.severe)
    }
}
