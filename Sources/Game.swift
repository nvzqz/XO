//
//  Game.swift
//  XO
//
//  The MIT License (MIT)
//
//  Copyright (c) 2016 Nikolai Vazquez
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

/// A tic-tac-toe game.
public final class Game {

    /// An error thrown by `applyMark(to:)`.
    public enum ApplyMarkError: Error {

        /// Attempted to apply to non empty square.
        case nonEmpty(Square)

        /// Attempted to apply when winner exists.
        case hasWinner(Mark)

    }

    /// History to undo.
    private var _undoHistory: [Square]

    /// History to redo.
    private var _redoHistory: [Square]

    /// The game board.
    public private(set) var board: Board

    /// The current mark to play.
    public var currentMark: Mark {
        return (_undoHistory.count % 2 == 0) ? .x : .o
    }

    /// Creates a new game.
    public init() {
        board = Board()
        _undoHistory = []
        _redoHistory = []
    }

    /// The squares available to mark.
    public func availableSquares() -> [Square] {
        return board.winner == nil ? board.emptySquares : []
    }

    /// Applies the appropiate mark to `
    public func applyMark(to square: Square) throws {
        if board[square] != nil {
            throw ApplyMarkError.nonEmpty(square)
        }
        if let winner = board.winner {
            throw ApplyMarkError.hasWinner(winner)
        }
        board[square] = currentMark
        _undoHistory.append(square)
    }

}
