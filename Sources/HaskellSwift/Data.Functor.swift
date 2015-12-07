//
//  Data.Functor.swift
//  HaskellSwift
//
//  Created by Liang on 30/08/2015.
//  Copyright © 2015 Liang. All rights reserved.
//

import Foundation

public func fmap<A,B,C>(f1: B->C, _ f2: A->B)->(A->C) {
    return {(a: A) in f1(f2(a))}
}

infix operator <^> { associativity right precedence 100}
public func <^> <A,B,C>(f1: B->C, f2: A->B)->(A->C) {
    return {(a: A) in f1(f2(a))}
}

infix operator <| { associativity right precedence 100}
func <| <A,B>(a: A, f: (A->B)) -> (A->B) {
    return { _ in f(a) }
}

func <| <A,B>(a: A, xs: [B]) -> [A] {
    return map({_ in a}, xs)
}

func <| <A,B,C>(a: A, t: (B, C)) -> (B,A) {
    return (t.0, a)
}