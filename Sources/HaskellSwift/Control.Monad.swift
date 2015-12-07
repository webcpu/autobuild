//
//  Data.Monad.swift
//  HaskellSwift
//
//  Created by Liang on 24/09/2015.
//  Copyright © 2015 Liang. All rights reserved.
//

import Foundation

//(>>=) :: forall a b. m a -> (a -> m b) -> m b
infix operator >>= {associativity right precedence 100}

public func >>=<A, B>(xs: [A], f: A -> [B]) -> [B] {
    return xs.map(f).reduce([], combine: +)
}

public func >>=<A, B, C>(f: A->[B], g: B->[C]) -> (A->[C]) {
    return { (x : A) -> [C] in
        return concat(map(g, f(x)))
    }
}

//(<=<) :: Monad m => (b -> m c) -> (a -> m b) -> a -> m c
infix operator <=< {associativity right precedence 100}
public func <=<<A, B, C>(f: B->[C], g: A -> [B]) -> (A->[C]) {
    return { (x: A) -> [C] in
        return (g >>= f)(x)
    }
}

//(>=>) :: Monad m => (a -> m b) -> (b -> m c) -> a -> m c
infix operator >=> {associativity right precedence 100}
public func >=><A, B, C>(f: A->[B], g: B -> [C]) -> (A->[C]) {
    return { (x: A) -> [C] in
        return (f >>= g)(x)
    }
}

//Maybe Monad
public func fmap<A, B>(x: A?, _ f: A -> B?) -> B? {
    return x == nil ? nil : f(x!)
}

infix operator >>>= {associativity right precedence 100}
public func >>>=<A, B>(x: A?, f: A -> B?) -> B? {
    return x == nil ? nil : f(x!)
}

public func >>>=<A, B, C>(f: A->B?, g: B->C?) -> (A->C?) {
    return { (a : A) -> C? in
        return f(a) >>>= g
    }
}
