//
//  Data.Tuple.swift
//  HaskellSwift
//
//  Created by Liang on 29/08/2015.
//  Copyright © 2015 Liang. All rights reserved.
//

import Foundation

//MARK: fst :: (a, b) -> a
public func fst<A,B>(t: (A,B)) -> A {
    return t.0
}

//MARK: snd :: (a, b) -> b
public func snd<A,B>(t: (A,B)) -> B {
    return t.1
}

//MARK: curry :: ((a, b) -> c) -> a -> b -> c
public func curry<A,B,C>(f: (A, B)->C)->(A->B->C) {
    return { (a: A)->(B->C) in { (b: B) -> C in f(a, b)} }
}

public func curry<A,B,C>(f: (A, B)->C, _ a: A)-> (B->C) {
    return {b in f(a, b) }
}

//MARK: uncurry :: (a -> b -> c) -> (a, b) -> c
public func uncurry<A, B, C>(f: A->B->C) -> (A,B)->C {
    return { (a: A, b: B)->C in  f(a)(b) }
}

//MARK: swap :: (a, b) -> (b, a)
public func swap<A,B>(t: (A, B)) -> (B, A) {
    return (t.1, t.0)
}