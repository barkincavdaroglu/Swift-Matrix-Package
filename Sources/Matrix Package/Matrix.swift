//
//  File.swift
//  
//
//  Created by Barkin Cavdaroglu on 8/18/20.
//

import Foundation
import Accelerate

public enum MatrixFill {
    case Matrix0s
    case Matrix1s
}

public enum MatrixType {
    case square
    case rectangular
    case upperTriangular
    case symmetric
}

public struct Matrix {
    public var matrix: [__CLPK_doublereal]
    public var row: Int
    public var column: Int
    public var type: MatrixType?
    
    public init() {
        self.matrix = [Double]()
        self.row = 0
        self.column = 0
    }
    
    public init(values: [Double]) {
        self.matrix = values
        if values.count.isPerfectSquare {
            self.type = MatrixType.square
            self.row = Int(sqrt(__CLPK_doublereal(values.count)))
            self.column = Int(sqrt(__CLPK_doublereal(values.count)))
        } else {
            self.type = MatrixType.rectangular
            let (m, n) = closestDivisors(of: values.count)
            self.row = m
            self.column = n
        }
    }
    
    mutating public func appendRow(row: [Double]) {
        if self.matrix.count == 0 {
            self.matrix.append(contentsOf: row)
            self.row += 1
            self.column += row.count
        } else {
            self.matrix.append(contentsOf: row)
            self.row += 1
        }
    }
    
    mutating public func appendCol(column: [Double]) throws {
        if self.matrix.count == 0 {
            self.matrix.append(contentsOf: column)
            self.row += column.count
            self.column += 1
        } else {
            if self.row == column.count { // Initial matrix is not empty. Any column that we add must have the same number as the number of rows of the current matrix.
                var indexShifter = 0
                for elementIndex in 0..<column.count{
                    self.matrix.insert(column[elementIndex], at: elementIndex*self.column + self.column + indexShifter)
                    indexShifter += 1
                }
                self.column += 1
            } else if self.row != column.count {
                throw MatrixDimensionError.dimensionsDontAgree
            }
        }
        
    }

    //MARK: - Initialize matrix with given array, column and row
    public init(values: [__CLPK_doublereal], row: Int, column: Int) {
        self.matrix = values
        self.row = row
        self.column = column
        if row == column {
            self.type = MatrixType.square
        } else {
            self.type = MatrixType.rectangular
        }
    }
    
    
    //MARK: - Initialize matrix filled with 0s or 1s
    public init(matrixType: MatrixFill, row: Int, column: Int) {
        if matrixType == MatrixFill.Matrix0s {
            self.matrix = [__CLPK_doublereal](repeating: 0.0, count: row*column)
            self.row = row
            self.column = column
            if row == column {
                self.type = MatrixType.square
            } else {
                self.type = MatrixType.rectangular
            }
        }
        else {
            self.matrix = [__CLPK_doublereal](repeating: 1.0, count: row*column)
            self.row = row
            self.column = column
            if row == column {
                self.type = MatrixType.square
            } else {
                self.type = MatrixType.rectangular
            }
        }
    }
    
    //Get the element at row i column j
    public subscript(row: Int, column: Int) -> __CLPK_doublereal {
        get {
            return self.matrix[(row*self.column) + column]
        }
        set(value) {
            self.matrix[(row*self.column) + column] = value
        }
    }
    
    //Get-set the ith row of the the matrix
    public subscript(row: Int, column: Int? = nil) -> [__CLPK_doublereal] {
        get {
            return Array(self.matrix[row*self.column..<(row*self.column)+self.column])
        }
        set(rowValues) {
            for i in 0..<self.column{
                self.matrix[row*self.column + i] = rowValues[i]
            }
        }
    }
    
    //Get-set the jth column of the matrix
    //Set needs work
    public subscript(row: Int? = nil, column: Int) -> [__CLPK_doublereal] {
        get {
            var col = [Double]()
            for columnIndex in 0..<self.row{
                col.append(self.matrix[columnIndex*self.column + column])
            }
            return col
        }
        set(colValues) {
            for columnIndex in 0..<self.row{
                self[column][columnIndex] = colValues[columnIndex]
            }
        }
    }
    
    //MARK: - Returns the size of current matrix
    public func count() -> Int {
        return self.matrix.count
    }
    
    //MARK: - Returns the size of input matrix
    public func count(matrix: Matrix) -> Int {
        return matrix.matrix.count
    }
    
    //MARK: - Returns the string version "mxn" of matrix dimension
    public func dim() -> String {
        return "\(self.matrix.count/self.column)x\(self.matrix.count/self.row)"
    }
    
    //MARK: - Returns the tuple version (m, n) of matrix dimension
    public func dim() -> (Int, Int) {
        return (self.row, self.column)
    }
    
    //MARK: - Generates Identity Matrix with given dimension
    public func generateIdentityMatrix(row: Int, column: Int) -> Matrix {
        var identityMatrix = Matrix(matrixType: MatrixFill.Matrix0s, row: row, column: column)
        
        for i in 0..<row{
            identityMatrix[i, i] = 1.0
        }
        
        return identityMatrix
    }
    
    //MARK: - Generates an mxn matrix of 0s
    public func Matrix0(row: Int, column: Int) -> Matrix {
        return Matrix(matrixType: MatrixFill.Matrix0s, row: row, column: column)
    }
    
    //MARK: - Generates an mxn matrix of 1s
    public func Matrix1(row: Int, column: Int) -> Matrix {
        return Matrix(matrixType: MatrixFill.Matrix1s, row: row, column: column)
    }

    //MARK: - Finds the trace of the matrix
    public func tr() -> __CLPK_doublereal {
        var trace = 0.0
        for i in 0..<self.row {
            trace += self[i, i]
        }
        return trace
    }
    
    //MARK: - Transposes the matrix
    public func Transpose() -> Matrix {
        var transposedMatrix = self
        for i in 0..<transposedMatrix.row {
            for j in 0..<transposedMatrix.column {
                transposedMatrix[i, j] = self[j, i]
            }
        }
        return transposedMatrix
    }
    
    public func Transpose(matrix: Matrix) -> Matrix {
        var transposedMatrix = matrix
        for i in 0..<transposedMatrix.row {
            for j in 0..<transposedMatrix.column {
                transposedMatrix[i, j] = matrix[j, i]
            }
        }
        return transposedMatrix
    }
    
    //MARK: - Returns the column view of the matrix
    public func getAllColumns() -> Matrix {
        var columns = Matrix()
        for i in 0..<self.column{
            columns.appendRow(row: self[nil, i])
        }
        return columns
    }
    
    public func isUpperTriangular() throws -> Bool {
        if self.type == MatrixType.square {
            var isUpperTriangular: Bool = true
            for i in 1..<self.row {
                for j in 0..<i {
                    if self[i, j] != 0 {
                        isUpperTriangular = false
                        break
                    }
                }
            }
            return isUpperTriangular
        } else {
            throw InputMatrixError.notSquare
        }
    }
    
    public func isSymmetric() -> Bool {
        let transposed = self.Transpose()
        for i in 0..<self.row {
            for j in 0..<self.column {
                if self[i, j] != transposed[i, j] {
                    return false
                }
            }
        }
        return true
    }
    
    public func forwardSub(_ matrixA: Matrix, vectorB: [__CLPK_doublereal]) -> [__CLPK_doublereal] {
        var result = [__CLPK_doublereal](repeating: 0.0, count: vectorB.count)
        for i in 0..<vectorB.count{
            result[i] = (vectorB[i] - dot(vector1: result, vector2: matrixA[i, nil]))/matrixA[i, i]
        }
        return result
    }
    
    func backwardSubstitution(_ matrixA: Matrix, vectorB: [__CLPK_doublereal]) -> [__CLPK_doublereal] {
        var result = [__CLPK_doublereal](repeating: 0.0, count: vectorB.count)
        let n = vectorB.count
        for i in stride(from: n-1, to: -1, by: -1) {
            result[i] = (vectorB[i] - dot(vector1: result, vector2: matrixA[i]))/matrixA[i, i]
        }
        return result
    }
    
    
    //MARK: - Basic Operators for Matrix
    public static func - (left: Matrix, right: Matrix) -> Matrix {
        var result = Matrix(matrixType: MatrixFill.Matrix0s, row: left.row, column: right.column)
        for i in 0..<left.row {
            for j in 0..<right.column {
                result[i, j] = left[i, j] - right[i, j]
            }
        }
        return result
    }
    
    public static func +(lhs: Matrix, rhs: Matrix) -> Matrix {
        var result = Matrix(matrixType: MatrixFill.Matrix0s, row: lhs.row, column: rhs.column)
        for i in 0..<lhs.row{
            for j in 0..<rhs.column {
                result[i, j] = lhs[i, j] + rhs[i, j]
            }
        }
        return result
    }
    
    public static func *(lhs: Matrix, rhs: __CLPK_doublereal) -> Matrix {
        var result = lhs
        for i in 0..<result.matrix.count {
            result.matrix[i] *= rhs
        }
        return result
    }
    
    public static func *(lhs: __CLPK_doublereal, rhs: Matrix) -> Matrix {
        var result = rhs
        for i in 0..<result.matrix.count {
            result.matrix[i] *= lhs
        }
        return result
    }
    
    public static func *(lhs: Matrix, rhs: Matrix) throws -> Matrix {
        var C = Matrix(matrixType: MatrixFill.Matrix0s, row: rhs.row, column: rhs.column)
        if lhs.column != rhs.row {
            throw MatrixDimensionError.dimensionsDontAgree
        } else {
            for i in 0..<lhs.row {
                for j in 0..<rhs.column {
                    var sum = 0.0
                    for k in 0..<rhs.row {
                        sum += lhs[i, k] * rhs[k, j]
                    }
                    //let y = Double(round(1000*sum)/1000) //Rounded for householder transformation 
                    C[i, j] = sum
                }
            }
        }
        return C
    }
}

//MARK: OUTER FOR MATRIX STRUCT
public func outer(A: [__CLPK_doublereal], B: [__CLPK_doublereal]) -> Matrix {
    let m = A.count
    let n = B.count
    var result = Matrix(matrixType: MatrixFill.Matrix0s, row: m, column: n)
    
    for i in 0..<m {
        for j in 0..<m {
            result[i, j] = A[i]*B[j]
        }
    }
    return result
}

extension Matrix: CustomStringConvertible {
    public var description: String {
        var string = ""
        
        for i in 0..<self.row{
            let row = self[i, nil]
            string += "|"
            for j in row {
                string += " " + String(round(j, toNearest: 0.0001)) + " "
            }
            string += "|"
            string += "\n"
        }
        return string
    }
}

//MARK: - https://stackoverflow.com/questions/43301933/swift-3-find-if-the-number-is-a-perfect-square
extension BinaryInteger {
    var isPerfectSquare: Bool {
        guard self >= .zero else { return false }
        var sum: Self = .zero
        var count: Self = .zero
        var squareRoot: Self = .zero
        while sum < self {
            count += 2
            sum += count
            squareRoot += 1
        }
        return squareRoot * squareRoot == self
    }
}

public func closestDivisors(of x: Int) -> (Int, Int) {
    let roundedSqrt = __CLPK_doublereal(x).squareRoot()
    var didFind = false
    var result1 = Int(round(roundedSqrt))
    var result2 = 1
    while !didFind {
        result2 = Int(x/result1)
        if result2 * result1 == x {
            didFind = true
        } else {
            result1 -= 1
        }
    }
    return (result1, result2)
    
}
