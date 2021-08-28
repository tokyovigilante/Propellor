import Foundation
import Termbox

public protocol Component: AnyObject {

    var rect: Rect { get set }

    var isDirty: Bool { get }

    var foreground: TermColor? { get set }

    var background: TermColor? { get set }

    func update (theme: Theme, focused: Bool, forced: Bool)

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
        let foreground = TermColor.default
        let background = color?.tbColor ?? self.background?.tbColor ?? TermColor.default

        Termbox.write(
            string: String(repeating: " ", count: rect.width),
            x: rect.x,
            y: rect.y+row,
            foreground: foreground,
            background: background
        )
    }

}
