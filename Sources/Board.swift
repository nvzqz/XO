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
public struct Board {

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

}
