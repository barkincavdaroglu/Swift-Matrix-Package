//
//  File.swift
//  
//
//  Created by Barkin Cavdaroglu on 8/15/20.
//

import Foundation

open class QR {
    var matrix: [[Double]]
    let m: Int
    let n: Int
    
    public init(matrix: [[Double]]) {
        self.matrix = matrix
        self.m = matrix.count
        self.n = matrix[0].count
    }
    
    public func QR_Decomposition(ofMatrix matrix: [[Double]]) -> ([[Double]], [[Double]]) {
        let m = matrix.count
        var Q = generateIdentityMatrix(for: m)
        var R = matrix
        
        for i in 0..<m-1{
            let subColumn = getSomeColumn(of: R, column: i, row: i)
            var vector0s = zerosVector(vector: subColumn)
            let normSubColumn = norm(of: subColumn)
            vector0s[0] = copysign(a: normSubColumn, b: -matrix[i][i])
            let u = vectorAddition(A: subColumn, B: vector0s)
            
            let v = u / norm(of: u)
            var Q_k = generateIdentityMatrix(for: m)
            let multiplier = matrixScalarMultiplication(matrix: outer(A: v, B: v), scalar: 2.0)
            
            var counter = 0
            var counter2 = 0
            for k in i..<Q_k.count{
                for z in i..<Q_k.count{
                    Q_k[k][z] -= multiplier[counter][counter2]
                    counter2 += 1
                }
                counter2 = 0
                counter += 1
            }
            
            R = matrixMultiplication(of: Q_k, with: R)
            Q = matrixMultiplication(of: Q, with: Transpose(matrix: Q_k))
        }
        return (Q, R)
    }

    public func QR_Algorithm() -> ([Double], [[Double]]) {
        var temporary = self.matrix
        var Q_Product = Matrix1(of: self.matrix.count, n: self.matrix.count)
        var converged = false
        var eigenvalues = [Double]()
        while converged == false {
            let (Q, R) = QR_Decomposition(ofMatrix: temporary)
            Q_Product = matrixMultiplication(of: Q_Product, with: Q)
            self.matrix = matrixMultiplication(of: R, with: Q)
            if didConverge(A: self.matrix, B: temporary){
                converged = true
            }
            temporary = self.matrix
        }
        
        for i in 0..<self.n{
            eigenvalues.append(self.matrix[i][i])
        }
        
        return (eigenvalues, Q_Product)
    }
}
