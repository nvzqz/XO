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

    /// A space on a board.
    public typealias Space = (location: (x: Int, y: Int), mark: Mark?)

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
        public mutating func next() -> Space? {
            guard _index != 9 else {
                return nil
            }
            defer {
                _index += 1
            }
            let x = _index % 3
            let y = _index / 3
            return ((x, y), _board[x, y])
        }

    }

    /// Returns `true` if both boards are the same.
    public static func == (lhs: Board, rhs: Board) -> Bool {
        if lhs._marks._isSameAs(rhs._marks) {
            return true
        }
        for (rowA, rowB) in zip(lhs._marks, rhs._marks) where !rowA._isSameAs(rowB) {
            for (colA, colB) in zip(rowA, rowB) {
                guard colA == colB else {
                    return false
                }
            }
        }
        return true
    }

    /// The marks on `self`.
    private var _marks: [[Mark?]]

    /// An ASCII art representation of `self`.
    public var ascii: String {
        let segment = "+---+---+---+"
        return _marks.reduce("", { result, row in
            let rowStr = row.reduce("", { $0 + "| \($1?.rawValue ?? " ") " })
            return result + "\(segment)\n" + rowStr + "|\n"
        }) + segment
    }

    /// The hash value.
    public var hashValue: Int {
        return (0 ..< 9).reduce(0) { result, i in
            let x = i % 3
            let y = i / 3
            let h = self[x, y]?.hashValue ?? 2
            return result | (h << (i << 1))
        }
    }

    /// Creates an empty tic-tac-toe board.
    public init() {
        _marks = Array(repeating: Array(repeating: nil, count: 3), count: 3)
    }

    /// Creates a tic-tac-toe board from `characters`.
    public init(_ characters: [[Character]]) {
        self.init()
        for y in 0 ..< characters.endIndex {
            guard y != 3 else {
                break
            }
            for x in 0 ..< characters[y].endIndex {
                guard x != 3 else {
                    break
                }
                self[x, y] = Mark(characters[y][x])
            }
        }
    }

    /// Creates an instance initialized with the given elements.
    public init(arrayLiteral elements: [Character]...) {
        self.init(elements)
    }

    /// The mark at the x and y indices.
    public subscript(xIndex: Int, yIndex: Int) -> Mark? {
        get {
            return _marks[yIndex][xIndex]
        }
        set {
            _marks[yIndex][xIndex] = newValue
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
        for x in 0 ..< 3 {
            for y in 0 ..< 3 {
                self[x, y]?.invert()
            }
        }
    }

    /// Returns an iterator over the elements of this sequence.
    public func makeIterator() -> Iterator {
        return Iterator(self)
    }

}
