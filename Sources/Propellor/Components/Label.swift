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

    public var theme: Theme {
        didSet {
            foreground = nil
            background = nil
            isDirty = true
        }
    }

    public var foreground: TermColor? {
        didSet {
            if let oldValue = oldValue, oldValue.bold {
                self.bold = true
            }
            isDirty = true
        }
    }

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

    public var bold: Bool {
        get {
            return foreground?.bold ?? theme.foregroundColor.bold
        }
        set {
            if foreground == nil {
                foreground = theme.foregroundColor
            }
            foreground!.bold = newValue
        }
    }

    public init (rect: Rect, text: String, theme: Theme, truncate: Bool = true) {
        self.rect = rect
        self.text = text
        self.theme = theme
        self.truncate = truncate
        isDirty = true
    }

    public func update (focused: Bool = false) {
        if !isDirty || rect.zero {
            return
        }
        var displayText = text.firstParagraph.stripEmoji()
        if truncate {
            displayText = displayText.truncate(rect.width)
        } else {
            displayText = String(displayText.prefix(rect.width))
        }
        let clearWidth = rect.width - displayText.count
        displayText += String(repeating: " ", count: clearWidth)
        Log.info("Rendering \(displayText) at \(rect.x),\(rect.y)")
        for char in displayText.unicodeScalars {
            Log.info("\(char.value)")
        }
        Termbox.write(
            string: displayText, x: rect.x, y: rect.y,
            foreground: foreground?.tbColor ?? theme.foregroundColor.tbColor,
            background: background?.tbColor ?? theme.backgroundColor.tbColor)
        isDirty = false
    }
}
