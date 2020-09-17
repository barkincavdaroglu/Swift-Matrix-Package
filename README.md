# Matrix Package

<img src="https://i.imgur.com/FT0t6kV.png" data-canonical-src="hhttps://i.imgur.com/FT0t6kV.png" width="150" height="150" />

Swift package for matrix operations.
You can install using Swift Package Manager.

## Currently supported:
[1. Matrix Struct](#Matrix-Structure)\
[2. QR Algorithm for finding Eigenvalues, Diagonalization](#QR-Algorithm)\
[3. Cholesky Decomposition](#Cholesky-Decomposition)\
[4. LU Decomposition](#lu-decomposition)\
[5. LUP Decomposition](#lup-decomposition)\
6. Solving Linear Equations via LU, LUP and Cholesky\
7. Matrix Determinant via LU and LUP\
8. Matrix Inverse via LUP\
9. Householder Transformation\
10. Vector Operations
    
# Matrix Structure
There are 2 "data structures" that you can use in calling the operations listed above. First one is standard 2D Array where each array represents a row of matrix. And second one is Matrix struct, 1D array that is more efficient than 2D. Currently, there are 4 ways to initialize Matrix:

```
let matrix = Matrix(values: [Double])
```
Given an array, if the size of the array is a perfect square, then it creates a square matrix with row equal to column number. If not, it finds the 2 divisors of the size of the array that are closest to each other and sets the row and column equal to these numbers. For example, if the values are [-1.0, -2.0, -3.0, -4.0, -5.0, -6.0, -7.0, -8.0, -9.0, -10.0, -11.0, -12.0], this initializer will create a matrix of 4x3 because 4 and 3 are closest divisors of 12, the size of the array.

```
let matrix = Matrix(values: [Double], row: Int, column: Int)
```
Initializes the matrix with input array values and shapes it according to input row and column numbers.

```
let matrix = Matrix()
```
Initializes with empty array and sets row and column equal to 0.

```
let matrix = Matrix(matrixType: MatrixFill, row: Int, column: Int)
```
Initializes either a matrix of 0s or a matrix of 1s, depending on MatrixFill (set the parameter to MatrixFill.Matrix0s if you want 0s matrix or MatrixFill.Matrix1s if you want 1s matrix) with dimensions row x column.


### QR Algorithm
QR for matrix struct in the example below executed in approximately 0.006657004356384277 seconds, compared to 0.011546015739440918 for 2D arrays
```
var matrix = Matrix(values: [-0.44529, 4.9063, -0.87871, 6.3036, -6.3941, 13.354, 1.6668, 11.945, 3.6842, -6.6617, -0.060021, -7.0043, 3.1209, -5.2052, -1.4130, -2.8484])

do {
    let eigenvalues = (try matrix3.QR_Algorithm())
    print(eigenvalues) // approximately [4.0016920231545985, 2.99991063957603, 1.9984874945373767, 1.0001988427319772]

} catch {
    print(error)
}
```


### Cholesky Decomposition
```
let symmetricMatrix = Matrix(values: [4.0, 12.0, -16.0, 12.0, 37.0, -43.0, -16.0, -43.0, 98.0])

let symmetricEquations = Matrix(values: [6.0, 15.0, 55.0, 15.0, 55.0, 225.0, 55.0,225.0, 979.0])

let solutionVector = [76.0, 295.0, 1259.0]

do {
    let solution = try symmetricEquations.solveByCholesky(b: solutionVector)
    print(solution) // [1.0000000000000178, 0.9999999999999707, 1.000000000000006]

} catch {
    print(error.localizedDescription)
}
```


### LU Decomposition
```
var matrix = Matrix(values: [1.0, 2.0, 4.0, 3.0, 8.0, 14.0, 2.0, 6.0, 13.0])

print(matrix.findDeterminant()) // 6.0

let solutions = matrix.solveByLU(solutionVector: [Double])

let (L, U) = matrix.LU_Decomposition() 

     | 1.0  0.0  0.0 |
L =  | 3.0  1.0  0.0 |
     | 2.0  1.0  1.0 |
     
     | 1.0  2.0  4.0 |
U =  | 0.0  2.0  2.0 |
     | 0.0  0.0  3.0 |
```


### LUP Decomposition

```
var matrix = Matrix(values: [1.0, 1.0, -1.0, 3.0, -2.0, 1.0, 1.0, 3.0, -2.0])

do {
    print(try matrix.LUP_Solve(solutionVector: [6.0, -5.0, 14.0])) // [1.0, 3.000000000000001, -1.9999999999999984]
} catch {
    print(error)
}

do {
    print(try matrix.findDeterminantLUP()) // -3.0
} catch {
    print(error)
}

do {
    let inverse = try matrix.LUPInvert()
    
           | -0.333333333333333  0.3333333333333334  0.3333333333333334 |
inverse =  | -2.333333333333334  0.3333333333333334  1.3333333333333335 |
           | -3.666666666666667  0.6666666666666667  1.6666666666666667 |

} catch {
    print(error)
}
```


You can append a row to a matrix

You can append a column to a matrix

You can get the element at index i, j 
```
let matrix = Matrix(values: [1.0, 2.0, 3.0, 4.0])
let x22 = matrix[1, 1] // returns 4.0
```

You can get a row
```
let matrix = Matrix(values: [1.0, 2.0, 3.0, 4.0])
let row1 = matrix[1, nil] // returns [1.0, 2.0]
```

You can get a column
```
let matrix = Matrix(values: [1.0, 2.0, 3.0, 4.0])
let col2 = matrix[nil, 1] // returns [2.0, 4.0]
```

You can get the column view of the matrix
```
let matrix = Matrix(values: [1.0, 2.0, 3.0, 4.0])
let columnView = matrix.getAllColumns() // returns [1.0, 3.0, 2.0, 4.0]
```

You can add, substract and multiply matrices
```
let matrix1 = Matrix(values: [1.0, 2.0, 3.0, 4.0])
let matrix2 = Matrix(values: [3.0, 6.0, 9.0, 12.0])
let substracted = matrix1 - matrix2
let added = matrix1 + matrix2
let multiplied = matrix1 * matrix2
```

You can get the dimension of the matrix

You can get the trace of the matrix

You can check if the matrix is upper triangular

You can transpose a matrix

You can generate identity matrix

All the other methods listed initially will be compatible with the matrix struct as soon as I finish them.

## If you don't want to use Matrix Struct (i.e. you already have your data in 2D arrays), same methods exist for 2D arrays too

### LUP Decomposition
Use LUP to invert matrices, find determinants and solve linear equations in the form Ax = b. LUP Decomposition has 2 "main" methods that are almost exactly the same. One of them (LUP_DecompositionD()) returns the decomposed version of LU, whereas the other (LUP_DecompositionC()) modifies the input matrix in place. This is because inverting matrices through LUP requires the composite version of the matrix whereas solving linear equations requires the decomposed (L, U, P) version.

```
let matrix = [[1.0, 2.0, 0.0], [3.0, 4.0, 4.0], [5.0, 6.0, 3.0]]
let lup = LUPDecomposition(matrix: matrix)
let p = lup.LUP_DecompositionC() // The permutation array
let inversed = lup.LUPInvert(matrixP: p)
```
```
let matrix = [[1.0, 1.0, -1.0], [3.0, -2.0, 1.0], [1.0, 3.0, -2.0]]
let lup = LUPDecomposition(matrix: matrix)
let (l, u, p) = lup.LUP_DecompositionD()
let determinant = lup.findDeterminant(L: L, U: U) 
let result = lup.LUP_Solve(L: l, U: u, P: p, b: [6.0, -5.0, 14.0])
// returns approx. [1.0, 3.000000000000001, -1.99999999994]
```

### QR Algorithm/Decomposition for Finding Eigenvalues

```
let matrix = [[52.0, 30.0, 49.0, 28.0], [30.0, 50.0, 8.0, 44.0], [49.0, 8.0, 46.0, 16.0], [28.0, 44.0, 16.0, 22.0]]
let matrix2 = [[-0.44529, 4.9063, -0.87871, 6.3036], [-6.3941, 13.354, 1.6668, 11.945], [3.6842, -6.6617, -0.060021, -7.0043], [3.1209, -5.2052, -1.4130, -2.8484]]
let qr = QR(matrix: matrix)
let eigenvalues = qr.QR_Algorithm()
// returns [132.718, 52.484, -11.553, -3.535] for matrix 
// returns [4.0016920231545985, 2.999910639576025, 1.9984874945373767, 1.0001988427319808] for matrix2 
// Example (matrix2) is taken from https://people.inf.ethz.ch/arbenz/ewp/Lnotes/chapter4.pdf
```

### LU_Decomposition
You can use LU decomposition to find determinant of matrix and solve linear equations. However, if the element at position matrix[0][0] is 0, this method fails because it includes division by that element. If this may be the case for you, please use LUP Decomposition instead. 
```
let matrix = [[1.0, 1.0, 1.0], [4.0, 3.0, -1.0], [3.0, 5.0, 3.0]]
let lu = LUDecomposition(for: matrix)
lu.LUDecomposition()
lu.findDeterminant() // returns 10.0
lu.solve(solutionVector: [1.0, 6.0, 4.0]) // returns [1.0, 0.5, -0.5]
```

### Eigenvalues for 2x2 and 3x3 Matrices
QR Algorithm can run forever if the eigenvalues are too close to each other. Currently, algorithm stops running when the eigenvalues found in current iteration divided by those found in previous iteration equals to 1, meaning there is no improvement to be made. If you want a safer (and a more efficient) method for finding eigenvalues for smaller matrices, you can use these:

```
let matrix = [[1.0, -3.0, 3.0] , [3.0, -5.0, 3.0], [6.0, -6.0, 4.0]]
let eigenvalues = eigen3(matrix: matrix11)
// returns [4.0, -2.0]
let matrix = [[3.42, 8.12], [1.11, 22.4]]
let eigenvalues = eigen2(matrix: matrix)
// returns [22.863557153098586, 2.956442846901414]
```

### Cholesky Decomposition
Cholesky decomposes a symmetric real matrix into L (lower triangular) and L<sup>T</sup> (transposed lower triangular, which is upper triangular) matrices, making it easy to solve linear equations and do other calculations. It is considerably faster than LUP in solving linear equations. If you want to receive L and L<sup>T</sup>, use choleskyDecomposition() method after initializing the object with your matrix. If you only want to solve linear equations, use solve(b: [Double]) method after initializing, which returns an array of solutions.

```
let matrix = [[6.0, 15.0, 55.0], [15.0, 55.0, 225.0], [55.0, 225.0, 979.0]]
let b = [76.0, 295.0, 1259.0]
do {
    let chol = try Cholesky(matrix: matrix)
    let resol = chol?.solve(solutionVector: b) // returns [1.0000000000000178, 0.9999999999999707, 1.000000000000006]
} catch {
    print(error.localizedDescription) // prints "Input matrix is not symmetric." 
}
```

You don't need to check if your matrix is symmetric. Initialization will throw notSymmetric error along with localized description if its not.

### Standalone Householder Transformation
Used to convert a matrix to tridiagonal form. The resulting matrix will not be tridiagonal unless the input matrix is not symmetric.

```
let matrix = [[4.0, 1.0, -2.0, 2.0], [1.0, 2.0, 0.0, 1.0], [-2.0, 0.0, 3.0, -2.0], [2.0, 1.0, -2.0, -1.0]] 
// example from https://en.wikipedia.org/wiki/Householder_transformation
let A = HouseholderTransformation(of: matrix)
// returns all of the iterations on A. I will modify it later so that it returns the last A, along with some other edits needed to make it more readable and 
// efficient. You can still get the last A by using [back: last index] until then.
// Last A: 
// [4.0, -3.000000000000001, 1.332267629550198e-16, -9.325873406851313e-16]
// [-3.000000000000001, 3.3333333333333357, -1.666666666666667, -6.661338147750939e-16]
// [1.332267629550198e-16, -1.666666666666667, -1.3200000000000018, 0.9066666666666625]
// [-9.325873406851313e-16, -4.440892098500626e-16, 0.9066666666666623, 1.9866666666666695]
```

### Cramer's Rule

```
let matrix = [[1.0, 1.0, -1.0], [3.0, -2.0, 1.0], [1.0, 3.0, -2.0]]
let cram = Cramers(matrix: matrix3)
let result = cram.cramersRule(b: [6.0, -5.0, 14.0])
```
solves linear equations in the format Ax = b, A being the matrix, b being the values each equation is equal to, and x being the array of answers.
Not efficient for matrices with dimensions higher than 3. Please use LUP for those.


## Helper Functions

### Matrix0
Generates an mxn matrix of 0s
```
let matrix = Matrix0(of: 3, n: 3) // [[0.0, 0.0, 0.0], [0.0, 0.0, 0.0], [0.0, 0.0, 0.0]]
```
### Matrix1
Generates an mxn matrix of 1s
```
let matrix = Matrix1(of 3, n: 3) // [[1.0, 1.0, 1.0], [1.0, 1.0, 1.0], [1.0, 1.0, 1.0]]
````
### generateIdentityMatrix
Generates identity matrix with given dimension
```
let matrix = generateIdentityMatrix(for: 2) // [[1.0, 0.0], [0.0, 1.0]]
```
### MatrixFrom2Vectors
If dimensions agree, generates a matrix from 2 vectors. Most useful when you want to multiply a vector with its transpose such that a vector of dimension 5x1 becomes 1x5 and generates a 5x5 matrix as a result of its multiplication.
```
let vector1 = [1.0, 2.0, 3.0]
let vector2 = [1.0, 2.0, 3.0]
let matrix = MatrixFrom2Vectors(vector1: vector1, vector2: vector2) // 3x3 matrix
```

### scalarVectorMultiplication
Multiplies a vector by a scalar
```
let vector = [1.0, 2.0, 3.0]
let scalar = 3.0
let result = scalarVectorMultiplication(vector: vector, scalar: scalar)
```

### forwardSubstitution

### backwardSubstitution

### dot

### norm
Returns the norm of a vector
```
let vector = [1.0, 2.0, 3,0]
let result = norm(of: vector)
```

### matrixScalarMultiplication
Multiplies a matrix by a scalar
```
let matrix = [[1.0, 2.0, 3.0], [1.0, 2,0, 3,0], [1.0, 2.0, 3.0]]
let scalar = 3.0
let result = matrixScalarMultiplication(matrix: matrix, scalar: scalar)
```

### matrixMultiplication
Multiplies a matrix by another if dimensions agree
```
let matrix1 = [[1.0, 2.0, 3.0], [1.0, 2,0, 3,0], [1.0, 2.0, 3.0]]
let matrix2 = [[1.0, 2.0, 3.0], [1.0, 2,0, 3,0], [1.0, 2.0, 3.0]]
let result = matrixMultiplication(of: matrix1, with: matrix2)
```

### tr
Find the trace of the matrix
```
let matrix = [[1.0, 2.0, 3.0], [1.0, 2,0, 3,0], [1.0, 2.0, 3.0]]
let trace = tr(of: matrix)
```

### Transpose
Transposes the matrix
```
let matrix = [[1.0, 2.0, 3.0], [1.0, 2,0, 3,0], [1.0, 2.0, 3.0]]
let transposed = Transpose(matrix: matrix)
```

### getAllColumns
Returns the column view of the matrix
```
let matrix = [[1.0, 2.0, 3.0], [1.0, 2,0, 3,0], [1.0, 2.0, 3.0]]
let columnView = getAllColumns(of: matrix) /// [[1.0, 1.0, 1.0], [2.0, 2.0, 2.0], [3.0, 3.0, 3.0]]
```

### isIdempotent
Checks if the matrix is idempotent
```
let matrix = [[1.0, 2.0, 3.0], [1.0, 2,0, 3,0], [1.0, 2.0, 3.0]]
let idempotent = isIdempotent(matrix: matrix)
```

### isInvolutory
Checks if the matrix is involutory
```
let matrix = [[1.0, 2.0, 3.0], [1.0, 2,0, 3,0], [1.0, 2.0, 3.0]]
let involutory = isInvolutory(matrix: matrix)
```

### isUpperTriangular
Checks if the matrix is upper triangular
```
let matrix = [[1.0, 2.0, 3.0], [1.0, 2,0, 3,0], [1.0, 2.0, 3.0]]
let upperTriangular = isUpperTriangular(of: matrix)
```

### vectorAddition
Adds two vectors
```
let vector1 = [1.0, 2.0, 3.0]
let vector2 = [1.0, 2.0, 3.0]
let result = vectorAddition(A: vector1, B: vector2)
```

### outer (from numpy)

### zerosVector (from numpy)
Generates a vector of 0s of input vector's dimension

### copysign (from numpy)

### getSomeColumn 

### sliceMatrix ([:, number:]


## Extensions
