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
public final class Game: Equatable {

    /// An error thrown by `applyMark(to:)`.
    public enum ApplyMarkError: Error {

        /// Attempted to apply to non empty square.
        case nonEmpty(Square)

        /// Attempted to apply when winner exists.
        case hasWinner(Mark)

    }

    /// Returns `true` if both games are the same.
    public static func == (lhs: Game, rhs: Game) -> Bool {
        if lhs === rhs {
            return true
        } else {
            return lhs.board == rhs.board
                && lhs._undoHistory == rhs._undoHistory
                && lhs._redoHistory == rhs._redoHistory
        }
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

    /// Creates a new game from `history`.
    public convenience init(history: [Square]) throws {
        self.init()
        for square in history {
            try applyMark(to: square)
        }
    }

    /// Creates a new game from `uncheckedHistory`.
    public convenience init(uncheckedHistory: [Square]) {
        self.init()
        for square in uncheckedHistory {
            applyUncheckedMark(to: square)
        }
    }

    /// Applies the appropiate mark to `square` without checking for error.
    public func applyUncheckedMark(to square: Square) {
        board[square] = currentMark
        _undoHistory.append(square)
        _redoHistory.removeAll()
    }

    /// Applies the appropiate mark to `square`.
    public func applyMark(to square: Square) throws {
        if board[square] != nil {
            throw ApplyMarkError.nonEmpty(square)
        }
        if let winner = board.winner {
            throw ApplyMarkError.hasWinner(winner)
        }
        applyUncheckedMark(to: square)
    }

    /// Returns the square for the last mark.
    public func squareForUndo() -> Square? {
        return _undoHistory.last
    }

    /// Returns the square for the last undone mark.
    public func squareForRedo() -> Square? {
        return _redoHistory.last
    }

    /// Undoes the previous mark and returns its square.
    @discardableResult
    public func undo() -> Square? {
        if let square = _undoHistory.popLast() {
            board[square] = nil
            _redoHistory.append(square)
            return square
        } else {
            return nil
        }
    }

    /// Redoes the previous undone mark and returns its square.
    @discardableResult
    public func redo() -> Square? {
        if let square = _redoHistory.popLast() {
            board[square] = currentMark
            _undoHistory.append(square)
            return square
        } else {
            return nil
        }
    }

}
