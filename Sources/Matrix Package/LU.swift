//
//  File.swift
//  
//
//  Created by Barkin Cavdaroglu on 8/15/20.
//

import Foundation

open class LUDecomposition {
    private var matrix: [[Double]]
    private var m: Int
    private var n: Int
    var LBlock: [[Double]]
    var UBlock: [[Double]]
    
    init(for matrix: [[Double]]) {
        self.matrix = matrix
        self.m = matrix.count
        self.n = matrix[0].count
        self.LBlock = [[Double]]( repeating: [Double](repeating: 0.0, count: matrix[0].count), count: matrix.count)
        self.UBlock = [[Double]]( repeating: [Double](repeating: 0.0, count: matrix[0].count), count: matrix.count)
    }
    
    //MARK: - L is an nxn matrix with 1s on the diagonal and 0s above
    func makeLBlock() {
        for i in 0..<self.m {
            self.LBlock[i][i] = 1.0
        }
    }
    
    public func stringHelper(for block: [[Double?]]) {
            for each in 0..<block.count {
                print("\(block[each])")
            }
    }
    
    public func LUDecomposition() {
        makeLBlock()
        for k in 0..<self.m {
            self.UBlock[k][k] = self.matrix[k][k]
            for i in k+1..<self.m {
                self.LBlock[i][k] = self.matrix[i][k]/self.matrix[k][k]
                self.UBlock[k][i] = self.matrix[k][i]
            }
            
            for i in k+1..<self.m {
                for j in k+1..<self.m {
                    self.matrix[i][j] = (self.matrix[i][j] - self.LBlock[i][k]*self.UBlock[k][j])
                }
            }
        }
    }
    
    public func getLU() -> ([[Double]], [[Double]]) {
        return (self.LBlock, self.UBlock)
    }
    
    public func solve(solutionVector: [Double]) -> [Double] {
        let (lower, upper) = getLU()
        let b2 = forwardSubstitution(ofMatrix: lower, solutionVector: solutionVector)
        return backwardSubstitution(ofMatrix: upper, solutionVector: b2)
    }
    
    public func findDeterminant() -> Double {
        var determinantLBlock = 1.0
        var determinantUBlock = 1.0
        for i in 0..<self.m {
            determinantLBlock *= self.LBlock[i][i]
            determinantUBlock *= self.UBlock[i][i]
        }
        return determinantUBlock * determinantLBlock
    }
}
