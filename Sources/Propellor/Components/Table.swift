import Foundation
import LoggerAPI
import Termbox

public class Table: Component, Responder {

    public let uuid = UUID()

    public var dataSource: TableDataSource? = nil {
        didSet {
            currentRow = 0
            isDirty = true
        }
    }

    public var delegate: TableDelegate? = nil

    private var _offset = 0 {
        didSet {
            isDirty = true
        }
    }

    private (set) public var currentRow = 0 {
        didSet {
            delegate?.didSelect(row: currentRow, in: name)
            isDirty = true
        }
    }

    public var rect: Rect {
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

    private (set) public var isDirty: Bool

    public let name: String

    public init (rect: Rect = Rect(), name: String) {
        self.rect = rect
        self.name = name
        isDirty = true
    }

    public func select (row: Int) {
        if row == currentRow {
            return
        }
        currentRow = row
        isDirty = true
    }

    public func scrollUp () {
        if currentRow == 0 {
            return
        }
        if currentRow - _offset == 0 && _offset > 0 {
            _offset -= 1
        }
        currentRow -= 1
    }

    public func scrollDown () {
        guard let dataSource = dataSource else {
            return
        }
        if currentRow >= dataSource.rowCount(for: 0, in: name) - 1 {
            return
        }
        if currentRow - _offset >= maxEntirelyVisibleRowCount(rowHeight: dataSource.rowHeight(in: name)) - 1 {
            _offset += 1
        }
        currentRow += 1

    }

    public func pageUp () {

    }

    public func pageDown () {

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

        clear(rows: 0..<rect.height)

        guard let dataSource = dataSource, let visibleRows = visibleRows(dataSource: dataSource) else {
            return
        }
        let rowHeight = dataSource.rowHeight(in: name)
        let columnCount = dataSource.columnCount(in: name)
        for row in 0..<visibleRows.count {
            for column in 0..<columnCount {
                var columnWidth = dataSource.columnWidth(for: column, in: name)
                if columnWidth == 0 {
                    columnWidth = rect.width / columnCount
                }
                guard let data = dataSource.data(row: row + _offset, column: column, section: 0, in: name) else {
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
                        let foreground = focused ? theme.focusedForeground : theme.selectedForeground
                        let background = focused ? theme.focusedBackground : theme.selectedBackground

                        clear(row: rowLineOffset, color: background)
                        label.foreground = foreground
                        label.background = background
                    }
                    let labelOffset = Point(x: rect.x + 1, y: rect.y + rowLineOffset)
                    label.rect = label.rect.offset(by: labelOffset)
                    label.rect.width = columnWidth - 2
                    label.rect.height = 1
                    label.update(theme: theme, focused: focused, forced: forced)
                }
            }
        }
    }

    func handle (key: Key, modifier: Modifier) -> Bool {
        switch key {
        case .arrowUp:
            scrollUp()
        case .arrowDown:
            scrollDown()
        default:
            Log.debug("Component \(uuid): unhandled key \(key), modifier \(modifier)")
            return false
        }
        return true
    }

    func handle (character: UnicodeScalar, modifier: Modifier) -> Bool {
        switch character {
        default:
            Log.debug("Component \(uuid): unhandled character \(character), modifier \(modifier)")
            return false
        }
    }

    private func visibleRows (dataSource: TableDataSource) -> Range<Int>? {
        var availableRows = dataSource.rowCount(for: 0, in: name)
        let firstRow = _offset
        if firstRow > availableRows {
            return nil
        }
        availableRows -= firstRow
        let lastRow = firstRow + min(maxVisibleRowCount(rowHeight: dataSource.rowHeight(in: name)), availableRows)
        return firstRow..<lastRow
    }

    private func maxEntirelyVisibleRowCount (rowHeight: Int) -> Int {
        return rect.height / rowHeight

    }

    private func maxVisibleRowCount (rowHeight: Int) -> Int {
        var maxVisibleRowCount = maxEntirelyVisibleRowCount(rowHeight: rowHeight)
        if rect.height % rowHeight != 0 {
            maxVisibleRowCount += 1
        }
        return maxVisibleRowCount
    }

}


public protocol TableDataSource {

    func sectionCount (in table: String) -> Int
    func rowCount (for section: Int, in table: String) -> Int

    func columnCount (in table: String) -> Int

    func rowHeight(in table: String) -> Int

    func columnWidth (for column: Int, in table: String) -> Int

    func data (row: Int, column: Int, section: Int, in table: String) -> [Label]?
}

public protocol TableDelegate {

    func didSelect (row: Int, in table: String)
}
