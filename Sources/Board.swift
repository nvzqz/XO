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
public struct Board: Equatable, Hashable {

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

}
