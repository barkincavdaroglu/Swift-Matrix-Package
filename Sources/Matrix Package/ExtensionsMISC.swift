//
//  File.swift
//  
//
//  Created by Barkin Cavdaroglu on 8/14/20.
//

import Foundation
import Accelerate

public extension __CLPK_doublereal {
    func sgn() -> __CLPK_doublereal {
        if self >= 0 {
            return 1.0
        } else {
            return -1.0
        }
    }
}

//https://stackoverflow.com/questions/48333951/change-scientific-notation-to-decimal-in-swift
public extension __CLPK_doublereal {
    var avoidNotation: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 8
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(for: self) ?? ""
    }
}


precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ^^ : PowerPrecedence
func ^^ (radix: __CLPK_doublereal, power: __CLPK_doublereal) -> __CLPK_doublereal {
    return __CLPK_doublereal(pow(__CLPK_doublereal(radix), __CLPK_doublereal(power)))
}

func ^^ (radix: __CLPK_doublereal, power: Int) -> __CLPK_doublereal {
    return __CLPK_doublereal(pow(__CLPK_doublereal(radix), __CLPK_doublereal(power)))
}

//MARK: - Extending the array to have a function to return column
extension Array where Element : Collection {
    func getColumn(column : Element.Index) -> [ Element.Iterator.Element ] {
        return self.map { $0[ column ] }
    }
}


public extension Collection where Index: Comparable {
    subscript(back i: Int) -> Iterator.Element {
        let backBy = i + 1
        return self[self.index(self.endIndex, offsetBy: -backBy)]
    }
}

public func - (left: [[__CLPK_doublereal]], right: [[__CLPK_doublereal]]) -> [[__CLPK_doublereal]] {
    var result = Matrix0(of: left.count, n: right.count)
    for i in 0..<left.count{
        for j in 0..<right.count{
            result [i][j] = left[i][j] - right[i][j]
        }
    }
    return result
}

public func +(lhs: [[__CLPK_doublereal]], rhs: [[__CLPK_doublereal]]) -> [[__CLPK_doublereal]] {
    var result = [[__CLPK_doublereal]](repeating: [Double](repeating: 0.0, count: lhs.count), count: rhs.count)
    for i in 0..<lhs.count{
        for j in 0..<rhs.count{
            result[i][j] = lhs[i][j] + rhs[i][j]
        }
    }
    return result
}

public func *(lhs: Int, rhs: __CLPK_doublereal) -> __CLPK_doublereal {
    return __CLPK_doublereal(lhs) * rhs
}

public func *(lhs: __CLPK_doublereal, rhs: Int) -> __CLPK_doublereal {
    return lhs * __CLPK_doublereal(rhs)
}

public func /(lhs: [__CLPK_doublereal], rhs: __CLPK_doublereal) -> [__CLPK_doublereal] {
    var result = lhs
    for i in 0..<lhs.count{
        result[i] /= rhs
    }
    return result
}

public func -(lhs: [__CLPK_doublereal], rhs: [__CLPK_doublereal]) -> [__CLPK_doublereal] {
    var result = lhs
    for i in 0..<lhs.count {
        result[i] -= rhs[i]
    }
    return result
}

public func +(lhs: [__CLPK_doublereal], rhs: [__CLPK_doublereal]) -> [__CLPK_doublereal] {
    var result = [__CLPK_doublereal]()
    for i in 0..<lhs.count{
        result.append(lhs[i]+rhs[i])
    }
    return result
}
