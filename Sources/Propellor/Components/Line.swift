import Foundation
import Termbox

public class Line: Component {

    public var rect: Rect

    private (set) public var isDirty: Bool

    public var theme: Theme {
        didSet {
            isDirty = true
        }
    }

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

    public init (rect: Rect, theme: Theme) {
        self.rect = rect
        self.theme = theme
        isDirty = true
    }

    public func update (focused: Bool = false) {
        if !isDirty {
            return
        }
        let horizontal = rect.width > rect.height
        if horizontal {
            let line = String(repeating: "─", count: rect.width)
            Termbox.write(string: line, x: rect.x, y: rect.y,
                foreground: foreground?.tbColor ?? theme.foregroundColor.tbColor,
                background: background?.tbColor ?? theme.backgroundColor.tbColor)
        } else {
            let line: UnicodeScalar = "│"
            for y in rect.y..<rect.endY {
                Termbox.putc(x: rect.x, y: y, char: line,
                    foreground: foreground?.tbColor ?? theme.foregroundColor.tbColor,
                    background: background?.tbColor ?? theme.backgroundColor.tbColor)
            }

        }
    }


}
