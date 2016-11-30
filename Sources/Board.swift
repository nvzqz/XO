//
//  Board.swift
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

/// A tic-tac-toe board.
public struct Board: Equatable, Sequence, Hashable, ExpressibleByArrayLiteral {

    /// An iterator for a tic-tac-toe board.
    public struct Iterator: IteratorProtocol {

        private let _board: Board

        private var _index: Int

        fileprivate init(_ board: Board) {
            self._board = board
            self._index = 0
        }

        /// Advances to the next element and returns it, or `nil` if no next element
        /// exists.  Once `nil` has been returned, all subsequent calls return `nil`.
        public mutating func next() -> (square: Square, mark: Mark?)? {
            guard let square = Square(rawValue: _index) else {
                return nil
            }
            _index += 1
            return (square, _board[square])
        }

    }

    /// Returns `true` if both boards are the same.
    public static func == (lhs: Board, rhs: Board) -> Bool {
        if lhs._marks._isSameAs(rhs._marks) {
            return true
        }
        for i in 0 ..< 9 where lhs._marks[i] != rhs._marks[i] {
            return false
        }
        return true
    }

    /// The marks on `self`.
    private var _marks: [Mark?]

    /// The empty squares of `self`.
    public var emptySquares: [Square] {
        return Square.all.filter { self[$0] == nil }
    }

    /// An ASCII art representation of `self`.
    public var ascii: String {
        let segment = "+---+---+---+"
        var result = segment
        for y in (0 ..< 3) {
            result += "\n|"
            for x in (0 ..< 3) {
                if let mark = _marks[x + y * 3] {
                    result += " " + mark.description + " |"
                } else {
                    result += "   |"
                }
            }
            result += "\n" + segment
        }
        return result
    }

    /// An emoji representation of `self`.
    public var emoji: String {
        var result = String.UnicodeScalarView()
        for y in (0 ..< 3) {
            for x in (0 ..< 3) {
                if let mark = _marks[x + y * 3] {
                    result.append(mark.emoji())
                } else {
                    result.append("\u{2B1C}") // white square
                }
            }
            result.append("\n")
        }
        return String(result)
    }

    /// The winning mark in `self`, if any.
    public var winner: Mark? {
        if let mark = _marks[0], _marks[4] == mark, _marks[8] == mark {
            return mark
        }
        if let mark = _marks[2], _marks[4] == mark, _marks[6] == mark {
            return mark
        }
        for i in 0 ..< 3 {
            if let mark = _marks[i], _marks[i + 3] == mark, _marks[i + 6] == mark {
                return mark
            }
            if let mark = _marks[i * 3], _marks[i + 1] == mark, _marks[i + 2] == mark {
                return mark
            }
        }
        return nil
    }

    /// The hash value.
    public var hashValue: Int {
        return (0 ..< 9).reduce(0) { result, i in
            let hash = _marks[i]?.hashValue ?? 2
            return result | (hash << (i << 1))
        }
    }

    /// Creates an empty tic-tac-toe board.
    public init() {
        _marks = Array(repeating: nil, count: 9)
    }

    /// Creates a tic-tac-toe board from `marks`.
    public init<S: ExpressibleByUnicodeScalarLiteral & Equatable>(_ marks: [[S]]) {
        self.init()
        for y in marks.indices.prefix(3) {
            for x in marks[y].indices.prefix(3) {
                self[x, y] = Mark(marks[y][x])
            }
        }
    }

    /// Creates a tic-tac-toe board from `emoji`.
    public init(emoji: String) {
        self.init()
        let split = emoji.unicodeScalars.split(separator: "\n")
        for (y, part) in split.prefix(3).enumerated() {
            for (x, scalar) in part.prefix(3).enumerated() {
                self[x, y] = Mark(emoji: scalar)
            }
        }
    }

    /// Creates an instance initialized with the given elements.
    public init(arrayLiteral elements: [UnicodeScalar]...) {
        self.init(elements)
    }

    /// The mark at the square.
    public subscript(square: Square) -> Mark? {
        get {
            return _marks[square.hashValue]
        }
        set {
            _marks[square.hashValue] = newValue
        }
    }

    /// The mark at the x and y indices.
    public subscript(xIndex: Int, yIndex: Int) -> Mark? {
        get {
            return Square(x: xIndex, y: yIndex).flatMap { self[$0] }
        }
        set {
            guard let square = Square(x: xIndex, y: yIndex) else {
                return
            }
            self[square] = newValue
        }
    }

    /// Returns `self` flipped horizontally.
    public func flippedHorizontally() -> Board {
        var copy = self
        copy.flipHorizontally()
        return copy
    }

    /// Flips `self` horizontally.
    public mutating func flipHorizontally() {
        for y in 0 ..< 3 {
            swap(&self[0, y], &self[2, y])
        }
    }

    /// Returns `self` flipped vertically.
    public func flippedVertically() -> Board {
        var copy = self
        copy.flipVertically()
        return copy
    }

    /// Flips `self` vertically.
    public mutating func flipVertically() {
        for x in 0 ..< 3 {
            swap(&self[x, 0], &self[x, 2])
        }
    }

    /// Returns `self` with the marks inverted.
    public func inverse() -> Board {
        var copy = self
        copy.invert()
        return copy
    }

    /// Inverts the marks of `self`.
    public mutating func invert() {
        for square in Square.all {
            self[square]?.invert()
        }
    }

    /// Returns an iterator over the elements of this sequence.
    public func makeIterator() -> Iterator {
        return Iterator(self)
    }

}
