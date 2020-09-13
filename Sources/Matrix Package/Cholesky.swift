//
//  File.swift
//  
//
//  Created by Barkin Cavdaroglu on 8/15/20.
//

import Foundation

//MARK: - Cholesky Decomposition
// Only applies to symmetric, real matrices
// Twice as efficient as LU Decomposition
open class Cholesky {
    let matrix: [[Double]]
    let n: Int
    public init?(matrix: [[Double]]) throws {
        if isSymmetric(matrix: matrix) == false {
            throw InputMatrixError.notSymmetric
        } else {
            self.matrix = matrix
            self.n = matrix.count
        }
    }
    
    public func choleskyDecomposition() -> ([[Double]], [[Double]]) {
        var lowerTriangular = [[Double]](repeating: [Double](repeating: 0.0, count: self.n), count: self.n)
         
            for i in 0..<self.n{
                for k in 0..<i+1{
                    var sum = 0.0
                    for j in 0..<k{
                        sum += lowerTriangular[i][j]*lowerTriangular[k][j]
                    }
                    if i == k {
                        lowerTriangular[i][k] = sqrt(self.matrix[i][i] - sum)
                    } else {
                        lowerTriangular[i][k] = (1.0 / lowerTriangular[k][k] * (self.matrix[i][k] - sum))
                    }
                }
            }
            return (lowerTriangular, Transpose(matrix: lowerTriangular))
    }
    
    public func solve(b: [Double]) -> [Double] {
        let (lower, transposed) = choleskyDecomposition()
        let b2 = forwardSubstitution(ofMatrix: lower, solutionVector: b)
        return backwardSubstitution(ofMatrix: transposed, solutionVector: b2)
    }
}
