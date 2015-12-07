//
//  Data.Char.swift
//  HaskellSwift
//
//  Created by Liang on 28/08/2015.
//  Copyright © 2015 Liang. All rights reserved.
//

import Foundation

//MARK: isControl :: Char -> Bool
public func isControl(c: Character) -> Bool {
     //These characters are specifically the Unicode values U+0000 to U+001F and U+007F to U+009F.
    let charSet = NSCharacterSet.controlCharacterSet()
    return isCharacter(c, charSet)
}

//MARK: isSpace :: Char -> Bool
public func isSpace(c: Character) -> Bool {
    //a character set containing only the in-line whitespace characters space (U+0020) and tab (U+0009).
    //https://en.wikipedia.org/wiki/ASCII
    let charSet = NSCharacterSet.whitespaceCharacterSet()  // \v     \f
    return isCharacter(c, charSet) || elem(c, ["\n", "\r", "\u{b}", "\u{c}"])
}

//MARK: isLower :: Char -> Bool
public func isLower(c: Character) -> Bool {
    let charSet = NSCharacterSet.lowercaseLetterCharacterSet()
    return isCharacter(c, charSet)
}

//MARK: isUpper :: Char -> Bool
public func isUpper(c: Character) -> Bool {
    let charSet = NSCharacterSet.uppercaseLetterCharacterSet()
    return isCharacter(c, charSet)
}

//MARK: isAlpha :: Char -> Bool
public func isAlpha(c: Character) -> Bool {
    let charSet = NSCharacterSet.letterCharacterSet()
    return isCharacter(c, charSet)
}

//MARK: isAlphaNum :: Char -> Bool
public func isAlphaNum(c: Character) -> Bool {
    let charSet = NSCharacterSet.alphanumericCharacterSet()
    return isCharacter(c, charSet)
}

//MARK: isPrint :: Char -> Bool
public func isPrint(c: Character) -> Bool {
    return isAlphaNum(c) || isPunctuation(c) || isSymbol(c) || isSpace(c)
}

//MARK: isDigit :: Char -> Bool
public func isDigit(c: Character) -> Bool {
    let charSet = NSCharacterSet.decimalDigitCharacterSet()
    return isCharacter(c, charSet)
}

//MARK: isOctDigit :: Char -> Bool
public func isOctDigit(c: Character) -> Bool {
    return elem(c, "01234567")
}

//MARK: isHexDigit :: Char -> Bool
public func isHexDigit(c: Character) -> Bool {
    return elem(c, "0123456789ABCDEFabcdef")
}

//MARK: isLetter :: Char -> Bool
public func isLetter(c: Character) -> Bool {
    return isAlpha(c)
}

////MARK: isMark :: Char -> Bool
//public func isMark(c: Character) -> Bool {
//}

////MARK: isNumber :: Char -> Bool
//public func isNumber(c: Character) -> Bool {
//}

//MARK: isPunctuation :: Char -> Bool
public func isPunctuation(c: Character) -> Bool {
    let charSet = NSCharacterSet.punctuationCharacterSet()
    return isCharacter(c, charSet)
}

//MARK: isSymbol :: Char -> Bool
public func isSymbol(c: Character) -> Bool {
    let charSet = NSCharacterSet.symbolCharacterSet()
    return isCharacter(c, charSet)
}

//MARK: isSeparator :: Char -> Bool
public func isSeparator(c: Character) -> Bool {
    //LineSeparator, ParagraphSeparator
    return isSpace(c) || elem(c, charsetWithScalars([0x2028, 0x2029]))
}

//MARK: isAscii :: Char -> Bool
public func isAscii(c: Character) -> Bool {
    return elem(c, charsetWithScalars(Array(0...127)))
}

//MARK: isLatin1 :: Char -> Bool
public func isLatin1(c: Character) -> Bool {
    return elem(c, charsetWithScalars(Array(0...255)))
}

//MARK: isAsciiUpper :: Char -> Bool
public func isAsciiUpper(c: Character) -> Bool {
    return elem(c, "ABCDEFGHIJKLMNOPQRSTUVWXYZ")
}

//MARK: isAsciiLower :: Char -> Bool
public func isAsciiLower(c: Character) -> Bool {
    return elem(c, "abcdefghijklmnopqrstuvwxyz")
}

////MARK: generalCategory :: Char -> GeneralCategory
//public func generalCategory(c: Character) -> Bool {
//    let charSet = NSCharacterSet.uppercaseLetterCharacterSet()
//    return isCharacter(c, charSet)
//}

//MARK: toUpper :: Char -> Char
public func toUpper(c: Character) -> Character {
    return head(String(c).uppercaseString)
}

//MARK: toLower :: Char -> Char
public func toLower(c: Character) -> Character {
    return head(String(c).lowercaseString)
}

//MARK: toTitle :: Char -> Char
public func toTitle(c: Character) -> Character {
    return head(String(c).capitalizedString)
}

//MARK: digitToInt :: Char -> Int
public func digitToInt(c: Character) -> Int {
    assert(isHexDigit(c), "Not a hex digit")
    let ints: [Character : Int] = ["0":0, "1":1, "2":2, "3":3, "4":4, "5":5, "6":6, "7":7, "8":8, "9":9, "a":10, "b":11, "c":12, "d":13, "e":14, "f":15]
    return ints[toLower(c)]!
}

//MARK: intToDigit :: Int -> Char
public func intToDigit(i: Int) -> Character {
    assert(i >= 0 && i < 16, "Not a hex")
    let hexDigits : [Character] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"]
    return hexDigits[i]
}

//MARK: ord :: Char -> Int
public func ord(c: Character) -> Int {
    let scalars = String(c).unicodeScalars
    return Int(scalars[scalars.startIndex].value)
}

//MARK: chr :: Int -> Char
public func chr(i: Int) -> Character {
    return Character(UnicodeScalar(i))
}

//MARK: showLitChar :: Char -> ShowS
//It can not convert all of unprintable to printable characters.
public func showLitChar(c: Character, _ xs: String) -> String {
    var x = String(c)
    switch c {
    case "\0":
        x = "\\0"
    case "\"":
        x = "\\\""
    case "\'":
        x = "\\\'"
    case "\n":
        x = "\\n"
    case "\\":
        x = "\\\\"
    case "\r":
        x = "\\r"
    case "\t":
        x = "\\t"
    default:
        break
    }
    return x + xs
}

////MARK: lexLitChar :: ReadS String
//public func lexLitChar(c: Character) -> Bool {
//    let charSet = NSCharacterSet.uppercaseLetterCharacterSet()
//    return isCharacter(c, charSet)
//}
//
////MARK: readLitChar :: ReadS Char
//public func readLitChar(c: Character) -> Bool {
//    let charSet = NSCharacterSet.uppercaseLetterCharacterSet()
//    return isCharacter(c, charSet)
//}

//MARK: Internal Utilties
func isCharacter(c: Character, _ charset: NSCharacterSet) -> Bool {
    return String(c).rangeOfCharacterFromSet(charset) != nil
}

func charsetWithScalars(xs: [Int]) -> String {
    return concat(charactersWithScalars(xs))
}

func charactersWithScalars(xs: [Int]) -> [Character] {
    return map({ x in Character(UnicodeScalar(x))}, xs)
}