//
//  Mark.swift
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

/// A tic-tac-toe mark.
public enum Mark: Character, CustomStringConvertible {

    /// X mark.
    case x = "x"

    /// O mark.
    case o = "o"

    /// A textual representation of this instance.
    public var description: String {
        return String(rawValue)
    }

    /// Creates a mark from a scalar.
    public init?(_ scalar: UnicodeScalar) {
        switch scalar {
        case "X", "x": self = .x
        case "O", "o": self = .o
        default: return nil
        }
    }

    /// Creates a mark from a character.
    public init?(_ character: Character) {
        switch character {
        case "X", "x": self = .x
        case "O", "o": self = .o
        default: return nil
        }
    }

    /// Creates a mark from a string.
    public init?(_ string: String) {
        switch string {
        case "X", "x": self = .x
        case "O", "o": self = .o
        default: return nil
        }
    }

    /// Returns the inverse mark of `self`.
    public func inverse() -> Mark {
        switch self {
        case .x: return .o
        case .o: return .x
        }
    }

    /// Inverts the mark of `self`.
    public mutating func invert() {
        self = inverse()
    }

}
