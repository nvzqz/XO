# XO

XO is a cross-platform tic-tac-toe library for Swift.

## Features

[x] Tic-tac-toe game management
[x] Tic-tac-toe board structuring
[x] Square availability
[x] Marking validation

## Installation

### Compatibility

- Platforms:
    - macOS 10.9+
    - iOS 8.0+
    - watchOS 2.0+
    - tvOS 9.0+
    - Linux
    - Any other platform where Swift is available
- Xcode 8.0
- Swift 3.0

### Install Using Swift Package Manager
The [Swift Package Manager](https://swift.org/package-manager/) is a
decentralized dependency manager for Swift.

1. Add the project to your `Package.swift`.

    ```swift
    import PackageDescription

    let package = Package(
        name: "MyAwesomeProject",
        dependencies: [
            .Package(url: "https://github.com/nvzqz/XO.git",
                     majorVersion: 1)
        ]
    )
    ```

2. Import the XO module.

    ```swift
    import XO
    ```

### Install Using CocoaPods
[CocoaPods](https://cocoapods.org/) is a centralized dependency manager for
Objective-C and Swift. Go [here](https://guides.cocoapods.org/using/index.html)
to learn more.

1. Add the project to your [Podfile](https://guides.cocoapods.org/using/the-podfile.html).

    ```ruby
    use_frameworks!

    pod 'XO', '~> 1.0.0'
    ```

    If you want to be on the bleeding edge, replace the last line with:

    ```ruby
    pod 'XO', :git => 'https://github.com/nvzqz/XO.git'
    ```

2. Run `pod install` and open the `.xcworkspace` file to launch Xcode.

3. Import the XO framework.

    ```swift
    import XO
    ```

### Install Using Carthage
[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency
manager for Objective-C and Swift.

1. Add the project to your [Cartfile](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile).

    ```
    github "nvzqz/XO"
    ```

2. Run `carthage update` and follow [the additional steps](https://github.com/Carthage/Carthage#getting-started)
   in order to add XO to your project.

3. Import the XO framework.

    ```swift
    import XO
    ```

## Usage

### Game Management

Running a tic-tac-toe game can be as simple as setting up a loop.

```swift
import XO

let game = Game()

while !game.board.isFinished {
    let square = ...
    try game.applyMark(to: square)
}
```

### Board Marking

Marks can be applied in a `Game` instance starting with `Mark.x` using
`applyMark(to:)` and its unsafe (yet faster) sibling, `applyUncheckedMark(to:)`.

The mark then switches repeatedly until the game is finished.

### Square Availability

The available squares can be retrieved using `availableSquares` on a `Board`.

```swift
while let marks = game.board.availableSquares {
    ...
}
```

### Board Initialization

A board can be created from a two dimensional `UnicodeScalar` array.

```swift
let board: Board = [["x", " ", "o"],
                    [" ", " ", "x"],
                    ["x", " ", "o"]]
```

A board can also be created from a hash value. Hash values do not change across
processes.

```swift
let other = Board(hashValue: board.hashValue)

other == board  // true
```

### Board Transformations

#### Board Flipping

The `flippedHorizontally()` method returns the board with its left side swapped with its right side.

The `flippedVertically()` method returns the board with its top side swapped with its bottom side.

There is also `flippedHorizontallyAndVertically()` which efficiently produces the same result
as calling both `flippedHorizontally()` and `flippedVertically()`.

#### Board Rotating

The `rotatedLeft(by:)` and `rotatedRight(by:)` will return the result of rotating the board left or
right `count` times.

The parameter can be of any type conforming to `ExpressibleByIntegerLiteral` and `IntegerArithmetic`.

### Pretty Printing

```swift
print(board.ascii)
x  .  o
.  .  x
x  .  o

print(board.emoji)
❌⬜⭕
⬜⬜❌
❌⬜⭕
```
