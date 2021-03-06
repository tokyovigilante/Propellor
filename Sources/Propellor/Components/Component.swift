import Foundation
import Termbox

public protocol Component: class {

    var rect: Rect { get set }

    var isDirty: Bool { get }

    var theme: Theme { get set }

    var foreground: TermColor? { get set }

    var background: TermColor? { get set }

    func update (focused: Bool)

    func clear (row: Int, color: TermColor?)
}

internal protocol Responder {
    func handle (key: Key, modifier: Modifier) -> Bool

    func handle (character: UnicodeScalar, modifier: Modifier) -> Bool
}

internal extension Responder {

    func handle (key: Key, modifier: Modifier) -> Bool {
        return false
    }

    func handle (character: UnicodeScalar, modifier: Modifier) -> Bool {
        return false
    }
}

public extension Component {

    func clear (rows: Range<Int>, color: TermColor? = nil) {
        for row in rows {
            clear(row: row, color: color)
        }
    }

    func clear (row: Int, color: TermColor? = nil) {
        let foreground = self.foreground ?? theme.foregroundColor
        let background = color ?? self.background ?? theme.backgroundColor

        Termbox.puts(
            x: Int32(rect.x),
            y: Int32(rect.y+row),
            string: String(repeating: " ", count: rect.width),
            foreground: foreground.tbColor,
            background: background.tbColor
        )
    }

}
