//
//  File.swift
//  
//
//  Created by Barkin Cavdaroglu on 8/22/20.
//

import Foundation
import Accelerate

//MARK: - CHOLESKY DECOMPOSITION

extension Matrix {
    public func choleskyDecomposition() throws -> (Matrix, Matrix) {
        if self.isSymmetric() != false {
            var lowerTriangular = Matrix(matrixType: MatrixFill.Matrix0s, row: self.row, column: self.column)
            for i in 0..<self.row {
                for k in 0..<i+1 {
                    var sum = 0.0
                    for j in 0..<k {
                        sum += lowerTriangular[i, j] * lowerTriangular[k, j]
                    }
                    if i == k {
                        lowerTriangular[i, k] = sqrt(self[i, i] - sum)
                    } else {
                        lowerTriangular[i, k] = (1.0 / lowerTriangular[k, k] * (self[i, k] - sum))
                    }
                }
            }
            return (lowerTriangular, lowerTriangular.Transpose())
        } else {
            throw InputMatrixError.notSymmetric
        }
    }
    
    public func solveByCholesky(b: [__CLPK_doublereal]) throws -> [__CLPK_doublereal] {
        do {
            let (lower, transposed) = try choleskyDecomposition()
            let b2 = forwardSub(lower, vectorB: b)
            return backwardSubstitution(transposed, vectorB: b2)
        } catch {
            throw InputMatrixError.notSymmetric
        }
    }
}




//MARK: - LU DECOMPOSITION

extension Matrix {
    public mutating func LU_Decomposition() -> (Matrix, Matrix) {
        var matrixCopy = self
        var LBlock = generateIdentityMatrix(row: matrixCopy.row, column: matrixCopy.column)
        var UBlock = Matrix(matrixType: MatrixFill.Matrix0s, row: matrixCopy.row, column: matrixCopy.column)
        
        for k in 0..<matrixCopy.row {
            UBlock[k, k] = matrixCopy[k, k]
            for i in k+1..<matrixCopy.row {
                LBlock[i, k] = matrixCopy[i, k] / matrixCopy[k, k]
                UBlock[k, i] = matrixCopy[k, i]
            }
            
            for i in k+1..<matrixCopy.row {
                for j in k+1..<matrixCopy.row {
                    matrixCopy[i, j] = (matrixCopy[i, j] - LBlock[i, k] * UBlock[k, j])
                }
            }
        }
        return (LBlock, UBlock)
    }
    
    public mutating func solveByLU(solutionVector: [__CLPK_doublereal]) -> [__CLPK_doublereal] {
        let (L, U) = LU_Decomposition()
        let b2 = forwardSub(L, vectorB: solutionVector)
        return backwardSubstitution(U, vectorB: b2)
    }
    
    public mutating func findDeterminantLU() -> __CLPK_doublereal {
        let (L, U) = LU_Decomposition()
        var detLBlock = 1.0
        var detUBlock = 1.0
        for i in 0..<self.row {
            detLBlock *= L[i, i]
            detUBlock *= U[i, i]
        }
        return detUBlock * detLBlock
    }
}

extension Matrix {
    public func LUP_Decomposition() throws -> (Matrix, Matrix, [__CLPK_doublereal], Matrix) {
        var matrixCopy = self
        var permutations = [__CLPK_doublereal](repeating: 1.0, count: self.row)
        var index = 0
        
        while index < matrixCopy.row {
            permutations[index] = __CLPK_doublereal(index)
            index += 1
        }
        
        for k in 0..<matrixCopy.row {
            var p = 0.0
            var kPrime = k
            for i in k..<matrixCopy.row {
                if abs(matrixCopy[i, k]) > p {
                    p = abs(matrixCopy[i, k])
                    kPrime = i
                }
            }
            
            if p == 0 {
                throw InputMatrixError.singularMatrix
            }
            
            (permutations[k], permutations[kPrime]) = (permutations[kPrime], permutations[k])
            
            for i in 0..<matrixCopy.row {
                (matrixCopy[k, i], matrixCopy[kPrime, i]) = (matrixCopy[kPrime, i], matrixCopy[k, i])
            }
            
            for i in k+1..<matrixCopy.row {
                matrixCopy[i, k] = matrixCopy[i, k] / matrixCopy[k, k]
                for j in k+1..<matrixCopy.row {
                    matrixCopy[i, j] -= matrixCopy[i, k] * matrixCopy[k, j]
                }
            }
        }
        
        var L = Matrix(matrixType: MatrixFill.Matrix0s, row: matrixCopy.row, column: matrixCopy.column)
        var U = Matrix(matrixType: MatrixFill.Matrix0s, row: matrixCopy.row, column: matrixCopy.column)
        
        for i in 0..<matrixCopy.row {
            for j in 0..<matrixCopy.column {
                if (i < j) {
                    U[i, j] = matrixCopy[i, j]
                }
                else if (i == j) {
                    U[i, j] = matrixCopy[i, j]
                    L[i, j] = 1.0
                }
                else if (i > j) {
                    L[i, j] = matrixCopy[i, j]
                }
            }
        }
        return (L, U, permutations, matrixCopy)
    }
    
    public func LUPInvert() throws -> Matrix {
        do {
            let (_, _, P, matrixLU) = try LUP_Decomposition()
            var inverse = Matrix(matrixType: MatrixFill.Matrix0s, row: matrixLU.row, column: matrixLU.column)
            
            for j in 0..<matrixLU.row {
                for i in 0..<matrixLU.column {
                    if P[i] == __CLPK_doublereal(j) {
                        inverse[i, j] = 1.0
                    } else {
                        inverse[i, j] = 0.0
                    }
                    for k in 0..<i {
                        inverse[i, j] -= matrixLU[i, k] * inverse[k, j]
                    }
                }
                
                for i in stride(from: matrixLU.row-1, to: -1, by: -1) {
                    for k in i+1..<matrixLU.row {
                        inverse[i, j] -= matrixLU[i, k] * inverse[k, j]
                    }
                    inverse[i, j] /= matrixLU[i, i]
                }
            }
            return inverse
        } catch {
            throw InputMatrixError.singularMatrix
        }
    }
    
    public func LUP_Solve(solutionVector b: [__CLPK_doublereal]) throws -> [__CLPK_doublereal] {
        do {
            let (L, U, P, _) = try LUP_Decomposition()
            let n = L.row
            var y = [__CLPK_doublereal](repeating: 0.0, count: n)
            
            for i in 0..<n {
                y[i] = b[Int(P[i])]
                for k in 0..<i {
                    y[i] -= L[i, k] * y[k]
                }
            }
            
            for i in stride(from: n-1, to: -1, by: -1) {
                var sum = 0.0
                for j in i+1..<n {
                    sum += U[i, j] * y[j]
                    y[i] -= U[i, j] * y[j]
                }
                y[i] /= U[i, i]
            }
            
            return y
        } catch {
            throw InputMatrixError.singularMatrix
        }
    }
    
    public func findDeterminantLUP() throws -> __CLPK_doublereal {
        do {
            let (L, U, _, _) = try LUP_Decomposition()
            var detLBlock = 1.0
            var detUBlock = 1.0
            
            for i in 0..<self.row {
                detLBlock *= L[i, i]
                detUBlock *= U[i, i]
            }
            
            return detLBlock * detUBlock
        } catch {
            throw InputMatrixError.singularMatrix
        }
    }
}

extension Matrix {
    public func QR_Decomposition() throws -> (Matrix, Matrix) {
        let row = self.row
        var Q = generateIdentityMatrix(row: row, column: self.column)
        var R = self
        
        for i in 0..<row-1 {
            let subColumn = getSomeColumn(R, column: i, row: i) // v1
            var vector0s = zerosVector(vector: subColumn)
            
            let normSubColumn = norm(of: subColumn) //  ||a1||
            vector0s[0] = copysign(a: normSubColumn, b: self[i, i])
            let u = subColumn - vector0s
            
            
            let v = u / norm(of: u)
            var Q_k = generateIdentityMatrix(row: row, column: self.column)
            let multiplier = outer(A: v, B: v) * 2.0
            
            var counter = 0
            var counter2 = 0
            for k in i..<Q_k.row {
                for z in i..<Q_k.row {
                    Q_k[k, z] -= multiplier[counter, counter2]
                    counter2 += 1
                }
                counter2 = 0
                counter += 1
            }
            do {
                R = try Q_k * R
                Q = try Q * Transpose(matrix: Q_k)
            } catch {
                throw error
            }
        }
        return (Q, R)
    }
    
    public mutating func QR_Algorithm() throws -> ([__CLPK_doublereal], Matrix) {
        var temporary = self
        var converged = false
        var eigenvalues = [__CLPK_doublereal]()
        var eigenvectors = generateIdentityMatrix(row: self.row, column: self.column)
        while converged == false {
            do {
                let (Q, R) = try temporary.QR_Decomposition()
                self = try! R * Q //self is the R
                eigenvectors = try eigenvectors * Q
                do {
                    if try didConverge(A: self, B: temporary) {
                        converged = true
                    }
                } catch {
                    throw error
                }
                temporary = self
            } catch {
                throw error
            }
        }
        for i in 0..<self.row {
            eigenvalues.append(self[i, i])
        }
        return (eigenvalues, eigenvectors)
    }
    
    public mutating func Diagonalize() throws -> Matrix {
        var diagonal = Matrix(matrixType: MatrixFill.Matrix0s, row: self.row, column: self.column)
        
        do {
            let (eigenvalues, _) = try QR_Algorithm()
            for i in 0..<diagonal.row {
                diagonal[i, i] = eigenvalues[i]
            }
            return diagonal
        } catch {
            throw error
        }
    }
}

extension Matrix {
    public func MatrixExponent(of exp: Int) throws -> Matrix {
        do {
            var result = self
            let temporary = self
            for _ in 0..<exp-1 {
                result = try result*temporary
            }
            return result
        } catch {
            throw error
        }
    }
}

