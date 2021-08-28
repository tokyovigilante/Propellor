import Foundation
import Termbox
import LoggerAPI

public class Line: Component {

    public var rect: Rect {
        didSet {
            isDirty = true
        }
    }

    private (set) public var isDirty: Bool

    public var foreground: TermColor? = nil {
        didSet {
            isDirty = true
        }
    }

    public var background: TermColor? = nil {
        didSet {
            isDirty = true
        }
    }

    public init (rect: Rect = Rect()) {
        self.rect = rect
        isDirty = true
    }

    public func update (theme: Theme, focused: Bool, forced: Bool) {
        if forced {
            isDirty = true
        }
        if !isDirty || rect.zero {
            return
        }
        defer {
            isDirty = false
        }
        let horizontal = rect.width > rect.height
        if horizontal {
            let line = String(repeating: "─", count: rect.width)
            Termbox.write(string: line, x: rect.x, y: rect.y,
                foreground: foreground?.tbColor ?? theme.foreground.tbColor,
                background: background?.tbColor ?? theme.background.tbColor)
        } else {
            let line: UnicodeScalar = "│"
            for y in rect.y..<rect.endY {
                Termbox.putc(x: rect.x, y: y, char: line,
                    foreground: foreground?.tbColor ?? theme.foreground.tbColor,
                    background: background?.tbColor ?? theme.background.tbColor)
            }

        }
    }


}
