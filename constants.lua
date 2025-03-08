-- FEN conversion tables
pieceToFen = {
    [1] = "P", [2] = "N", [3] = "B", [4] = "R", [5] = "Q", [6] = "K",
    [-1] = "p", [-2] = "n", [-3] = "b", [-4] = "r", [-5] = "q", [-6] = "k",
    [0] = ""
}

fenToPiece = {
    P = 1, N = 2, B = 3, R = 4, Q = 5, K = 6,
    p = -1, n = -2, b = -3, r = -4, q = -5, k = -6
}

return {
    pieceToFen = pieceToFen,
    fenToPiece = fenToPiece
}