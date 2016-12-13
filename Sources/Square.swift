//
//  Square.swift
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

/// A square on a tic-tac-toe board.
public enum Square: Int, CustomStringConvertible {

    /// Square at (0, 0).
    case aa

    /// Square at (1, 0).
    case ba

    /// Square at (2, 0).
    case ca

    /// Square at (0, 1).
    case ab

    /// Square at (1, 1).
    case bb

    /// Square at (2, 1).
    case cb

    /// Square at (0, 2).
    case ac

    /// Square at (1, 2).
    case bc

    /// Square at (2, 2).
    case cc

    /// All squares.
    public static let all = [aa, ba, ca, ab, bb, cb, ac, bc, cc]

    /// Corner squares.
    public static let corners = [aa, ca, ac, cc]

    /// Edge squares.
    public static let edges = [ba, ab, cb, bc]

    /// The x index value of `self`.
    public var x: Int {
        return hashValue % 3
    }

    /// The y index value of `self`.
    public var y: Int {
        return hashValue / 3
    }

    /// Whether `self` is a corner square.
    public var isCorner: Bool {
        return x != 1 && y != 1
    }

    /// Whether `self` is the center square.
    public var isCenter: Bool {
        return self == .bb
    }

    /// Whether `self` is an edge square.
    public var isEdge: Bool {
        return (x == 1) != (y == 1)
    }

    /// A textual representation of this instance.
    public var description: String {
        let letters = ["a", "b", "c"]
        return letters[x] + letters[y]
    }

    /// Creates a square from `x` and `y` indices.
    public init?<X: IntegerArithmetic & ExpressibleByIntegerLiteral,
                 Y: IntegerArithmetic & ExpressibleByIntegerLiteral>(x: X, y: Y) {
        guard 0 ..< 3 ~= x && 0 ..< 3 ~= y else {
            return nil
        }
        self.init(rawValue: Int(x.toIntMax() + y.toIntMax() * 3))
    }

}
