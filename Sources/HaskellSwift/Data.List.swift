//
//  DataList.swift
//  HaskellSwift
//
//  Created by Liang on 14/08/2015.
//  Copyright © 2015 Liang. All rights reserved.
//

import Foundation

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#endif

public enum Ordering {
    case LT
    case EQ
    case GT
}

infix operator • { associativity right precedence 100}
func •<A,B,C>(f2: B->C, f1: A->B) -> (A->C) {
    return { (x: A) in f2(f1(x)) }
}

infix operator .. { associativity right precedence 100}
//A->B->C
public func ..<A,B,C>(f2: B->C, f1: A->B) -> (A->C) {
    return { (x: A) in f2(f1(x)) }
}

//A->B-C?
public func ..<A,B,C>(f2: B->C?, f1: A->B) -> (A->C?) {
    return { (x: A) in f2(f1(x)) }
}

//A->B?-C
public func ..<A,B,C>(f2: B?->C, f1: A->B?) -> (A->C) {
    return { (x: A) in f2(f1(x)) }
}

//A->B?-C?
public func ..<A,B,C>(f2: B?->C?, f1: A->B?) -> (A->C?) {
    return { (x: A) in f2(f1(x)) }
}

//A?->B->C
public func ..<A,B,C>(f2: B->C, f1: A?->B) -> (A?->C) {
    return { (x: A?) in f2(f1(x)) }
}

//A?->B->C?
public func ..<A,B,C>(f2: B->C?, f1: A?->B) -> (A?->C?) {
    return { (x: A?) in f2(f1(x)) }
}

//A?->B?->C
public func ..<A,B,C>(f2: B?->C, f1: A?->B?) -> (A?->C) {
    return { (x: A?) in f2(f1(x)) }
}

//A?->B?->C?
public func ..<A,B,C>(f2: B?->C?, f1: A?->B?) -> (A?->C?) {
    return { (x: A?) in f2(f1(x)) }
}

public func not(value: Bool) -> Bool {
    return !value
}

//MARK: - Basic functions
//MARK: (++) :: [a] -> [a] -> [a]
infix operator ++ {}
func ++<A>(left: [A], right: [A]) -> [A] {
    return left + right
}

func ++(left: String, right: String) -> String {
    return left + right
}

//MARK: head :: [a] -> a
public func head<T>(xs: [T]) ->T {
    assert(xs.isEmpty != true, "Empty List")
    return xs[0]
}

public func head(xs: String) -> Character {
    assert(xs.isEmpty != true, "Empty List")
    let c =  xs[xs.startIndex]
    return c
}

//MARK: last :: [a] -> a
public func last<T>(xs: [T]) ->T {
    assert(xs.isEmpty != true, "Empty List")
    return xs[xs.count - 1]
}

public func last(xs: String) -> Character {
    assert(xs.isEmpty != true, "Empty List")
    let c =  xs[xs.endIndex.predecessor()]
    return c
}

//MARK: tail :: [a] -> [a]
public func tail<T>(xs: [T])->[T] {
    var list = [T]()
    assert(xs.count > 0, "Empty List")
    if xs.count == 1 {
        return list
    }
    
    for i in 1..<(xs.count) {
        list.append(xs[i])
    }
    
    return list
}

public func tail(xs: String)->String {
    var list = String()
    assert(xs.characters.count > 0, "Empty List")
    if xs.characters.count == 1 {
        return list
    }
    
    for i in 1..<(xs.characters.count) {
        let c = xs[xs.startIndex.advancedBy(i)]
        list.append(c)
    }
    
    return list
}

//MARK: init :: [a] -> [a]
public func initx<T>(xs: [T])->[T] {
    var list = [T]()
    assert(xs.count > 0, "Empty List")
    if xs.count == 1 {
        return list
    }
    
    for i in 0..<(xs.count - 1) {
        list.append(xs[i])
    }
    
    return list
}

public func initx(xs: String)->String {
    var list = String()
    assert(xs.characters.count > 0, "Empty List")
    if xs.characters.count == 1 {
        return list
    }
    
    for i in 0..<(xs.characters.count - 1) {
        let c = xs[xs.startIndex.advancedBy(i)]
        list.append(c)
    }
    
    return list
}

//MARK: uncons :: [a] -> Maybe (a, [a])
public func uncons<A>(xs: [A]) -> (A, [A])? {
    return length(xs) > 0 ? (head(xs), tail(xs)) : nil
}

public func uncons(xs: String) -> (Character, String)? {
    return length(xs) > 0 ? (head(xs), tail(xs)) : nil
}

//MARK: null :: Foldable t => t a -> Bool
public func null<T>(xs: [T]) -> Bool {
    return xs.isEmpty
}

public func null(xs: String) -> Bool {
    return xs.characters.count == 0
}

//MARK: length :: Foldable t => t a -> Int
public func length<T>(xs: [T]) -> Int {
    return xs.count
}

public func length(xs: String) -> Int {
    return xs.characters.count
}

//MARK: - List transformations
//MARK: map :: (a -> b) -> [a] -> [b]
public func map(transform: Character->Character, _ xs: String) -> String {
    var results = String()
    for i in 0..<xs.characters.count {
        let c = xs[xs.startIndex.advancedBy(i)]
        results.append(transform(c))
    }
    
    return results
}

public func map<U>(transform: Character-> U, _ xs: String) -> [U] {
    var results = [U]()
    for i in 0..<xs.characters.count {
        let c = xs[xs.startIndex.advancedBy(i)]
        results.append(transform(c))
    }
    
    return results
}

public func map<T, U>(transform: T->U, _ xs: [T]) -> [U] {
    var results = [U]()
    for x in xs {
        results.append(transform(x))
    }
    
    return results
}

//public func map(transform: Character->Character)(_ xs: String) -> String {
//    return map(transform, xs)
//}
//
//public func map<U>(transform: Character-> U)(_ xs: String) -> [U] {
//    return map(transform, xs)
//}
//
//public func map<T, U>(transform: T->U)(_ xs: [T]) -> [U] {
//    return map(transform, xs)
//}

//MARK: reverse :: [a] -> [a]
public func reverse<T>(xs: [T]) -> [T] {
    return [T](xs.reverse())
}

public func reverse(xs: String) -> String {
    return String(xs.characters.reverse())
}

//MARK: intersperse :: a -> [a] -> [a]
public func intersperse<T>(separator: T, _ xs: [T]) -> [T] {
    if xs.count <= 1 {
        return xs
    }
    let combine = { (a: [T], b: T) -> [T] in a + [separator] + [b] }
    return foldl(combine, [xs[0]], tail(xs))
}

public func intersperse(separator: Character, _ xs: String) -> String {
    if xs.characters.count <= 1 {
        return xs
    }
    let combine = { (a: String, b: Character) -> String in a + String(separator) + String(b) }
    return foldl(combine, String(head(xs)), tail(xs))
}

//public func intersperse<T>(separator: T)(_ xs: [T]) -> [T] {
//    return intersperse(separator, xs)
//}
//
//public func intersperse(separator: Character)(_ xs: String) -> String {
//    return intersperse(separator, xs)
//}

//MARK: intercalate :: [a] -> [[a]] -> [a]
public func intercalate<T>(xs: [T], _ xss: [[T]]) -> [T] {
    return concat(intersperse(xs, xss))
}

public func intercalate(xs: String, _ xss: [String]) -> String {
    return concat(intersperse(xs, xss))
}

//MARK: transpose :: [[a]] -> [[a]]
//r * c -> c * r
public func transpose<B>(xss: [[B]]) -> [[B]] {
    var bss = [[B]]()
    
    let cols = maximumBy({ (x , y) -> Ordering in
        if x > y {
            return Ordering.GT
        } else {
            return Ordering.LT
        }}, map({ x in length(x)}, xss))
    
    for c in  0..<cols {
        var bs = [B]()
        for r in 0..<length(xss) {
            if c < length(xss[r]) {
                bs.append(xss[r][c])
            }
        }
        bss.append(bs)
    }
    
    return bss
}

public func transpose(xss: [String]) -> [String] {
    var bss = [String]()
    
    let cols = maximumBy({ (x , y) -> Ordering in
        if x > y {
            return Ordering.GT
        } else {
            return Ordering.LT
        }}, map({ x in length(x)}, xss))
    
    for c in  0..<cols {
        var bs = String()
        for r in 0..<length(xss) {
            if c < length(xss[r]) {
                let x = xss[r][xss[r].startIndex.advancedBy(c)]
                bs.append(x)
            }
        }
        bss.append(bs)
    }
    
    return bss
}

//MARK: subsequences :: [a] -> [[a]]
public func subsequences<B>(xs: [B]) -> [[B]] {
    if xs.isEmpty {
        return emptySubSequence()
    }
    
    return emptySubSequence() + nonEmptySubsequences(xs)
}

func emptySubSequence<B>() -> [[B]] {
    var r = [[B]]()
    r.append([B]())
    return r
}

func nonEmptySubsequences<B>(xs: [B]) -> [[B]] {
    if xs.isEmpty {
        return [[B]]()
    }
    
    let r0 = [head(xs)]
    let f  = { (ys: [B], r: [[B]]) -> [[B]] in [ys] + [[head(xs)] + ys] + r }
    let r1 = foldr(f, [[B]](), nonEmptySubsequences(tail(xs)))
    
    return [r0] + r1
}

public func subsequences(xs: String) -> [String] {
    if xs.isEmpty {
        return emptySubSequence()
    }
    
    return emptySubSequence() + nonEmptySubsequences(xs)
}

func emptySubSequence() -> [String] {
    var r = [String]()
    r.append(String())
    return r
}

func nonEmptySubsequences(xs: String) -> [String] {
    if xs.isEmpty {
        return [String]()
    }
    
    let r0 = String(head(xs))
    let f  = { (ys: String, r: [String]) -> [String] in [ys] + [String(head(xs)) + ys] + r }
    let r1 = foldr(f, [String](), nonEmptySubsequences(tail(xs)))
    
    return [r0] + r1
}

//MARK: permutations :: [a] -> [[a]]
public func permutations<B>(xs: [B]) -> [[B]] {
    if let (h, t) = uncons(xs) {
        let r0 = permutations(t)
        return r0 >>= { ys in between(h, ys) }
    } else {
        return [[]]
    }
}

public func permutations(xs: String) -> [String] {
    if let (h, t) = uncons(xs) {
        let r0 = permutations(t)
        return r0 >>= { (ys: String) -> [String] in between(h, ys) }
    } else {
        return [""]
    }
}

func between<A>(x: A, _ ys: [A]) -> [[A]] {
    if let (h, t) = uncons(ys) {
        return [[x] + ys] + map({[h] + $0}, between(x, t))
    } else {
        return [[x]]
    }
}

func between(x: Character, _ ys: String) -> [String] {
    if let (h, t) = uncons(ys) {
        return [String(x) + ys] + map({String(h) + $0}, between(x, t))
    } else {
        return [String(x)]
    }
}

//MARK: - Reducing lists (folds)
//MARK: foldl :: Foldable t => (a -> b -> a) -> a -> t b -> a
public func foldl<A,B>(process: (A, B)->A, _ initialValue: A, _ xs: [B]) -> A {
    assert(!xs.isEmpty, "Empty List")
    return reduce(process, initialValue, xs)
}

public func foldl(process: (String, Character)->String, _ initialValue: String, _ xs: String) -> String {
    assert(!xs.isEmpty, "Empty List")
    return reduce(process, initialValue, xs)
}

//public func foldl<A,B>(process: (A, B)->A)(_ initialValue: A)(_ xs: [B]) -> A {
//    return foldl(process, initialValue, xs)
//}
//
//public func foldl(process: (String, Character)->String)(_ initialValue: String)(_ xs: String) -> String {
//    return foldl(process, initialValue, xs)
//}

//MARK: foldl1 :: Foldable t => (a -> b -> a) -> t b -> a
public func foldl1<A>(process: (A, A)->A, _ xs: [A]) -> A {
    assert(!xs.isEmpty, "Empty List")
    return foldl(process, xs[0], drop(1, xs))
}

public func foldl1(process: (String, Character)->String, _ xs: String) -> String {
    assert(xs.characters.count > 0, "Empty List")
    return foldl(process, String(xs[xs.startIndex]), drop(1, xs))
}

//public func foldl1<A>(process: (A, A)->A)(_ xs: [A]) -> A {
//    return foldl1(process, xs)
//}

//MARK: reduce :: Foldable t => (b -> a -> b) -> b -> t a -> b
public func reduce<A, B> (combine: (A, B)->A, _ initial: A, _ xs: [B]) -> A {
    var result = initial
    for x in xs {
        result = combine(result, x)
    }
    
    return result
}

public func reduce(combine: (String, Character)->String, _ initial: String, _ xs: String) -> String {
    var result = initial
    for x in xs.characters {
        result = combine(result, x)
    }
    
    return result
}

//public func reduce<A, B> (combine: (A, B)->A)(_ initial: A)(_ xs: [B]) -> A {
//    return reduce(combine, initial, xs)
//}
//
//public func reduce(combine: (String, Character)->String)(_ initial: String)(_ xs: String) -> String {
//    return reduce(combine, initial, xs)
//}

//MARK: foldr :: Foldable t => (a -> b -> b) -> b -> t a -> b
public func foldr<A,B>(process: (A, B)->B, _ initialValue: B, _ xs: [A]) -> B {
    var result = initialValue
    for x in xs.reverse() {
        result = process(x, result)
    }
    
    return result
}

public func foldr(process: (Character, String)->String, _ initialValue: String, _ xs: String) -> String {
    var result = initialValue
    for x in xs.characters.reverse() {
        result = process(x, result)
    }
    
    return result
}

//public func foldr<A,B>(process: (A, B)->B)(_ initialValue: B)(_ xs: [A]) -> B {
//    return foldr(process, initialValue, xs)
//}
//
//public func foldr(process: (Character, String)->String)(_ initialValue: String)(_ xs: String) -> String {
//    return foldr(process, initialValue, xs)
//}

//MARK: foldr1 :: Foldable t => (a -> a -> a) -> t a -> a
public func foldr1<A>(process: (A, A)->A, _ xs: [A]) -> A {
    assert(!xs.isEmpty, "Empty List")
    return foldr(process, xs[xs.count-1], take(xs.count - 1, xs))
}

public func foldr1(process: (Character, String)->String, _ xs: String) -> String {
    assert(xs.characters.count > 0, "Empty List")
    return foldr(process, String(xs[xs.endIndex.predecessor()]), take(xs.characters.count - 1, xs))
}

//public func foldr1<A>(process: (A, A)->A)(_ xs: [A]) -> A {
//    return foldr1(process, xs)
//}
//
//public func foldr1(process: (Character, String)->String)(_ xs: String) -> String {
//    return foldr1(process, xs)
//}

//MARK: - Building lists
//MARK: Scans
//MARK: scanl :: (b -> a -> b) -> b -> [a] -> [b]
public func scanl<A,B>(combine: (A, B)->A, _ initialValue: A, _ xs: [B]) -> [A] {
    assert(!xs.isEmpty, "Empty List")
    var ys      = [A]()
    var value   = initialValue
    for x in xs {
        value  = combine(value, x)
        ys.append(value)
    }
    
    return ys
}

public func scanl(combine: (String, Character)->String, _ initialValue: String, _ xs: String) -> [String] {
    assert(!xs.isEmpty, "Empty List")
    var ys      = [String]()
    var value   = initialValue
    for x in xs.characters {
        value  = combine(value, x)
        ys.append(value)
    }
    
    return ys
}

//public func scanl<A,B>(combine: (A, B)->A)( _ initialValue: A)( _ xs: [B]) -> [A] {
//    return scanl(combine, initialValue, xs)
//}
//
//public func scanl(combine: (String, Character)->String)( _ initialValue: String)( _ xs: String) -> [String] {
//    return scanl(combine, initialValue, xs)
//}

//MARK: scanl' :: (b -> a -> b) -> b -> [a] -> [b]
//MARK: scanl1 :: (a -> a -> a) -> [a] -> [a]
public func scanl1<A>(combine: (A, A)->A, _ xs: [A]) -> [A] {
    assert(!xs.isEmpty, "Empty List")
    if xs.count == 1 {
        return xs
    }
    return [xs[0]] + scanl(combine, xs[0], drop(1, xs))
}

public func scanl1(combine: (String, Character)->String, _ xs: String) -> [String] {
    assert(xs.characters.count > 0, "Empty List")
    if xs.characters.count == 1 {
        return [xs]
    }
    let result = scanl(combine, String(xs[xs.startIndex]), drop(1, xs))
    return [String(xs[xs.startIndex])] + result
}

//public func scanl1<A>(combine: (A, A)->A)( _ xs: [A]) -> [A] {
//    return scanl1(combine, xs)
//}
//
//public func scanl1(combine: (String, Character)->String)( _ xs: String) -> [String] {
//    return scanl1(combine, xs)
//}

//MARK: scanr :: (a -> b -> b) -> b -> [a] -> [b]
public func scanr<A,B>(combine: (A, B)->B, _ initialValue: B, _ xs: [A]) -> [B] {
    assert(!xs.isEmpty, "Empty List")
    var ys      = [B]()
    var value   = initialValue
    for x in xs.reverse() {
        value  = combine(x, value)
        ys.append(value)
    }
    
    return ys
}

public func scanr(combine: (Character, String)->String, _ initialValue: String, _ xs: String) -> [String] {
    assert(!xs.isEmpty, "Empty List")
    var ys      = [String]()
    var value   = initialValue
    for x in xs.characters.reverse() {
        value  = combine(x, value)
        ys.append(value)
    }
    
    return ys
}

//public func scanr<A,B>(combine: (A, B)->B)( _ initialValue: B)( _ xs: [A]) -> [B] {
//    return scanr(combine, initialValue, xs)
//}
//
//public func scanr(combine: (Character, String)->String)( _ initialValue: String)( _ xs: String) -> [String] {
//    return scanr(combine, initialValue, xs)
//}

//MARK: scanr1 :: (a -> a -> a) -> [a] -> [a]
public func scanr1<A>(combine: (A, A)->A, _ xs: [A]) -> [A] {
    assert(!xs.isEmpty, "Empty List")
    if xs.count == 1 {
        return xs
    }
    let ys = scanr(combine, last(xs), take(xs.count - 1, xs))
    return [last(xs)] + ys
}

public func scanr1(combine: (Character, String)->String, _ xs: String) -> [String] {
    assert(xs.characters.count > 0, "Empty List")
    if xs.characters.count == 1 {
        return [xs]
    }
    let ys = scanr(combine, String(last(xs)), take(xs.characters.count - 1, xs))
    return [String(last(xs))] + ys
}

//public func scanr1<A>(combine: (A, A)->A)( _ xs: [A]) -> [A] {
//    return scanr1(combine, xs)
//}
//
//public func scanr1(combine: (Character, String)->String)( _ xs: String) -> [String] {
//    return scanr1(combine, xs)
//}
//MARK: - Accumulating maps
//MARK: mapAccumL :: Traversable t => (a -> b -> (a, c)) -> a -> t b -> (a, t c)
//MARK: mapAccumR :: Traversable t => (a -> b -> (a, c)) -> a -> t b -> (a, t c)

//MARK: Infinite lists
//MARK: iterate :: (a -> a) -> a -> [a]
//MARK: repeat :: a -> [a]

//MARK: replicate :: Int -> a -> [a]
public func replicate<A>(len: Int, _ value: A) -> [A] {
    return [A].init(count: len, repeatedValue: value)
}

//public func replicate<A>(len: Int)( _ value: A) -> [A] {
//    return replicate(len, value)
//}

//MARK: cycle :: [a] -> [a]

//MARK: - Unfolding
//MARK: unfoldr :: (b -> Maybe (a, b)) -> b -> [a]
public func unfoldr<A,B>(f: B -> (A, B)?, _ seed: B) -> [A] {
    var xs  = [A]()
    var b   = seed
    repeat {
        let r    = f(b)
        guard r != nil else {
            break;
        }
        xs.append(r!.0)
        b       = r!.1
    } while (true)
    
    return xs
}

//public func unfoldr<A,B>(f: B -> (A, B)?)( _ seed: B) -> [A] {
//    return unfoldr(f, seed)
//}

//MARK: - Sublists
//MARK: Extracting sublists
//MARK: take :: Int -> [a] -> [a]
public func take<T>(len: Int, _ xs: [T]) -> [T] {
    assert(len >= 0 , "Illegal Length")
    var list = [T]()
    if len == 0 {
        return list
    }
    
    if len >= xs.count {
        return xs
    }
    
    for i in 0..<len {
        list.append(xs[i])
    }
    
    return list
}

//public func take<T>(len: Int)( _ xs: [T]) -> [T] {
//    return take(len, xs)
//}

//MARK: - Special folds
//MARK: concat :: Foldable t => t [a] -> [a]
public func concat<A> (xss: [[A]]) -> [A] {
    // assert(xs.count >= 0 , "Illegal Length")
    var xs = [A]()
    if xss.isEmpty {
        return xs
    }
    
    let process = { (a : [A], b: [A]) in a + b }
    xs          = foldl(process, xs, xss)
    
    return xs
}

public func concat (xss: [String]) -> String {
    var xs = String()
    if xss.isEmpty {
        return xs
    }
    
    let process = { (a : String, b: String) in a + b }
    xs          = foldl(process, xs, xss)
    
    return xs
}

public func concat (xss: [Character]) -> String {
    var xs = String()
    if xss.isEmpty {
        return xs
    }
    
    let process = { (a : String, b: Character) in a + String(b) }
    xs          = foldl(process, xs, xss)
    
    return xs
}
//MARK: concatMap :: Foldable t => (a -> [b]) -> t a -> [b]
public func concatMap<A, B> (process: A->[B], _ xs: [A]) -> [B] {
    // assert(xs.count >= 0 , "Illegal Length")
    
    var xss          = [[B]]()
    for x in xs {
        xss.append(process(x))
    }
    
    let results      = concat(xss)
    
    return results
}

public func concatMap(process: Character->String, _ xs: [Character]) -> String {
    // assert(xs.count >= 0 , "Illegal Length")
    
    var xss          = [String]()
    for x in xs {
        xss.append(process(x))
    }
    
    let results      = concat(xss)
    
    return results
}

//MARK: and :: Foldable t => t Bool -> Bool
public func and(xs: [Bool]) -> Bool {
    for x in xs {
        if x == false {
            return false
        }
    }
    return true
}

//MARK: or :: Foldable t => t Bool -> Bool
public func or(xs: [Bool]) -> Bool {
    for x in xs {
        if x {
            return true
        }
    }
    return false
}

//MARK: any :: Foldable t => (a -> Bool) -> t a -> Bool
public func any<A>(process: A->Bool, _ xs: [A]) -> Bool {
    for x in xs {
        let isMatched = process(x)
        if isMatched {
            return true
        }
    }
    return false
}

public func any(process: Character->Bool, _ xs: String) -> Bool {
    for x in xs.characters {
        let isMatched = process(x)
        if isMatched {
            return true
        }
    }
    return false
}

//MARK: all :: Foldable t => (a -> Bool) -> t a -> Bool
public func all<A>(process: A->Bool, _ xs: [A]) -> Bool {
    for x in xs {
        let isMatched = process(x)
        if !isMatched {
            return false
        }
    }
    return true
}

public func all(process: Character->Bool, _ xs: String) -> Bool {
    for x in xs.characters {
        let isMatched = process(x)
        if !isMatched {
            return false
        }
    }
    return true
}

//MARK: sum :: (Foldable t, Num a) => t a -> a
public func sum<A: IntegerType>(xs: [A]) -> A {
    return reduce(+, 0, xs)
}

public func sum(xs: [CGFloat])-> CGFloat {
    return reduce(+, 0, xs)
}

public func sum(xs: [Double])-> Double {
    return reduce(+, 0, xs)
}

public func sum(xs: [Float])-> Float {
    return reduce(+, 0, xs)
}

public protocol Arithmetic {
    func +(lhs: Self, rhs: Self) -> Self
    func *(lhs: Self, rhs: Self) -> Self
}

extension CGFloat: Arithmetic {}
extension Double: Arithmetic {}
extension Float: Arithmetic {}
extension Int: Arithmetic {}
extension Int16: Arithmetic {}
extension Int32: Arithmetic {}
extension Int64: Arithmetic {}
extension Int8: Arithmetic {}
extension UInt: Arithmetic {}
extension UInt16: Arithmetic {}
extension UInt32: Arithmetic {}
extension UInt64: Arithmetic {}
extension UInt8: Arithmetic {}

//MARK: product :: (Foldable t, Num a) => t a -> a
public func product(xs: [CGFloat])-> CGFloat {
    return reduce(*, 1, xs)
}

public func product(xs: [Double])-> Double {
    return reduce(*, 1, xs)
}

public func product(xs: [Float])-> Float {
    return reduce(*, 1, xs)
}

public func product<A: IntegerType>(xs: [A])-> A {
    return reduce(*, 1, xs)
}

//MARK: maximum :: forall a. (Foldable t, Ord a) => t a -> a
public func maximum<T: Comparable>(xs: [T])-> T {
    assert(xs.count > 0, "Empty List")
    var m = xs[0]
    
    for x in xs {
        if x > m {
            m = x
        }
    }
    return m
}

//MARK: minimum :: forall a. (Foldable t, Ord a) => t a -> a
public func minimum<T: Comparable>(xs: [T])-> T {
    assert(xs.count > 0, "Empty List")
    var m = xs[0]
    
    for x in xs {
        if x < m {
            m = x
        }
    }
    return m
}

//MARK: - Sublists
//MARK: Extracting sublists
//MARK: take :: Int -> [a] -> [a]
public func take(len: Int, _ xs: String)->String {
    var list = String()
    assert(len >= 0, "Illegal Length")
    if len == 0 {
        return list
    }
    
    if len >= xs.characters.count {
        return xs
    }
    
    for i in 0..<len {
        let c = xs[xs.startIndex.advancedBy(i)]
        list.append(c)
    }
    
    return list
}

//MARK: drop :: Int -> [a] -> [a]
public func drop<T>(len: Int, _ xs: [T]) -> [T] {
    assert(len >= 0, "Illegal Length")
    var list = [T]()
    if len == 0 {
        return xs
    }
    
    if len >= xs.count {
        return list
    }
    
    for i in len..<xs.count {
        list.append(xs[i])
    }
    
    return list
}

public func drop(len: Int, _ xs: String)->String {
    var list = String()
    assert(len >= 0, "Illegal Length")
    if len == 0 {
        return xs
    }
    
    if len >= xs.characters.count {
        return list
    }
    
    for i in len..<(xs.characters.count) {
        let c = xs[xs.startIndex.advancedBy(i)]
        list.append(c)
    }
    
    return list
}

//MARK: splitAt :: Int -> [a] -> ([a], [a])
public func splitAt<T>(len: Int, _ xs: [T]) -> ([T], [T]) {
    assert(len >= 0, "Illegal Length")
    
    let list1 = take(len, xs)
    let list2 = drop(len, xs)
    
    return (list1, list2)
}

public func splitAt(len: Int, _ xs: String)->(String, String) {
    assert(len >= 0, "Illegal Length")
    
    let list1 = take(len, xs)
    let list2 = drop(len, xs)
    
    return (list1, list2)
}

//MARK: takeWhile :: (a -> Bool) -> [a] -> [a]
public func takeWhile<U>(check: U -> Bool, _ xs: [U]) -> [U] {
    let len = lengthOfWhile(check, xs)
    return take(len, xs)
}

func lengthOfWhile<U>(check: U -> Bool, _ xs: [U]) -> Int {
    var len = 0
    for i in 0..<xs.count {
        let result = check(xs[i])
        guard result else {
            break
        }
        len = i + 1
    }
    
    return len
}

public func takeWhile(check: Character -> Bool, _ xs: String) -> String {
    let len = lengthOfWhileForString(check, xs)
    return take(len, xs)
}

func lengthOfWhileForString(check: Character -> Bool, _ xs: String) -> Int {
    var len = 0
    for i in 0..<xs.characters.count {
        let c = xs[xs.startIndex.advancedBy(i)]
        guard check(c) else {
            break
        }
        len = i + 1
    }
    return len
}

//MARK: dropWhile :: (a -> Bool) -> [a] -> [a]
public func dropWhile<U>(check: U -> Bool, _ xs: [U]) -> [U] {
    var len = 0
    for i in 0..<xs.count {
        guard check(xs[i]) else {
            len = i
            break
        }
    }
    return drop(len, xs)
}

public func dropWhile(check: Character -> Bool, _ xs: String) -> String {
    let len = lengthOfWhileForString(check, xs)
    return drop(len, xs)
}

//MARK: span :: (a -> Bool) -> [a] -> ([a], [a])
public func span<U>(check: U -> Bool, _ xs: [U]) -> ([U], [U]) {
    let len = lengthOfWhile(check, xs)
    return (take(len, xs), drop(len, xs))
}

public func span(check: Character -> Bool, _ xs: String) -> (String, String) {
    let len = lengthOfWhileForString(check, xs)
    return (take(len, xs), drop(len, xs))
}

//MARK: break :: (a -> Bool) -> [a] -> ([a], [a])
public func breakx<U>(check: U -> Bool, _ xs: [U]) -> ([U], [U]) {
    let len = lengthOfWhile({(x: U) in !check(x) }, xs)
    return (take(len, xs), drop(len, xs))
}

public func breakx(check: Character -> Bool, _ xs: String) -> (String, String) {
    let len = lengthOfWhileForString({(x: Character) in !check(x)}, xs)
    return (take(len, xs), drop(len, xs))
}

//MARK: stripPrefix :: Eq a => [a] -> [a] -> Maybe [a]
public func stripPrefix<U: Equatable>(xs: [U], _ ys: [U]) -> [U]? {
    return isPrefixOf(xs, ys) ? drop(length(xs), ys) : nil
}

public func stripPrefix(xs: String, _ ys: String) -> String? {
    return isPrefixOf(xs, ys) ? drop(length(xs), ys) : nil
}

//MARK: group :: Eq a => [a] -> [[a]]
public func group<U: Equatable>(xs: [U]) -> [[U]] {
    return groupBy({x,y in x == y}, xs)
}

public func group(xs: String) -> [String] {
    return groupBy({x,y in x == y}, xs)
}

//MARK: inits :: [a] -> [[a]]
public func inits<U>(xs: [U]) -> [[U]] {
    var result = [[U]]()
    for i in 0...xs.count {
        result.append(take(i, xs))
    }
    
    return result
}

public func inits(xs: String) -> [String] {
    var result = [String]()
    for i in 0...xs.characters.count {
        result.append(take(i, xs))
    }
    
    return result
}

//MARK: tails :: [a] -> [[a]]
public func tails<U>(xs: [U]) -> [[U]] {
    var result = [[U]]()
    for i in 0...xs.count {
        result.append(drop(i, xs))
    }
    
    return result
}

public func tails(xs: String) -> [String] {
    var result = [String]()
    for i in 0...xs.characters.count {
        result.append(drop(i, xs))
    }
    
    return result
}

//MARK: - Predicates
//MARK: isPrefixOf :: Eq a => [a] -> [a] -> Bool
public func isPrefixOf<U: Equatable>(xs1: [U], _ xs2: [U]) -> Bool {
    return take(xs1.count, xs2) == xs1
}

public func isPrefixOf(xs1: String, _ xs2: String) -> Bool {
    return take(xs1.characters.count, xs2) == xs1
}

//MARK: isSuffixOf :: Eq a => [a] -> [a] -> Bool
public func isSuffixOf<U: Equatable>(xs1: [U], _ xs2: [U]) -> Bool {
    if xs1.count > xs2.count {
        return false
    }
    
    return drop(xs2.count - xs1.count, xs2) == xs1
}

public func isSuffixOf(xs1: String, _ xs2: String) -> Bool {
    if xs1.characters.count > xs2.characters.count {
        return false
    }
    
    return drop(xs2.characters.count - xs1.characters.count, xs2) == xs1
}

//MARK: isInfixOf :: Eq a => [a] -> [a] -> Bool
public func isInfixOf<U: Equatable>(xs1: [U], _ xs2: [U]) -> Bool {
    if xs1.count > xs2.count {
        return false
    }
    
    for i in 0...xs2.count - xs1.count {
        let xs = drop(i, xs2)
        if isPrefixOf(xs1, xs) {
            return true
        }
    }
    
    return false
}

public func isInfixOf(xs1: String, _ xs2: String) -> Bool {
    if xs1.characters.count > xs2.characters.count {
        return false
    }
    
    for i in 0...xs2.characters.count - xs1.characters.count {
        let xs = drop(i, xs2)
        if isPrefixOf(xs1, xs) {
            return true
        }
    }
    
    return false
}

//MARK: isSubsequenceOf :: Eq a => [a] -> [a] -> Bool
public func isSubsequenceOf<U: Equatable>(xs1: [U], _ xs2: [U]) -> Bool {
    return elem(xs1, subsequences(xs2))
}

public func isSubsequenceOf(xs1: String, _ xs2: String) -> Bool {
    return elem(xs1, subsequences(xs2))
}

//MARK: - Searching lists
//MARK: Searching by equality
//MARK: elem :: (Foldable t, Eq a) => a -> t a -> Bool
public func elem<A: Equatable>(value: A, _ xs: [A])->Bool {
    for x in xs {
        if x == value {
            return true
        }
    }
    
    return false
}

public func elem<A: Equatable>(value: [A], _ xs: [[A]])->Bool {
    for x in xs {
        if x == value {
            return true
        }
    }
    
    return false
}

public func elem(c: Character , _ xs: String)->Bool {
    for x in xs.characters {
        if x == c {
            return true
        }
    }
    
    return false
}

//MARK: notElem :: (Foldable t, Eq a) => a -> t a -> Bool 
public func notElem<A: Equatable>(x: A, _ xs: [A])->Bool {
    return not(elem(x, xs))
}

public func notElem(x: Character, _ xs: String)->Bool {
    return not(elem(x, xs))
}

//MARK: lookup :: Eq a => a -> [(a, b)] -> Maybe b
public func lookup<A: Equatable, B: Equatable>(key: A, _ dictionary: [A:B]) -> B? {
    return dictionary[key]
}

//MARK: Searching with a predicate
//MARK: find :: Foldable t => (a -> Bool) -> t a -> Maybe a
public func find<U>(check: U -> Bool, _ xs: [U]) -> U? {
    for x in xs {
        if check(x) {
            return x
        }
    }
    
    return nil
}

public func find(check: Character -> Bool, _ xs: String) -> Character? {
    for x in xs.characters {
        if check(x) {
            return x
        }
    }
    
    return nil
}

//MARK: filter :: (a -> Bool) -> [a] -> [a]
public func filter<U>(check: U -> Bool, _ xs: [U]) -> [U] {
    var results = [U]()
    for x in xs {
        if check(x) {
            results.append(x)
        }
    }
    
    return results
}

//public func filter<U>(check: U -> Bool)(xs: [U]) -> [U] {
//    return filter(check, xs)
//}

public func filter(check: Character -> Bool, _ xs: String) -> String {
    var results = String()
    for x in xs.characters {
        if check(x) {
            results.append(x)
        }
    }
    
    return results
}

//MARK: partition :: (a -> Bool) -> [a] -> ([a], [a])
public func partition<U>(check: U -> Bool, _ xs: [U]) -> ([U], [U]) {
    let result = (filter(check, xs), filter( { x in not(check(x)) }, xs))
    return result
}

public func partition(check: Character -> Bool, _ xs: String) -> (String, String) {
    let result = (filter(check, xs), filter( { x in not(check(x)) }, xs))
    return result
}

//MARK: Indexing lists
//MARK: (!!) :: [a] -> Int -> a 

//MARK: elemIndex :: Eq a => a -> [a] -> Maybe Int
public func elemIndex<U: Equatable>(value: U, _ xs: [U]) -> Int? {
    for i in 0..<xs.count {
        if value == xs[i] {
            return i
        }
    }
    
    return nil
}

public func elemIndex(value: Character, _ xs: String) -> Int? {
    for i in 0..<xs.characters.count {
        let c =  xs[xs.startIndex.advancedBy(i)]
        if value == c {
            return i
        }
    }
    
    return nil
}

//MARK: elemIndices :: Eq a => a -> [a] -> [Int]
public func elemIndices<U: Equatable>(value: U, _ xs: [U]) -> [Int] {
    var result = [Int]()
    for i in 0..<xs.count {
        if value == xs[i] {
            result.append(i)
        }
    }
    
    return result
}

public func elemIndices(value: Character, _ xs: String) -> [Int] {
    var result = [Int]()
    for i in 0..<xs.characters.count {
        let c =  xs[xs.startIndex.advancedBy(i)]
        if value == c {
            result.append(i)
        }
    }
    
    return result
}

//MARK: findIndex :: (a -> Bool) -> [a] -> Maybe Int
public func findIndex<U>(check: U -> Bool, _ xs: [U]) -> Int? {
    for i in 0..<xs.count {
        if check(xs[i]) {
            return i
        }
    }
    
    return nil
}

public func findIndex(check: Character -> Bool, _ xs: String) -> Int? {
    for i in 0..<xs.characters.count {
        let c =  xs[xs.startIndex.advancedBy(i)]
        if check(c) {
            return i
        }
    }
    
    return nil
}
//MARK: findIndices :: (a -> Bool) -> [a] -> [Int]
public func findIndices<U: Equatable>(check: U -> Bool, _ xs: [U]) -> [Int] {
    var result = [Int]()
    for i in 0..<xs.count {
        if check(xs[i]) {
            result.append(i)
        }
    }
    
    return result
}

public func findIndices(check: Character -> Bool, _ xs: String) -> [Int] {
    var result = [Int]()
    for i in 0..<xs.characters.count {
        let c =  xs[xs.startIndex.advancedBy(i)]
        if check(c) {
            result.append(i)
        }
    }
    
    return result
}

//MARK: - Zipping and unzipping lists
//MARK: zip :: [a] -> [b] -> [(a, b)]
public func zip<A, B>(xs1: [A], _ xs2: [B]) -> [(A, B)] {
    let len = xs1.count > xs2.count ? xs1.count : xs2.count
    var result = [(A, B)]()
    for i in 0..<len {
        result.append((xs1[i], xs2[i]))
    }
    
    return result
}

//public func zip<A, B>(xs1: [A])(xs2: [B]) -> [(A, B)] {
//    return zip(xs1, xs2)
//}

//infix operator == {}
//public func == <A: Equatable> (t1: (A, A), t2: (A, A)) -> Bool{
//    return (t1.0 == t2.0) && (t1.1 == t2.1)
//}

public func compareTuples <A: Equatable, B: Equatable> (t1: (A, B), _ t2: (A, B)) -> Bool{
    return (t1.0 == t2.0) && (t1.1 == t2.1)
}

public func compareTupleArray <A: Equatable, B: Equatable> (xs1: [(A, B)], _ xs2: [(A, B)]) -> Bool{
    guard xs1.count == xs2.count else {
        return false
    }
    
    for i in 0..<xs1.count {
        let result = compareTuples(xs1[i], xs2[i])
        guard result == true else {
            return false
        }
    }
    
    return true
}

public func compareTuples <A: Equatable, B: Equatable, C: Equatable> (t1: (A, B, C), _ t2: (A, B, C)) -> Bool{
    return (t1.0 == t2.0) && (t1.1 == t2.1) && (t1.2 == t2.2)
}

public func compareTupleArray <A: Equatable, B: Equatable, C: Equatable> (xs1: [(A, B, C)], _ xs2: [(A, B, C)]) -> Bool{
    guard xs1.count == xs2.count else {
        return false
    }
    
    for i in 0..<xs1.count {
        let result = compareTuples(xs1[i], xs2[i])
        guard result == true else {
            return false
        }
    }
    
    return true
}

//MARK: zip3 :: [a] -> [b] -> [c] -> [(a, b, c)]
public func zip3<A, B, C>(xs1: [A], _ xs2: [B], _ xs3: [C]) -> [(A, B, C)] {
    let len     = min(xs1.count, xs2.count, xs3.count)
    var result  = [(A, B, C)]()
    for i in 0..<len {
        result.append((xs1[i], xs2[i], xs3[i]))
    }
    
    return result
}

//MARK: zip4 :: [a] -> [b] -> [c] -> [d] -> [(a, b, c, d)]
public func zip4<A, B, C, D>(xs1: [A], _ xs2: [B], _ xs3: [C], _ xs4: [D]) -> [(A, B, C, D)] {
    let len     = min(xs1.count, xs2.count, xs3.count, xs4.count)
    var result  = [(A, B, C, D)]()
    for i in 0..<len {
        result.append((xs1[i], xs2[i], xs3[i], xs4[i]))
    }
    
    return result
}

public func compareTuples <A: Equatable, B: Equatable, C: Equatable, D: Equatable> (t1: (A, B, C, D), _ t2: (A, B, C, D)) -> Bool{
    return (t1.0 == t2.0) && (t1.1 == t2.1) && (t1.2 == t2.2) && (t1.3 == t2.3)
}

public func compareTupleArray <A: Equatable, B: Equatable, C: Equatable, D: Equatable> (xs1: [(A, B, C, D)], _ xs2: [(A, B, C, D)]) -> Bool{
    guard xs1.count == xs2.count else {
        return false
    }
    
    for i in 0..<xs1.count {
        let result = compareTuples(xs1[i], xs2[i])
        guard result == true else {
            return false
        }
    }
    
    return true
}

//MARK: zip5 :: [a] -> [b] -> [c] -> [d] -> [e] -> [(a, b, c, d, e)]
public func zip5<A, B, C, D, E>(xs1: [A], _ xs2: [B], _ xs3: [C], _ xs4: [D], _ xs5: [E]) -> [(A, B, C, D, E)] {
    let len     = min(xs1.count, xs2.count, xs3.count, xs4.count, xs5.count)
    var result  = [(A, B, C, D, E)]()
    for i in 0..<len {
        result.append((xs1[i], xs2[i], xs3[i], xs4[i], xs5[i]))
    }
    
    return result
}

public func compareTuples <A: Equatable, B: Equatable, C: Equatable, D: Equatable, E: Equatable> (t1: (A, B, C, D, E), _ t2: (A, B, C, D, E)) -> Bool{
    return (t1.0 == t2.0) && (t1.1 == t2.1) && (t1.2 == t2.2) && (t1.3 == t2.3) && (t1.4 == t2.4)
}

public func compareTupleArray <A: Equatable, B: Equatable, C: Equatable, D: Equatable, E: Equatable> (xs1: [(A, B, C, D, E)], _ xs2: [(A, B, C, D, E)]) -> Bool{
    guard xs1.count == xs2.count else {
        return false
    }
    
    for i in 0..<xs1.count {
        let result = compareTuples(xs1[i], xs2[i])
        guard result == true else {
            return false
        }
    }
    
    return true
}

//MARK: zip6 :: [a] -> [b] -> [c] -> [d] -> [e] -> [f] -> [(a, b, c, d, e, f)]
public func zip6<A, B, C, D, E, F>(xs1: [A], _ xs2: [B], _ xs3: [C], _ xs4: [D], _ xs5: [E], _ xs6: [F]) -> [(A, B, C, D, E, F)] {
    let len     = min(xs1.count, xs2.count, xs3.count, xs4.count, xs5.count, xs6.count)
    var result  = [(A, B, C, D, E, F)]()
    for i in 0..<len {
        result.append((xs1[i], xs2[i], xs3[i], xs4[i], xs5[i], xs6[i]))
    }
    
    return result
}

public func compareTuples <A: Equatable, B: Equatable, C: Equatable, D: Equatable, E: Equatable, F: Equatable> (t1: (A, B, C, D, E, F), _ t2: (A, B, C, D, E, F)) -> Bool{
    return (t1.0 == t2.0) && (t1.1 == t2.1) && (t1.2 == t2.2) && (t1.3 == t2.3) && (t1.4 == t2.4) && (t1.5 == t2.5)
}

public func compareTupleArray <A: Equatable, B: Equatable, C: Equatable, D: Equatable, E: Equatable, F: Equatable> (xs1: [(A, B, C, D, E, F)], _ xs2: [(A, B, C, D, E, F)]) -> Bool{
    guard xs1.count == xs2.count else {
        return false
    }
    
    for i in 0..<xs1.count {
        let result = compareTuples(xs1[i], xs2[i])
        guard result == true else {
            return false
        }
    }
    
    return true
}
//MARK: zip7 :: [a] -> [b] -> [c] -> [d] -> [e] -> [f] -> [g] -> [(a, b, c, d, e, f, g)]
public func zip7<A, B, C, D, E, F, G>(xs1: [A], _ xs2: [B], _ xs3: [C], _ xs4: [D], _ xs5: [E], _ xs6: [F], _ xs7: [G]) -> [(A, B, C, D, E, F, G)] {
    let len     = min(xs1.count, xs2.count, xs3.count, xs4.count, xs5.count, xs6.count, xs7.count)
    var result  = [(A, B, C, D, E, F, G)]()
    for i in 0..<len {
        result.append((xs1[i], xs2[i], xs3[i], xs4[i], xs5[i], xs6[i], xs7[i]))
    }
    
    return result
}

public func compareTuples <A: Equatable, B: Equatable, C: Equatable, D: Equatable, E: Equatable, F: Equatable, G: Equatable > (t1: (A, B, C, D, E, F, G), _ t2: (A, B, C, D, E, F, G)) -> Bool{
    return (t1.0 == t2.0) && (t1.1 == t2.1) && (t1.2 == t2.2) && (t1.3 == t2.3) && (t1.4 == t2.4) && (t1.5 == t2.5) && (t1.6 == t2.6)
}

public func compareTupleArray <A: Equatable, B: Equatable, C: Equatable, D: Equatable, E: Equatable, F: Equatable, G: Equatable> (xs1: [(A, B, C, D, E, F, G)], _ xs2: [(A, B, C, D, E, F, G)]) -> Bool{
    guard xs1.count == xs2.count else {
        return false
    }
    
    for i in 0..<xs1.count {
        let result = compareTuples(xs1[i], xs2[i])
        guard result == true else {
            return false
        }
    }
    
    return true
}

//MARK: zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
public func zipWith<A, B, U>(process: (A, B)->U, _ xs1: [A], _ xs2: [B]) -> [U] {
    var results = [U]()
    let len = min(xs1.count, xs2.count)
    for i in 0..<len {
        let c = process(xs1[i], xs2[i])
        results.append(c)
    }
    
    return results
}

//MARK: zipWith3 :: (a -> b -> c -> d) -> [a] -> [b] -> [c] -> [d]
public func zipWith3<A, B, C, U>(process: (A, B, C)->U, _ xs1: [A], _ xs2: [B], _ xs3: [C]) -> [U] {
    var results = [U]()
    let len = min(xs1.count, xs2.count, xs3.count)
    for i in 0..<len {
        let c = process(xs1[i], xs2[i], xs3[i])
        results.append(c)
    }
    
    return results
}

//MARK: zipWith4 :: (a -> b -> c -> d -> e) -> [a] -> [b] -> [c] -> [d] -> [e]
public func zipWith4<A, B, C, D, U>(process: (A, B, C, D)->U, _ xs1: [A], _ xs2: [B], _ xs3: [C], _ xs4: [D]) -> [U] {
    var results = [U]()
    let len = min(xs1.count, xs2.count, xs3.count, xs4.count)
    for i in 0..<len {
        let u = process(xs1[i], xs2[i], xs3[i], xs4[i])
        results.append(u)
    }
    
    return results
}

//MARK: zipWith5 :: (a -> b -> c -> d -> e -> f) -> [a] -> [b] -> [c] -> [d] -> [e] -> [f]
public func zipWith5<A, B, C, D, E, U>(process: (A, B, C, D, E)->U, _ xs1: [A], _ xs2: [B], _ xs3: [C], _ xs4: [D], _ xs5: [E]) -> [U] {
    var results = [U]()
    let len = min(xs1.count, xs2.count, xs3.count, xs4.count, xs5.count)
    for i in 0..<len {
        let u = process(xs1[i], xs2[i], xs3[i], xs4[i], xs5[i])
        results.append(u)
    }
    
    return results
}

//MARK: zipWith6 :: (a -> b -> c -> d -> e -> f -> g) -> [a] -> [b] -> [c] -> [d] -> [e] -> [f] -> [g]
public func zipWith6<A, B, C, D, E, F, U>(process: (A, B, C, D, E, F)->U, _ xs1: [A], _ xs2: [B], _ xs3: [C], _ xs4: [D], _ xs5: [E], _ xs6: [F]) -> [U] {
    var results = [U]()
    let len = min(xs1.count, xs2.count, xs3.count, xs4.count, xs5.count, xs6.count)
    for i in 0..<len {
        let u = process(xs1[i], xs2[i], xs3[i], xs4[i], xs5[i], xs6[i])
        results.append(u)
    }
    
    return results
}

//MARK: zipWith7 :: (a -> b -> c -> d -> e -> f -> g -> h) -> [a] -> [b] -> [c] -> [d] -> [e] -> [f] -> [g] -> [h]
public func zipWith7<A, B, C, D, E, F, G, U>(process: (A, B, C, D, E, F, G)->U, _ xs1: [A], _ xs2: [B], _ xs3: [C], _ xs4: [D], _ xs5: [E], _ xs6: [F], _ xs7: [G]) -> [U] {
    var results = [U]()
    let len = min(xs1.count, xs2.count, xs3.count, xs4.count, xs5.count, xs6.count, xs7.count)
    for i in 0..<len {
        let u = process(xs1[i], xs2[i], xs3[i], xs4[i], xs5[i], xs6[i], xs7[i])
        results.append(u)
    }
    
    return results
}
//MARK: unzip :: [(a, b)] -> ([a], [b])
public func unzip<A, B>(xs: [(A, B)]) -> ([A],[B])  {
    var r0 = [A]()
    var r1 = [B]()
    for x in xs {
        r0.append(x.0)
        r1.append(x.1)
    }
    
    return (r0, r1)
}

//MARK: unzip3 :: [(a, b, c)] -> ([a], [b], [c])
public func unzip3<A, B, C>(xs: [(A, B, C)]) -> ([A],[B],[C])  {
    var r0 = [A]()
    var r1 = [B]()
    var r2 = [C]()
    
    for x in xs {
        r0.append(x.0)
        r1.append(x.1)
        r2.append(x.2)
    }
    
    return (r0, r1, r2)
}

//MARK: unzip4 :: [(a, b, c, d)] -> ([a], [b], [c], [d])
public func unzip4<A, B, C, D>(xs: [(A, B, C, D)]) -> ([A],[B],[C],[D])  {
    var r0 = [A]()
    var r1 = [B]()
    var r2 = [C]()
    var r3 = [D]()
    
    for x in xs {
        r0.append(x.0)
        r1.append(x.1)
        r2.append(x.2)
        r3.append(x.3)
    }
    
    return (r0, r1, r2, r3)
}

//MARK: unzip5 :: [(a, b, c, d, e)] -> ([a], [b], [c], [d], [e])
public func unzip5<A, B, C, D, E>(xs: [(A, B, C, D, E)]) -> ([A],[B],[C],[D],[E])  {
    var r0 = [A]()
    var r1 = [B]()
    var r2 = [C]()
    var r3 = [D]()
    var r4 = [E]()
    
    for x in xs {
        r0.append(x.0)
        r1.append(x.1)
        r2.append(x.2)
        r3.append(x.3)
        r4.append(x.4)
    }
    
    return (r0, r1, r2, r3, r4)
}

//MARK: unzip6 :: [(a, b, c, d, e, f)] -> ([a], [b], [c], [d], [e], [f])
public func unzip6<A, B, C, D, E, F>(xs: [(A, B, C, D, E, F)]) -> ([A],[B],[C],[D],[E],[F])  {
    var r0 = [A]()
    var r1 = [B]()
    var r2 = [C]()
    var r3 = [D]()
    var r4 = [E]()
    var r5 = [F]()
    
    for x in xs {
        r0.append(x.0)
        r1.append(x.1)
        r2.append(x.2)
        r3.append(x.3)
        r4.append(x.4)
        r5.append(x.5)
    }
    
    return (r0, r1, r2, r3, r4, r5)
}

//MARK: unzip7 :: [(a, b, c, d, e, f, g)] -> ([a], [b], [c], [d], [e], [f], [g])
public func unzip7<A, B, C, D, E, F, G>(xs: [(A, B, C, D, E, F, G)]) -> ([A],[B],[C],[D],[E],[F],[G])  {
    var r0 = [A]()
    var r1 = [B]()
    var r2 = [C]()
    var r3 = [D]()
    var r4 = [E]()
    var r5 = [F]()
    var r6 = [G]()
    
    for x in xs {
        r0.append(x.0)
        r1.append(x.1)
        r2.append(x.2)
        r3.append(x.3)
        r4.append(x.4)
        r5.append(x.5)
        r6.append(x.6)
    }
    
    return (r0, r1, r2, r3, r4, r5, r6)
}

//MARK: - Special lists
//MARK: Functions on strings
//MARK: lines :: String -> [String]
public func lines(s: String)->[String] {
    return s.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
}

//public func lines(s: String)->[String] {
//    let linefeed : Character = "\n"
//    return splitWith({ (x : Character) in x == linefeed }, s)
//}

public func splitWith(check: Character->Bool, _ s: String)->[String] {
    var xs      = [String]()
    var i       = 0
    var list    = s
    for c in s.characters {
        if check(c) {
            xs.append(take(i, list))
            list = drop(i + 1, list)
            i   = 0
        } else {
            i   = i + 1
        }
    }
    if i != 0 {
        xs.append(list)
    }
    
    return xs
}

//MARK: words :: String -> [String]
public func words(s: String)->[String] {
    let isWhiteSpace    = { (c: Character) in c == " " || c == "\n" || c == "\t" }
    let xs              = splitWith(isWhiteSpace, s)
    let result          = filter({ x in x.characters.count > 0} , xs)
    return result
}

//MARK: unlines :: [String] -> String
public func unlines(xs: [String])->String {
    let result          = join("\n", xs)
    return result
}

public func join(delimiter: String, _ xs: [String]) -> String {
    var result = ""
    for i in 0..<xs.count {
        let t = i == xs.count - 1 ? xs[i] : xs[i] + delimiter
        result = result + t
    }
    return result
}

//MARK: unwords :: [String] -> String
public func unwords(xs: [String])->String {
    let result          = join(" ", xs)
    return result
}

//MARK: "Set" operations
//MARK: nub :: Eq a => [a] -> [a]
public func nub<A: Equatable>(xs: [A]) -> [A] {
    return nubBy( {x, y in x == y}, xs)
}

public func nub<A: Equatable>(xs: [A?]) -> [A?] {
    return nubBy( {x, y in x == y}, xs)
}

public func nub(xs: String) -> String {
    return nubBy({(x: Character, y: Character) in x == y}, xs)
}

//MARK: delete :: Eq a => a -> [a] -> [a]
public func delete<A: Equatable>(value: A, _ xs: [A]) -> [A] {
    let idx     = elemIndex(value, xs)
    return idx == nil ? xs : take(idx!, xs) + drop(idx! + 1, xs)
}

public func delete(value: Character, _ xs: String) -> String {
    let idx     = elemIndex(value, xs)
    return idx == nil ? xs : take(idx!, xs) + drop(idx! + 1, xs)
}

public func delete(value: String, _ xs: String) -> String {
    assert(value.characters.count == 1)
    let c       = value[value.characters.startIndex]
    let idx     = elemIndex(c, xs)
    return idx == nil ? xs : take(idx!, xs) + drop(idx! + 1, xs)
}

//MARK: (\\) :: Eq a => [a] -> [a] -> [a] infix 5
//MARK: union :: Eq a => [a] -> [a] -> [a]
public func union<A: Equatable>(xs1: [A], _ xs2: [A]) -> [A] {
    return nub(xs1 + xs2)
}

//MARK: intersect :: Eq a => [a] -> [a] -> [a]
public func intersect<A: Equatable>(xs1: [A], _ xs2: [A]) -> [A] {
    let isElement   = { (x : A) -> Bool in elemIndex(x, xs2) != nil }
    return filter(isElement, xs1)
}

public func intersect(xs1: String, _ xs2: String) -> String {
    let isElement   = { (x ) -> Bool in elemIndex(x, xs2) != nil }
    return filter(isElement, xs1)
}

//MARK: sort :: Ord a => [a] -> [a]
public func sort<A: Comparable>(xs: [A]) -> [A] {
    return sortOn({x, y in x < y}, xs)
}
//MARK: sortOn :: Ord b => (a -> b) -> [a] -> [a]
public func sortOn<A: Comparable>(f: (A,A)->Bool, _ xs: [A]) -> [A] {
    return xs.sort(f)
}

//MARK: insert :: Ord a => a -> [a] -> [a]
public func insert<A: Equatable>(value: A, _ xs: [A]) -> [A] {
    return xs + [value]
}

public func insert(value: String, _ xs: String) -> String {
    return xs + value
}

public func insert(value: Character, _ xs: String) -> String {
    return xs + String(value)
}

//MARK: - Generalized functions
//MARK: The "By" operations
//MARK: nubBy :: (a -> a -> Bool) -> [a] -> [a]
public func nubBy<A: Equatable>(f: (A,A)->Bool, _ xs: [A]) -> [A] {
    var results  = [A]()
    for x in xs {
        if find( { y in f(x, y) }, results) == nil {
            results.append(x)
        }
    }
    
    return results
}

public func nubBy<A: Equatable>(f: (A?,A?)->Bool, _ xs: [A?]) -> [A?] {
    var results  = [A?]()
    for x in xs {
        if find( { y in f(x, y) }, results) == nil {
            results.append(x)
        }
    }
    
    return results
}

public func nubBy(f: (Character, Character)->Bool, _ xs: String) -> String {
    var results  = String()
    for x in xs.characters {
        if find( { y in f(x, y) }, results) == nil {
            results.append(x)
        }
    }
    
    return results
}

//MARK: deleteBy :: (a -> a -> Bool) -> a -> [a] -> [a]
public func deleteBy<A: Equatable>(f: (A,A)->Bool, _ y: A, _ xs: [A]) -> [A] {
    let idx     = indexElemBy(f, y, xs)
    return idx == nil ? xs : take(idx!, xs) + drop(idx!+1, xs)
}

func indexElemBy<A: Equatable>(f: (A,A)->Bool, _ y: A, _ xs: [A]) -> Int? {
    for i in 0..<xs.count {
        if f(y, xs[i]) {
            return i
        }
    }
    return nil
}

public func deleteBy(f: (Character,Character)->Bool, _ y: Character, _ xs: String) -> String {
    let idx     = indexElemBy(f, y, xs)
    return idx == nil ? xs : take(idx!, xs) + drop(idx!+1, xs)
}

func indexElemBy(f: (Character, Character)->Bool, _ y: Character, _ xs: String) -> Int? {
    for i in 0..<xs.characters.count {
        let c = xs[xs.startIndex.advancedBy(i)]
        if f(y, c) {
            return i
        }
    }
    return nil
}

//MARK: deleteFirstsBy :: (a -> a -> Bool) -> [a] -> [a] -> [a]
public func deleteFirstsBy<A: Equatable>(f: (A,A)->Bool, _ xs1: [A], _ xs2: [A]) -> [A] {
    var result = xs1
    for x in xs2 {
        result = deleteBy(f, x, result)
    }
    
    return result
}

public func deleteFirstsBy(f: (Character, Character)->Bool, _ xs1: String, _ xs2: String) -> String {
    var result  = xs1
    for i in 0..<xs2.characters.count {
        let c   = xs2[xs2.startIndex.advancedBy(i)]
        result  = deleteBy(f, c, result)
    }
    return result
}

//MARK: unionBy :: (a -> a -> Bool) -> [a] -> [a] -> [a]
public func unionBy<A: Equatable>(f : (A, A)->Bool, _ xs1: [A], _ xs2: [A]) -> [A] {
    return xs1 + deleteFirstsBy(f, nub(xs2), xs1)
}

public func unionBy(f: (Character, Character)->Bool, _ xs1: String, _ xs2: String) -> String {
    return xs1 + deleteFirstsBy(f, nub(xs2), xs1)
}

//MARK: intersectBy :: (a -> a -> Bool) -> [a] -> [a] -> [a]
public func intersectBy<A: Equatable>(f : (A, A)->Bool, _ xs1: [A], _ xs2: [A]) -> [A] {
    return filter( { x in any({ y in f(x, y)}, xs2)}, xs1)
}

public func intersectBy(f: (Character, Character)->Bool, _ xs1: String, _ xs2: String) -> String {
    return filter( { x in any({ y in f(x, y)}, xs2)}, xs1)
}

//MARK: groupBy :: (a -> a -> Bool) -> [a] -> [[a]]
public func groupBy<A: Equatable>(f : (A, A)->Bool, _ xs: [A]) -> [[A]] {
    if xs.count <= 1 {
        return [xs]
    }
    
    var result          = [[A]]()
    var list            = xs
    while (list.count > 0) {
        let y           = head(list)
        let ys          = takeWhile( { x in f(y, x)}, drop(1, list))
        list            = drop(ys.count > 0 ? ys.count + 1 : 1, list)
        result.append(ys.count > 0 ? [y] + ys : [y])
        //print("y = \(y), items = \(ys), list = \(list)")
    }
    
    return result
}

public func groupBy(f: (Character, Character)->Bool, _ xs: String) -> [String] {
    var result          = [String]()
    var list            = xs
    while (list.characters.count > 0) {
        let y           = head(list)
        let ys          = takeWhile( { x in f(y, x)}, drop(1, list))
        list            = drop(ys.characters.count > 0 ? ys.characters.count + 1 : 1 , list)
        result.append(ys.characters.count > 0 ? String(y) + ys : String(y))
    }
    
    return result
}

//MARK: sortBy :: (a -> a -> Ordering) -> [a] -> [a]
public func sortBy<A: Comparable>(f : (A, A)->Bool, _ xs: [A]) -> [A] {
    return xs.sort(f)
}

//MARK: insertBy :: (a -> a -> Ordering) -> a -> [a] -> [a]
public func insertBy<A: Equatable>(f : (A, A)->Bool, _ value: A, _ xs: [A]) -> [A] {
    let idx = indexElemBy(f, value, xs)
    if idx == nil {
        return xs + [value]
    }
    return take(idx!, xs) + [value] + drop(idx!, xs)
}

public func insertBy(f : (Character, Character)->Bool, _ value: Character, _ xs: String) -> String {
    let idx = indexElemBy(f, value, xs)
    if idx == nil {
        return xs + String(value)
    }
    return take(idx!, xs) + String(value) + drop(idx!, xs)
}

//MARK: maximumBy :: Foldable t => (a -> a -> Ordering) -> t a -> a
public func maximumBy<A: Comparable>(f : (A, A)->Ordering, _ xs: [A]) -> A {
    assert(xs.count > 0, "Empty List")
    var result = xs[0]
    foldl({(a: A, b: A) -> A in
        result = f(a, b) == .GT ? a : b
        return result
        }, result, xs)
    return result
}

//MARK: minimumBy :: Foldable t => (a -> a -> Ordering) -> t a -> a
public func minimumBy<A: Comparable>(f : (A, A)->Ordering, _ xs: [A]) -> A {
    assert(xs.count > 0, "Empty List")
    var result = xs[0]
    foldl({(a: A, b: A) -> A in
        result = f(a, b) == .LT ? a : b
        return result
        }, result, xs)
    return result
}

//MARK: - The "generic" operations
//MARK: genericLength :: Num i => [a] -> i
public func genericLength<A>(xs: [A])->Int {
    return xs.count
}

public func genericLength(xs: String)->Int {
    return xs.characters.count
}

//MARK: genericTake :: Integral i => i -> [a] -> [a]
public func genericTake<T>(len: Int, _ xs: [T]) -> [T] {
    return take(len, xs)
}

//MARK: genericDrop :: Integral i => i -> [a] -> [a]
public func genericDrop<T>(len: Int, _ xs: [T]) -> [T] {
    return drop(len, xs)
}

//MARK: genericSplitAt :: Integral i => i -> [a] -> ([a], [a])
public func genericSplitAt(len: Int, _ xs: String)->(String, String) {
    return splitAt(len, xs)
}

//MARK: genericIndex :: Integral i => [a] -> i -> a


//MARK: genericReplicate :: Integral i => i -> a -> [a]
public func genericReplicate<A>(len: Int, _ value: A) -> [A] {
    return replicate(len, value)
}
