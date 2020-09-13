//
//  File.swift
//  
//
//  Created by Barkin Cavdaroglu on 8/15/20.
//

import Foundation

// The resulting matrix will not be tridiagonal unless the input matrix is symmetric.
public func HouseholderTransformation(of matrix: [[Double]]) -> [[[Double]]] {
    var A_Array = [[[Double]]](repeating: [[Double]](repeating: [Double](repeating: 0.0, count: matrix.count), count: matrix.count), count: matrix.count)
    var Q_Array = [[[Double]]](repeating: [[Double]](repeating: [Double](repeating: 0.0, count: matrix.count), count: matrix.count), count: matrix.count)
    var v_Array = [[Double]](repeating: [Double](repeating: 0.0, count: matrix.count), count: matrix.count)
    
    var r: Double
    var alpha = 0.0
    let n = matrix.count
    var v = [Double](repeating: 0.0, count: n)
    let identityMatrix = generateIdentityMatrix(for: n)
    
    var sum = 0.0
    for j in 1..<n{
        sum += matrix[j][0]^^2
    }
    sum = sqrt(sum)
    
    alpha = matrix[1][0].sgn() * sum * -1 // works
    
    // Operations don't work unless they are seperated by variables. Clean it up/look it up later.
    let a1 = 1.0/2.0
    let alphaSQ = alpha^^2
    r = sqrt(a1 * alphaSQ - a1 * matrix[1][0]*alpha) // works
    
    let amaa = matrix[1][0]-alpha
    let b1 = 2.0 * r
    let amaa2 = amaa/b1
    
    v[0] = 0
    v[1] = amaa2
    
    for k in 2..<n{
        let element = matrix[k][0]
        let dividor = 2.0 * r
        let ind = element/dividor
        v[k] = ind
    }
    
    v_Array[0] = v
    
    let ab = MatrixFrom2Vectors(vector1: v, vector2: v)
    let ab_multiplied = matrixScalarMultiplication(matrix: ab, scalar: 2.0)
    
    
    Q_Array[0] = identityMatrix-ab_multiplied
    
    let P1A = matrixMultiplication(of: Q_Array[0], with: matrix)
    
    A_Array[0] = matrixMultiplication(of: P1A, with: Q_Array[0])
    
    for k in 0..<n-3{
        var sum2 = 0.0
        for j in k+2..<n{
            sum2 += A_Array[k][j][j-1]^^2
        }
        alpha = A_Array[k][k+2][k+1].sgn() * sqrt(sum2) * -1
        
        let half = 1.0/2.0
        let alphaSQ2 = alpha^^2
        let elementA = A_Array[k][k+2][k+1]*alpha
        r = sqrt(half*(alphaSQ2-elementA))
        
        for i in 0..<v_Array[k+1].count{
            v_Array[k+1][i] = 0.0
        }
        
        let denominator = 2.0 * r
        
        v_Array[k+1][k+2] = (A_Array[k][k+2][k+1]-alpha)/denominator
        for j in k+3..<n{
            v_Array[k+1][j] = A_Array[k][j][k+1]/denominator
        }
        
        let ab2 = MatrixFrom2Vectors(vector1: v_Array[k+1], vector2: v_Array[k+1])
        let matrixMultiplied = matrixScalarMultiplication(matrix: ab2, scalar: 2.0)
        Q_Array[k+1] = substract(matrixA: identityMatrix, from: matrixMultiplied) //Matrices in Q_Array are Householder matrices
        let mult = matrixMultiplication(of: Q_Array[k+1], with: A_Array[k])
        A_Array[k+1] = matrixMultiplication(of: mult, with: Q_Array[k+1])
    }
    return A_Array
}

public func eigen2(matrix: [[Double]]) -> (Double, Double) {
    let a = 1.0
    let b = -1 * (matrix[0][0] + matrix[1][1])
    let c = matrix[0][0]*matrix[1][1] - matrix[0][1]*matrix[1][0]
    return Quadratic(a: a, b: b, c: c)
}

public func eigen3(matrix: [[Double]]) -> [Double] {
    let a = -1.0
    let b = matrix[0][0] + matrix[1][1] + matrix[2][2]
    let c = (-1 * matrix[0][0] * matrix[1][1]) - matrix[0][0] * matrix[2][2] - matrix[1][1] * matrix[2][2] + matrix[1][2] * matrix[2][1] + matrix[0][1] * matrix[1][0] + matrix[0][2]*matrix[2][0]
    let d = matrix[0][2]*matrix[1][0]*matrix[2][1] - matrix[0][2]*matrix[1][1]*matrix[2][0] + matrix[0][0]*matrix[1][1]*matrix[2][2] - matrix[0][0]*matrix[1][2]*matrix[2][1] - matrix[0][1]*matrix[1][0]*matrix[2][2] + matrix[0][1]*matrix[1][2]*matrix[2][0]
    return solveCubicEquation(a: a, b: b, c: c, d: d)
}


