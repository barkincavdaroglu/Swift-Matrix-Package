//
//  File.swift
//  
//
//  Created by Barkin Cavdaroglu on 8/15/20.
//

import Foundation

open class Cramers {
    var matrix: [[Double]]
    let n: Int
    
    public init(matrix: [[Double]]) {
        self.matrix = matrix
        self.n = matrix.count
    }
    
    //MARK: - Determinant by Cofactor Expansion
    public func DeterminantByCofactorExpansion(matrix: [[Double]]) -> Double {
        if matrix.count == 1 {
            return matrix[0][0]
        }
        if matrix.count == 2 {
            return matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0]
        }
        let n = matrix.count
        var determinant = 0.0
        var sign = 1.0
        
        for i in 0..<n{
            let current = getCoFactor(of: matrix, row: 0, column: i)
            determinant += sign * matrix[0][i] * DeterminantByCofactorExpansion(matrix: current)
            sign *= -1
        }
        return determinant
    }

    func getCoFactor(of matrix: [[Double]], row: Int, column: Int) -> [[Double]] {
        let n = matrix.count
        var result = [[Double]]()
        for i in 0..<n{
            if i == row{
                continue
            }
            var temp = [Double]()
            for j in 0..<n{
                if j == column {
                    continue
                }
                temp.append(matrix[i][j])
            }
            result.append(temp)
        }
        return result
    }

    func permuteCol(of matrix: [[Double]], b: [Double], column: Int) -> [[Double]]{
        let n = matrix.count
        var result = [[Double]]()
        for i in 0..<n {
            var temp = [Double]()
            for j in 0..<n {
                var val = matrix[i][j]
                if j == column {
                    val = b[i]
                }
                temp.append(val)
            }
            result.append(temp)
        }
        return result
    }

    //MARK: - Cramer's Rule
    public func cramersRule(b: [Double]) -> [Double] {
        let d = DeterminantByCofactorExpansion(matrix: self.matrix)
        var result = [Double]()
        for i in 0..<b.count{
            let permuted = permuteCol(of: self.matrix, b: b, column: i)
            result.append(DeterminantByCofactorExpansion(matrix: permuted)/d)
        }
        return result
    }
}
