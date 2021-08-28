import LoggerAPI
import Termbox

public struct TermColor {
    public var red: UInt8
    public var blue: UInt8
    public var green: UInt8
    public var bold: Bool

    public init (red: UInt8, green: UInt8, blue: UInt8, bold: Bool = false) {
        self.red = red
        self.green = green
        self.blue = blue
        self.bold = bold
    }

    public init? (hex input: String, bold: Bool = false) {
        var hex = input
        if hex.count == 6 {
            hex += "00"
        }
        if hex.count != 8 {
            Log.warning("Invalid hex color input \(hex)")
            return nil
        }
        guard let rgb32 = UInt32(hex, radix: 16) else {
            Log.warning("Invalid hex color input \(hex)")
            return nil
        }
        self.red = UInt8((rgb32 & 0xFF000000) >> 24)
        self.green = UInt8((rgb32 & 0x00FF0000) >> 16)
        self.blue = UInt8((rgb32 & 0x0000FF00) >> 8)
        self.bold = bold
    }

    var tbColor: Attributes {
        var rgb32 = UInt32(red) << 16 | UInt32(green) << 8 | UInt32(blue)
        if bold {
            rgb32 |= Attributes.bold.rawValue
        }
        return Attributes(rawValue: rgb32)
    }

    static var `default`: Attributes {
        return Attributes.default
    }
}
