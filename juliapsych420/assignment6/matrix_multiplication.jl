using LinearAlgebra

"""
multiplyMatrix
Multiplies two matrices. The second dimension of matA must equal the first
dimension of matB.

Args:
    matA: A matrix (or array) with `m` by `n` elements.
    matB: Another matrix (or array) that should be `n` by `p`.

Returns:
    matC: A matrix with `m` by `p` elements.
"""
function multiplyMatrix(matA, matB)
    if size(matA, 2) != size(matB, 1)
        matASize = size(matA, 2)
        matBSize = size(matB, 1)
        return ErrorException("""
        The size of the second dimension of Matrix A, $(matASize), does not
        match the size of the first deminsion of Matrix B, $(matBSize).
        """)
    end

    matC = matA * matB

    return matC
end