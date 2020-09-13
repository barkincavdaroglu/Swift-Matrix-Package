//
//  File.swift
//  
//
//  Created by Barkin Cavdaroglu on 8/15/20.
//

import Foundation

open class LUPDecomposition {
    var matrix: [[Double]]
    
    let n: Int
    let m: Int
    public init(matrix: [[Double]]) {
        self.matrix = matrix
        self.n = matrix.count
        self.m = matrix[0].count
    }
    
    //MARK: - Decompose matrix into L and U while creating a permutation matrix.
    public func LUP_DecompositionD() -> ([[Double]], [[Double]], [Double]) {
        var piArray = [Double](repeating: 1.0, count: self.n)
        var i = 0
        
        while i < self.n {
            piArray[i] = Double(i)
            i += 1
        }
        
        for k in 0..<self.n{
            var p = 0.0
            var kPrime = k
            for i in k..<self.n {
                if abs(self.matrix[i][k]) > p {
                    p = abs(self.matrix[i][k])
                    kPrime = i
                }
            }
            
            if p == 0 {
                print("Input is a singular matrix")
            }
            
            (piArray[k], piArray[kPrime]) = (piArray[kPrime], piArray[k])
            
            for i in 0..<self.n{
                (self.matrix[k][i], self.matrix[kPrime][i]) = (self.matrix[kPrime][i], self.matrix[k][i])
            }
            
            for i in k+1..<self.n{
                self.matrix[i][k] = self.matrix[i][k]/self.matrix[k][k]
                for j in k+1..<self.n{
                    self.matrix[i][j] -= self.matrix[i][k]*self.matrix[k][j]
                }
            }
        }
        let (L, U) = disintegrateLUComposition()
        return (L, U, piArray)
    }
    
    //MARK: - Stores L and U as a composed matrix for Inverse operation
    public func LUP_DecompositionC() -> [Double] {
        var piArray = [Double](repeating: 1.0, count: self.n)
        var i = 0
        
        while i < self.n {
            piArray[i] = Double(i)
            i += 1
        }
        
        for k in 0..<self.n{
            var p = 0.0
            var kPrime = k
            for i in k..<self.n {
                if abs(self.matrix[i][k]) > p {
                    p = abs(self.matrix[i][k])
                    kPrime = i
                }
            }
            
            if p == 0 {
                print("Input is a singular matrix.")
            }
            
            (piArray[k], piArray[kPrime]) = (piArray[kPrime], piArray[k])
            
            for i in 0..<self.n{
                (self.matrix[k][i], self.matrix[kPrime][i]) = (self.matrix[kPrime][i], self.matrix[k][i])
            }
            
            for i in k+1..<self.n{
                self.matrix[i][k] = self.matrix[i][k]/self.matrix[k][k]
                for j in k+1..<self.n{
                    self.matrix[i][j] -= self.matrix[i][k]*self.matrix[k][j]
                }
            }
        }
        return piArray
    }


    //MARK: - Seperate L and U from the composed matrix that LUP_Decomposition returns
    public func disintegrateLUComposition() -> ([[Double]], [[Double]]) {
        var L = [[Double]](repeating: [Double](repeating: 0.0, count: self.matrix.count), count: self.matrix.count)
        var U = [[Double]](repeating: [Double](repeating: 0.0, count: self.matrix.count), count: self.matrix.count)
        
        for i in 0..<self.n{
            for j in 0..<self.n{
                if (i < j) {
                    U[i][j] = self.matrix[i][j]
                }
                if (i == j) {
                    U[i][j] = self.matrix[i][j]
                    L[i][j] = 1.0
                }
                if (i > j) {
                    L[i][j] = self.matrix[i][j]
                }
            }
        }
        return (L, U)
    }

    //MARK: Inputs: Composed matrix matrixA and permutation matrix matrixP returned by LUP_Decomposition
    public func LUPInvert(matrixP: [Double]) -> [[Double]] {
        var inverseMatrix = [[Double]](repeating: [Double](repeating: 0.0, count: self.matrix.count), count: self.matrix.count)
        
        for j in 0..<self.matrix.count{
            for i in 0..<self.matrix.count {
                if matrixP[i] == Double(j) {
                    inverseMatrix[i][j] = 1.0
                } else{
                    inverseMatrix[i][j] = 0.0
                }
                for k in 0..<i{
                    inverseMatrix[i][j] -= self.matrix[i][k] * inverseMatrix[k][j]
                }
            }
            
            for i in stride(from: self.matrix.count-1, to: -1, by: -1) {
                for k in i+1..<self.matrix.count{
                    inverseMatrix[i][j] -= self.matrix[i][k] * inverseMatrix[k][j]
                }
                inverseMatrix[i][j] /= self.matrix[i][i]
            }
        }
        return inverseMatrix
    }

    //MARK: - Inputs: L, U, P returned from LUP_Decomposition and b vector is the Ax = b
    public func LUP_Solve(L: [[Double]], U: [[Double]], P: [Double], b: [Double]) -> [Double] {
        let n = L.count
        var y = [Double](repeating: 0.0, count: n)
        
        for i in 0..<n{
            
            y[i] = b[Int(P[i])]
            for k in 0..<i{
                y[i] -= L[i][k]*y[k]
            }
        }
        
        for i in stride(from: n-1, to: -1, by: -1) {
            var sum = 0.0
            for j in i+1..<n{
                sum += U[i][j]*y[j]
                y[i] -= U[i][j]*y[j]
            }
            y[i] /= U[i][i]
        }
        
        return y
    }
    
    public func findDeterminant(L: [[Double]], U: [[Double]]) -> Double {
        var determinantLBlock = 1.0
        var determinantUBlock = 1.0
        for i in 0..<self.m {
            determinantLBlock *= L[i][i]
            determinantUBlock *= U[i][i]
        }
        return determinantUBlock * determinantLBlock
    }
}
