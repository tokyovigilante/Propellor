import Foundation

public struct Theme {

    let foregroundColor: TermColor
    let backgroundColor: TermColor
    let focusedForegroundColor: TermColor
    let focusedBackgroundColor: TermColor
    let selectedForegroundColor: TermColor
    let selectedBackgroundColor: TermColor

    public static var `default`: Theme {
        return Theme(
            foregroundColor: TermColor(hex: "2E3440")!,
            backgroundColor: TermColor(hex: "ECEFF4")!,
            focusedForegroundColor: TermColor(hex: "2E3440")!,
            focusedBackgroundColor: TermColor(hex: "88C0D0")!,
            selectedForegroundColor: TermColor(hex: "2E3440")!,
            selectedBackgroundColor: TermColor(hex: "D8DEE9")!
        )
    }
}

