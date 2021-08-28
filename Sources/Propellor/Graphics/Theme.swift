import Foundation

public struct Theme {

    let foreground: TermColor
    let background: TermColor
    let focusedForeground: TermColor
    let focusedBackground: TermColor
    let selectedForeground: TermColor
    let selectedBackground: TermColor

    public static var `default`: Theme {
        return Theme(
            foreground: TermColor(hex: "2E3440")!,
            background: TermColor(hex: "ECEFF4")!,
            focusedForeground: TermColor(hex: "2E3440")!,
            focusedBackground: TermColor(hex: "88C0D0")!,
            selectedForeground: TermColor(hex: "2E3440")!,
            selectedBackground: TermColor(hex: "D8DEE9")!
        )
    }
}

