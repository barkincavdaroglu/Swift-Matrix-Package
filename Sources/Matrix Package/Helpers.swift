//
//  File.swift
//  
//
//  Created by Barkin Cavdaroglu on 8/14/20.
//

import Foundation
import Accelerate

//MARK: - Generates an mxn matrix of 0s
public func Matrix0(of m: Int, n: Int) -> [[__CLPK_doublereal]] {
    return [[__CLPK_doublereal]](repeating: [Double](repeating: 0.0, count: m), count: n)
}

//MARK: - Generates an mxn matrix of 1s
public func Matrix1(of m: Int, n: Int) -> [[__CLPK_doublereal]] {
    return [[__CLPK_doublereal]](repeating: [Double](repeating: 1.0, count: m), count: n)
}

//MARK: - Generates Identity Matrix with given dimension
public func generateIdentityMatrix(for matrixOfSize: Int) -> [[__CLPK_doublereal]] {
    var identityMatrix = [[__CLPK_doublereal]]( repeating: [Double](repeating: 0.0, count: matrixOfSize), count: matrixOfSize)
    
    for i in 0..<matrixOfSize{
        identityMatrix[i][i] = 1.0
    }
    
    return identityMatrix
}

//MARK: - Substracts one matrix from another
public func substract(matrixA: [[__CLPK_doublereal]], from matrixB: [[__CLPK_doublereal]]) -> [[__CLPK_doublereal]] {
    let n = matrixA.count
    var result = [[__CLPK_doublereal]](repeating: [__CLPK_doublereal](repeating: 0.0, count: n), count: n)
    
    for i in 0..<n{
        for j in 0..<n{
            result[i][j] = matrixB[i][j] - matrixA[i][j]
        }
    }
    
    return result
}

//MARK: - If dimensions agree, generates a matrix from 2 vectors
public func MatrixFrom2Vectors(vector1: [__CLPK_doublereal], vector2: [__CLPK_doublereal]) -> [[__CLPK_doublereal]] {
    var result = Matrix0(of: vector1.count, n: vector2.count)
    
    for i in 0..<vector1.count{
        for j in 0..<vector2.count{
            result[i][j] = vector1[i]*vector2[j]
        }
    }
    return result
}

//MARK: - Multiplies a vector by a scalar
public func scalarVectorMultiplication(vector: [__CLPK_doublereal], scalar: __CLPK_doublereal) -> [Double] {
    var result = [__CLPK_doublereal](repeating: 0.0, count: vector.count)
    for i in 0..<vector.count{
        result[i] = vector[i]*scalar
    }
    return result
}

//MARK: - Finds the norm of a vector
public func norm(of vector: [__CLPK_doublereal]) -> __CLPK_doublereal {
    var sum = 0.0
    for i in 0..<vector.count {
        sum += vector[i] ^^ 2
    }
    return sqrt(sum)
}

//MARK: - Multiplies a matrix by a scalar
public func matrixScalarMultiplication(matrix: [[__CLPK_doublereal]], scalar: __CLPK_doublereal) -> [[__CLPK_doublereal]]{
    var result = [[__CLPK_doublereal]](repeating: [__CLPK_doublereal](repeating: 0.0, count: matrix.count), count: matrix.count)
    for i in 0..<matrix.count{
        for j in 0..<matrix.count{
            result[i][j] = matrix[i][j] * scalar
        }
    }
    return result
}

//MARK: - Multiplies a matrix with another
//Can be numerically unstable for householder transformation
public func matrixMultiplication(of matrix: [[__CLPK_doublereal]], with matrix2: [[__CLPK_doublereal]]) -> [[__CLPK_doublereal]] {
    var C = [[__CLPK_doublereal]] (repeating: [__CLPK_doublereal](repeating: 0.0, count: matrix.count), count: matrix.count)
    if matrix.count != matrix2.count {
        print("Dimensions don't agree.")
    } else {
        for i in 0..<matrix.count{
            for j in 0..<matrix2.count{
                var sum = 0.0
                for k in 0..<matrix.count {
                    sum += matrix[i][k] * matrix2[k][j]
                }
                let y = Double(round(1000*sum)/1000)
                C[i][j] = sum
            }
        }
    }
    return C
}

//MARK: - Finds the trace of the given matrix
public func tr(of matrix: [[__CLPK_doublereal]]) -> __CLPK_doublereal {
    var trace = 0.0
    for i in 0..<matrix.count {
        trace += matrix[i][i]
    }
    return trace
}


//MARK: - Transposes the matrix
public func Transpose(matrix: [[__CLPK_doublereal]]) -> [[__CLPK_doublereal]] {
    var transposedMatrix = matrix
    for i in 0..<transposedMatrix.count {
        for j in 0..<transposedMatrix.count {
            transposedMatrix[i][j] = matrix[j][i]
        }
    }
    return transposedMatrix
}

//MARK: - Returns the column view of the matrix
public func getAllColumns(of matrix: [[__CLPK_doublereal]]) -> [[__CLPK_doublereal]] {
    var columns = [[__CLPK_doublereal]]()
    for i in 0..<matrix.count{
        columns.append(matrix.getColumn(column: i))
    }
    return columns
}

//MARK: - Checks if the matrix is idempotent
public func isIdempotent(matrix: [[__CLPK_doublereal]]) -> Bool {
    let multiplied: [[__CLPK_doublereal]] = matrixMultiplication(of: matrix, with: matrix)
    for i in 0..<matrix.count{
        for j in 0..<matrix.count{
            if matrix[i][j] != multiplied[i][j] {
                return false
            }
        }
    }
    return true
}

//MARK: - Checks if the matrix is involutory
public func isInvolutory(matrix: [[__CLPK_doublereal]]) -> Bool {
    let multiplied = matrixMultiplication(of: matrix, with: matrix)
    let n = matrix.count
    
    for i in 0..<n{
        for j in 0..<n{
            if (i == j && multiplied[i][j] != 1) {
                return false
            }
            if (i != j && multiplied[i][j] != 0) {
                return false
            }
        }
    }
    return true
}

//MARK: - Checks if the matrix is upper triangular
public func isUpperTriangular(of matrix: [[Int]]) -> Bool {
    var isUpperTriangular: Bool = true
    
    for i in 1..<matrix.count {
        for j in 0..<i {
            if matrix[i][j] != 0 {
                isUpperTriangular = false
                break
            }
        }
    }
    return isUpperTriangular
}

//MARK: - Quadratic Solver
public func Quadratic(a: __CLPK_doublereal, b: __CLPK_doublereal, c: __CLPK_doublereal) -> (__CLPK_doublereal, __CLPK_doublereal) {
    let x1 = ((-1 * b) + sqrt(b^^2 - 4*a*c))/2*a
    let x2 = ((-1 * b) - sqrt(b^^2 - 4*a*c))/2*a
    
    return (x1, x2)
}


//MARK: - Cubic Solver taken from https://github.com/dnpp73/CubicEquationSolver
public func solveCubicEquation(a: __CLPK_doublereal, b: __CLPK_doublereal, c: __CLPK_doublereal, d: __CLPK_doublereal) -> [Double] {
        let A = b / a
        let B = c / a
        let C = d / a
        return solveCubicEquation(A: A, B: B, C: C)
}

private func solveCubicEquation(A: __CLPK_doublereal, B: __CLPK_doublereal, C: __CLPK_doublereal) -> [__CLPK_doublereal] {
    if A == 0.0 {
        return solveCubicEquation(p: B, q: C)
    } else {
        let p = B - (pow(A, 2.0) / 3.0)
        let q = C - ((A * B) / 3.0) + ((2.0 / 27.0) * pow(A, 3.0))
        let roots = solveCubicEquation(p: p, q: q)
        return roots.map { $0 - A/3.0 }
    }
}

private func solveCubicEquation(p: __CLPK_doublereal, q: __CLPK_doublereal) -> [__CLPK_doublereal] {
    let p3 = p / 3.0
    let q2 = q / 2.0
    var discriminant = pow(q2, 2.0) + pow(p3, 3.0) // D: discriminant
    discriminant = __CLPK_doublereal(round(1000*discriminant)/1000)
    if discriminant < 0.0 {
        // three possible real roots
        let r = sqrt(pow(-p3, 3.0))
        let t = -q / (2.0 * r)
        let cosphi = min(max(t, -1.0), 1.0)
        let phi = acos(cosphi)
        let c = 2.0 * cuberoot(r)
        let root1 = c * cos(phi/3.0)
        let root2 = c * cos((phi+2.0*__CLPK_doublereal.pi)/3.0)
        let root3 = c * cos((phi+4.0*__CLPK_doublereal.pi)/3.0)
        return [root1, root2, root3]
    } else if discriminant == 0.0 {
        // three real roots, but two of them are equal
        let u: __CLPK_doublereal
        if q2 < 0.0 {
            u = cuberoot(-q2)
        } else {
            u = -cuberoot(q2)
        }
        let root1 = 2.0 * u
        let root2 = -u
        return [root1, root2]
    } else {
        // one real root, two complex roots
        let sd = sqrt(discriminant)
        let u = cuberoot(sd - q2)
        let v = cuberoot(sd + q2)
        let root1 = u - v
        return [root1]
    }
}

private func cuberoot(_ v: __CLPK_doublereal) -> __CLPK_doublereal {
    let c = 1.0 / 3.0
    if v < 0.0 {
        return -pow(-v, c)
    } else {
        return pow(v, c)
    }
}

public func round(_ value: __CLPK_doublereal, toNearest: __CLPK_doublereal) -> __CLPK_doublereal {
  return round(value / toNearest) * toNearest
}

public func didConverge(A: [[__CLPK_doublereal]], B: [[__CLPK_doublereal]]) -> Bool {
    for i in 0..<A.count{
        if round(A[i][i], toNearest: 0.0001) / round(B[i][i], toNearest: 0.0001) == 1.0 {
            return true
        }
    }
    return false
}

func didConverge(A: Matrix, B: Matrix) throws -> Bool {
    for i in 0..<A.row{
        if round(A[i, i], toNearest: 0.0000001) / round(B[i, i], toNearest: 0.0000001) == 1.0 || round(A[i, i], toNearest: 0.0000001) / round(B[i, i], toNearest: 0.0000001) == -1.0 {
            return true
        }
        for j in 0..<A.column {
            if (A[i, j].isNaN || B[i, j].isNaN) {
                throw ComplexEigenvalue.eigenvalueComplex
            }
        }
    }
    return false
}

public func vectorAddition(A: [__CLPK_doublereal], B: [__CLPK_doublereal]) -> [__CLPK_doublereal] {
    var result = [__CLPK_doublereal]()
    for i in 0..<A.count{
        result.append(A[i]+B[i])
    }
    return result
}

public func outer(A: [__CLPK_doublereal], B: [__CLPK_doublereal]) -> [[__CLPK_doublereal]] {
    let m = A.count
    let n = B.count
    var result = [[__CLPK_doublereal]](repeating: [__CLPK_doublereal](repeating: 0.0, count: n), count: m)
    
    for i in 0..<m{
        for j in 0..<m{
            result[i][j] = A[i]*B[j]
        }
    }
    return result
}

public func zerosVector(vector: [__CLPK_doublereal]) -> [__CLPK_doublereal] {
    return [__CLPK_doublereal](repeating: 0.0, count: vector.count)
}

public func copysign(a: __CLPK_doublereal, b: __CLPK_doublereal) -> __CLPK_doublereal{
    let result = abs(a)
    return b.sgn() * result
}

public func getSomeColumn(of matrix: [[__CLPK_doublereal]], column: Int, row: Int) -> [__CLPK_doublereal] {
    var result = [__CLPK_doublereal]()
    for i in row..<matrix.count{
        result.append(matrix[i][column])
    }
    return result
}

public func getSomeColumn(_ matrix: Matrix, column: Int, row: Int) -> [__CLPK_doublereal] {
    var result = [__CLPK_doublereal]()
    for i in row..<matrix.row {
        result.append(matrix[i, column])
    }
    return result
}

public func sliceMatrix(matrix: [[__CLPK_doublereal]], row: Int, column: Int) -> [[__CLPK_doublereal]] {
    var result = [[__CLPK_doublereal]]()
    for i in row..<matrix.count{
        result.append(Array(matrix[i][column...]))
    }
    return result
}

public func dot(vector1: [__CLPK_doublereal], vector2: [__CLPK_doublereal])-> __CLPK_doublereal {
    var result = 0.0
    for i in 0..<vector1.count{
        result += vector1[i] * vector2[i]
    }
    return result
}

public func forwardSubstitution(ofMatrix matrix: [[__CLPK_doublereal]], solutionVector b: [__CLPK_doublereal]) -> [__CLPK_doublereal] {
    var result = [__CLPK_doublereal](repeating: 0.0, count: b.count)
    
    for i in 0..<b.count{
        result[i] = (b[i] - dot(vector1: result, vector2: matrix[i]))/matrix[i][i]
    }
    
    return result
}

public func backwardSubstitution(ofMatrix matrix: [[__CLPK_doublereal]], solutionVector b: [__CLPK_doublereal]) -> [__CLPK_doublereal] {
    var result = [__CLPK_doublereal](repeating: 0.0, count: b.count)
    let n = b.count
    for i in stride(from: n-1, to: -1, by: -1) {
        result[i] = (b[i] - dot(vector1: result, vector2: matrix[i]))/matrix[i][i]
    }
    return result
}

public func isSymmetric(matrix: [[__CLPK_doublereal]]) -> Bool {
    let transposed = Transpose(matrix: matrix)
    for i in 0..<matrix.count{
        for j in 0..<matrix.count{
            if matrix[i][j] != transposed[i][j] {
                return false
            }
        }
    }
    return true
}










//MARK: - INDEPENDENT METHODS FOR MATRIX STRUCT

//MARK: -
public func matrixMultiplication(of matrix1: Matrix, with matrix2: Matrix) throws -> Matrix {
    var C = Matrix(matrixType: MatrixFill.Matrix0s, row: matrix2.row, column: matrix2.column)
    if matrix1.dim() != matrix2.dim() {
        throw MatrixDimensionError.dimensionsDontAgree
    } else {
        for i in 0..<matrix1.row {
            for j in 0..<matrix2.column {
                var sum = 0.0
                for k in 0..<matrix1.row {
                    sum += matrix1[i, k] * matrix2[k, j]
                }
                //let y = Double(round(1000*sum)/1000)
                C[i, j] = sum
            }
        }
    }
    return C
}


//MARK: - If dimensions agree, generates a matrix from 2 vectors
public func MatrixFrom2Vectors(vectorA: [__CLPK_doublereal], vectorB: [__CLPK_doublereal]) throws -> Matrix {
    if vectorA.count == vectorB.count {
        var result = Matrix(matrixType: MatrixFill.Matrix0s, row: vectorB.count, column: vectorA.count)
        
        for i in 0..<vectorB.count{
            for j in 0..<vectorA.count{
                result[i, j] = vectorA[i]*vectorB[j]
            }
        }
        return result
    } else {
        throw MatrixDimensionError.dimensionsDontAgree
    }
}

//MARK: - Finds the trace of the matrix
public func tr(of matrix: Matrix) -> __CLPK_doublereal {
    var trace = 0.0
    for i in 0..<matrix.row {
        trace += matrix[i, i]
    }
    return trace
}
