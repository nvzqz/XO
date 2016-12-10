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
        if UnsafePointer(lhs._marks) == UnsafePointer(rhs._marks) {
            return true
        }
        for i in 0 ..< 9 where lhs._marks[i] != rhs._marks[i] {
            return false
        }
        return true
    }

    /// Returns `true` if the count of `x` is equal to that of `o` or the count of `x` is one more than that of `o`.
    ///
    /// - parameter counts: The counts of `Mark.x` and `Mark.o`.
    public static func isValid(counts: (x: Int, o: Int)) -> Bool {
        let (x, o) = counts
        return (x == o) || (x == o + 1)
    }

    /// The marks on `self`.
    private var _marks: [Mark?]

    /// Whether `self` is empty.
    public var isEmpty: Bool {
        return !_marks.contains(where: { $0 != nil })
    }

    /// Whether `self` is full.
    public var isFull: Bool {
        return !_marks.contains(where: { $0 == nil })
    }

    /// Whether `self` is finished. In other words, there are no more available squares.
    public var isFinished: Bool {
        return winner != nil || isFull
    }

    /// Whether the count of `x` is equal to that of `o` or the count of `x` is one more than that of `o`.
    public var isValid: Bool {
        return Board.isValid(counts: markCounts)
    }

    /// Whether the horizontal reflection of `self` is the same as `self`.
    public var reflectsHorizontally: Bool {
        for i in 0 ..< 3 {
            let a = i * 3
            let b = a + 2
            if _marks[a] != _marks[b] {
                return false
            }
        }
        return true
    }

    /// Whether the vertical reflection of `self` is the same as `self`.
    public var reflectsVertically: Bool {
        for i in 0 ..< 3 where _marks[i] != _marks[i + 6] {
            return false
        }
        return true
    }

    /// Whether the combination of horizontal and vertical reflections of `self` is the same as `self`.
    public var reflectsHorizontallyAndVertically: Bool {
        for i in 0 ..< 4 where _marks[i] != _marks[8 - i] {
            return false
        }
        return true
    }

    /// The counts of `x` and `y` in `self`.
    public var markCounts: (x: Int, o: Int) {
        var xCount = 0
        var oCount = 0
        for mark in _marks {
            if let mark = mark {
                switch mark {
                case .x:
                    xCount += 1
                case .o:
                    oCount += 1
                }
            }
        }
        return (xCount, oCount)
    }

    /// The empty squares of `self`.
    public var emptySquares: LazyFilterBidirectionalCollection<[Square]> {
        return Square.all.lazy.filter { self[$0] == nil }
    }

    /// The available squares to mark.
    public var availableSquares: LazyFilterBidirectionalCollection<[Square]>? {
        return winner == nil ? emptySquares : nil
    }

    /// An ASCII art representation of `self`.
    public var ascii: String {
        return string(x: "x", o: "o", none: ".", padding: 2)
    }

    /// An emoji representation of `self`.
    public var emoji: String {
        return string(x: "\u{274C}", o: "\u{2B55}", none: "\u{2B1C}")
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
        var result = 0
        for i in 0 ..< 9 {
            let hash = _marks[i]?.hashValue ?? 2
            result |= (hash << (i << 1))
        }
        return result
    }

    /// Creates a tic-tac-toe board from `_marks`.
    ///
    /// - warning: The array should have at least 9 elements.
    private init(_marks: [Mark?]) {
        self._marks = _marks
    }

    /// Creates an empty tic-tac-toe board.
    public init() {
        _marks = Array(repeating: nil, count: 9)
    }

    /// Creates a tic-tac-toe board from a hash value.
    public init(hashValue: Int) {
        self.init()
        for i in 0 ..< 9 {
            switch (hashValue >> (i << 1)) & 0b11 {
            case 0:
                _marks[i] = .x
            case 1:
                _marks[i] = .o
            default:
                break
            }
        }
    }

    /// Creates a tic-tac-toe board from `marks`.
    public init<S: ExpressibleByUnicodeScalarLiteral & Equatable>(_ marks: [[S]]) {
        self.init()
        for y in marks.indices.prefix(3) {
            for x in marks[y].indices.prefix(3) {
                _marks[x + y * 3] = Mark(marks[y][x])
            }
        }
    }

    /// Creates a tic-tac-toe board from `emoji`.
    public init(emoji: String) {
        self.init()
        let split = emoji.unicodeScalars.split(separator: "\n")
        for (y, part) in split.prefix(3).enumerated() {
            for (x, scalar) in part.prefix(3).enumerated() {
                _marks[x + y * 3] = Mark(emoji: scalar)
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
    public subscript(x: Int, y: Int) -> Mark? {
        get {
            return Square(x: x, y: y).flatMap { self[$0] }
        }
        set {
            guard let square = Square(x: x, y: y) else {
                return
            }
            self[square] = newValue
        }
    }

    /// Returns a string representation of `self` as with scalars to represent different marks.
    public func string(x: UnicodeScalar, o: UnicodeScalar, none: UnicodeScalar, padding: Int = 0) -> String {
        var result = String.UnicodeScalarView()
        for i in (0 ..< 3) {
            for j in (0 ..< 3) {
                if let mark = _marks[j + i * 3] {
                    switch mark {
                    case .x: result.append(x)
                    case .o: result.append(o)
                    }
                } else {
                    result.append(none)
                }
                if padding > 0 && j != 2 {
                    for _ in 0 ..< padding {
                        result.append(" ")
                    }
                }
            }
            if i < 2 {
                result.append("\n")
            }
        }
        return String(result)
    }

    /// Returns `true` if `self` has a mark at `square`.
    public func hasMark(at square: Square) -> Bool {
        return self[square] != nil
    }

    /// Returns `true` if `self` has a mark at any of `squares`.
    public func hasMark<S: Sequence>(atAnyOf squares: S) -> Bool where S.Iterator.Element == Square {
        return squares.contains(where: { hasMark(at: $0) })
    }

    /// Returns `self` rotated left by `count`.
    public func rotatedLeft<I: ExpressibleByIntegerLiteral & IntegerArithmetic>(by count: I) -> Board {
        switch count {
        case 0:
            return self
        case 1:
            return Board(_marks: [_marks[2], _marks[5], _marks[8],
                                  _marks[1], _marks[4], _marks[7],
                                  _marks[0], _marks[3], _marks[6]])
        case 2:
            return Board(_marks: [_marks[8], _marks[7], _marks[6],
                                  _marks[5], _marks[4], _marks[3],
                                  _marks[2], _marks[1], _marks[0]])
        case 3:
            return Board(_marks: [_marks[6], _marks[3], _marks[0],
                                  _marks[7], _marks[4], _marks[1],
                                  _marks[8], _marks[5], _marks[2]])
        default:
            let newCount = count % 4
            return rotatedLeft(by: (newCount < 0) ? 4 + newCount : newCount)
        }
    }

    /// Rotates `self` left by `count`.
    public mutating func rotateLeft<I: ExpressibleByIntegerLiteral & IntegerArithmetic>(by count: I) {
        self = rotatedLeft(by: count)
    }

    /// Returns `self` rotated right by `count`.
    public func rotatedRight<I: ExpressibleByIntegerLiteral & IntegerArithmetic>(by count: I) -> Board {
        switch count {
        case 0:
            return self
        case 1:
            return Board(_marks: [_marks[6], _marks[3], _marks[0],
                                  _marks[7], _marks[4], _marks[1],
                                  _marks[8], _marks[5], _marks[2]])
        case 2:
            return Board(_marks: [_marks[8], _marks[7], _marks[6],
                                  _marks[5], _marks[4], _marks[3],
                                  _marks[2], _marks[1], _marks[0]])
        case 3:
            return Board(_marks: [_marks[2], _marks[5], _marks[8],
                                  _marks[1], _marks[4], _marks[7],
                                  _marks[0], _marks[3], _marks[6]])
        default:
            let newCount = count % 4
            return rotatedRight(by: (newCount < 0) ? 4 + newCount : newCount)
        }
    }

    /// Rotates `self` right by `count`.
    public mutating func rotateRight<I: ExpressibleByIntegerLiteral & IntegerArithmetic>(by count: I) {
        self = rotatedRight(by: count)
    }

    /// Returns `self` flipped horizontally.
    public func flippedHorizontally() -> Board {
        var copy = self
        copy.flipHorizontally()
        return copy
    }

    /// Flips `self` horizontally.
    public mutating func flipHorizontally() {
        for i in 0 ..< 3 {
            let a = i * 3
            let b = a + 2
            swap(&_marks[a], &_marks[b])
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
        for i in 0 ..< 3 {
            swap(&_marks[i], &_marks[i + 6])
        }
    }

    /// Flips `self` horizontally and vertically.
    public mutating func flipHorizontallyAndVertically() {
        for i in 0 ..< 4 {
            swap(&_marks[i], &_marks[8 - i])
        }
    }

    /// Returns `self` flipped horizontally and vertically.
    public func flippedHorizontallyAndVertically() -> Board {
        var copy = self
        copy.flipHorizontallyAndVertically()
        return copy
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

    /// Returns the next boards of `self` marked with `mark`.
    public func nextBoards(markedWith mark: Mark) -> LazyMapBidirectionalCollection<LazyFilterBidirectionalCollection<[Square]>, Board> {
        return emptySquares.map { square in
            var copy = self
            copy[square] = mark
            return copy
        }
    }

    /// Returns the next boards of `self` marked with `mark` as well as the marked square.
    public func nextBoardsWithSquare(markedWith mark: Mark) -> LazyMapBidirectionalCollection<LazyFilterBidirectionalCollection<[Square]>, (Board, Square)> {
        return emptySquares.map { square in
            var copy = self
            copy[square] = mark
            return (copy, square)
        }
    }

    /// Returns the next available boards of `self` marked with `mark`.
    public func nextAvailableBoards(markedWith mark: Mark) -> LazyMapBidirectionalCollection<LazyFilterBidirectionalCollection<[Square]>, Board>? {
        return availableSquares?.map { square in
            var copy = self
            copy[square] = mark
            return copy
        }
    }

    /// Returns the next available boards of `self` marked with `mark` as well as the marked square.
    public func nextAvailableBoardsWithSquare(markedWith mark: Mark) -> LazyMapBidirectionalCollection<LazyFilterBidirectionalCollection<[Square]>, (Board, Square)>? {
        return availableSquares?.map { square in
            var copy = self
            copy[square] = mark
            return (copy, square)
        }
    }

}
