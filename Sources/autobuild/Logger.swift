
import Foundation

    
struct ConsoleColor {
    static let escape   = "\u{001b}"
    static let reset    = escape + "[0m"
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
    private static func log(_ closure: @autoclosure () -> String?, _ color: String) {
        let s       = closure() ?? "nil"
        let text    = color + s +  ConsoleColor.reset
        print(text)
    }

    public static func verbose(_ closure: @autoclosure () -> String?) {
        log(closure(), ConsoleColor.verbose)
    }

    public static func debug(_ closure: @autoclosure () -> String?) {
        log(closure(), ConsoleColor.debug)
    }

    public static func info(_ closure: @autoclosure () -> String?) {
        log(closure(), ConsoleColor.info)
    }

    public static func warning(_ closure: @autoclosure () -> String?) {
        log(closure(), ConsoleColor.warning)
    }

    public static func error( closure: @autoclosure () -> String?) {
        log(closure(), ConsoleColor.error)
    }

    static func severe( closure: @autoclosure () -> String?) {
        log(closure(), ConsoleColor.severe)
    }
}
