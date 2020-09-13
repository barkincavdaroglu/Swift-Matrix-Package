//
//  File.swift
//  
//
//  Created by Barkin Cavdaroglu on 8/17/20.
//

import Foundation

public enum InputMatrixError: Error {
    case notSymmetric
    case notSquare
    case singularMatrix
}

public enum ComplexEigenvalue: Error {
    case eigenvalueComplex
}

extension ComplexEigenvalue: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .eigenvalueComplex:
            return NSLocalizedString("Input matrix has complex eigenvalues", comment: "")
        }
    }
}

extension InputMatrixError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .notSymmetric:
            return NSLocalizedString("Input matrix is not symmetric.", comment: "")
        case .notSquare:
            return NSLocalizedString("Input matrix is not square", comment: "")
        case .singularMatrix:
            return NSLocalizedString("Input matrix is singular because its determinant is 0.", comment: "")
        }
        
        
    }
}

public enum MatrixDimensionError: Error {
    case dimensionsDontAgree
}

extension MatrixDimensionError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .dimensionsDontAgree:
            return NSLocalizedString("Dimensions don't agree.", comment: "")
        }
    }
}
