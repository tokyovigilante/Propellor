import Foundation
import Harness
import LoggerAPI
import Termbox

public class Label: Component {

    public var rect: Rect {
        didSet {
            isDirty = true
        }
    }

    private (set) public var isDirty: Bool

    public var text: String {
        didSet {
            isDirty = true
        }
    }

    public var foreground: TermColor?

    public var background: TermColor? {
        didSet {
            isDirty = true
        }
    }

    public var truncate: Bool {
        didSet {
            isDirty = true
        }
    }

    public var bold: Bool = false

    public init (rect: Rect = Rect(), text: String = "", truncate: Bool = true) {
        self.rect = rect
        self.text = text
        self.truncate = truncate
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
        var displayText = text.firstParagraph.stripEmoji()
        if truncate {
            displayText = displayText.truncate(rect.width)
        } else {
            displayText = String(displayText.prefix(rect.width))
        }
        let clearWidth = rect.width - displayText.count
        displayText += String(repeating: " ", count: clearWidth)
        var foreground = foreground ?? theme.foreground
        foreground.bold = bold
        Termbox.write(
            string: displayText, x: rect.x, y: rect.y,
            foreground: foreground.tbColor,
            background: background?.tbColor ?? theme.background.tbColor)
    }
}
