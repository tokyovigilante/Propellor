import Foundation
import Harness
import LoggerAPI
import Termbox

public protocol TextViewDataSource {

    var lineCount: Int { get }

    func lines (range: Range<Int>) -> [Label]?
}

public class TextView: Component {

    public var rect: Rect {
        didSet {
            if oldValue != rect {
                isDirty = true
            }
        }
    }

    public var dataSource: TextViewDataSource? = nil {
        didSet {
            isDirty = true
        }
    }

    private var _offset = 0

    public var theme: Theme {
        didSet {
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

    private (set) public var isDirty: Bool

    public init (rect: Rect, theme: Theme, truncate: Bool = true) {
        self.rect = rect
        self.theme = theme
        self.truncate = truncate
        isDirty = true
    }

    public func triggerUpdate () {
        isDirty = true
    }

    public func scrollUp () {
        if _offset > 0 {
            _offset -= 1
        }
    }

    public func scrollDown () {
        guard let dataSource = dataSource else {
            return
        }
        if _offset < dataSource.lineCount {
            _offset += 1
        }
    }

    public func pageUp () {

    }

    public func pageDown () {

    }

    public func update (focused: Bool = false) {
        if !isDirty || rect.zero {
            return
        }
        defer {
            isDirty = false
        }

        clear(rows: 0..<rect.height)

        guard let dataSource = dataSource,
                let visibleRows = visibleRows(dataSource: dataSource) else {
            return
        }
        Log.verbose("\(String(describing: visibleRows))")
/*        var displayText = text.firstParagraph.stripEmoji()
        if truncate {
            displayText = displayText.truncate(rect.width)
        } else {
            displayText = String(displayText.prefix(rect.width))
        }
        Termbox.puts(x: Int32(rect.x), y: Int32(rect.y), string: displayText,
            foreground: foreground?.tbColor ?? theme.foregroundColor.tbColor,
            background: background?.tbColor ?? theme.backgroundColor.tbColor)


        guard let dataSource = dataSource, let visibleRows = visibleRows(dataSource: dataSource) else {
            return
        }
        let rowHeight = dataSource.rowHeight
        let columnCount = dataSource.columnCount

        for row in 0..<visibleRows.count {
            for column in 0..<columnCount {
                var columnWidth = dataSource.columnWidth(for: column)
                if columnWidth == 0 {
                    columnWidth = rect.width / columnCount
                }
                guard let data = dataSource.data(row: row + _offset, column: column) else {
                    Log.verbose("No table data for (\(column),\(row))")
                    clear(rows: row*rowHeight..<(row+row)*rowHeight)
                    continue
                }
                for (i, label) in data.enumerated() {
                    let rowLineOffset = row * rowHeight + i
                    if rowLineOffset >= rect.height {
                        break
                    }
                    if row + _offset == currentRow {
                        let foreground = focused ? theme.focusedForegroundColor : theme.selectedForegroundColor
                        let background = focused ? theme.focusedBackgroundColor : theme.selectedBackgroundColor

                        clear(row: rowLineOffset, color: background)
                        label.foreground = foreground
                        label.background = background
                    }
                    let labelOffset = Point(x: rect.x + 1, y: rect.y + rowLineOffset)
                    label.rect = label.rect.offset(by: labelOffset)
                    label.rect.width -= 2
                    label.update()
                }
            }
        }*/

    }

    private func visibleRows (dataSource: TextViewDataSource) -> Range<Int>? {
        var availableRows = dataSource.lineCount
        let firstRow = _offset
        if firstRow > availableRows {
            return nil
        }
        availableRows -= firstRow
        let lastRow = firstRow + min(rect.height, availableRows)
        return firstRow..<lastRow
    }
/*
    private func visibleRows () -> Range<Int>? {
        guard let dataSource = dataSource else {
            return nil
        }
        var maxVisibleRows = rect.height
        var availableRows = dataSource.lineCount
        let firstRow = _offset
        if firstRow > availableRows {
            return nil
        }
        availableRows -= firstRow
        let lastRow = firstRow + min(maxVisibleRows, availableRows)
        return firstRow..<lastRow
    }*/

    private func clear (rows: Range<Int>, color: TermColor? = nil) {
        for row in rows {
            clear(row: row, color: color)
        }
    }
}
