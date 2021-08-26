import Foundation
import Termbox
import LoggerAPI

public class Renderer {

    public var width: Int {
        return Int(Termbox.width)
    }

    public var height: Int {
        return Int(Termbox.height)
    }

    init () throws {
        try Termbox.initialize()
        Termbox.outputMode = .trueColor
    }


    func beginDraw () {
        clear()
    }

    func clear () {
        Termbox.clear()
    }

    func endDraw () {
        Termbox.present()
    }

    public func shutdown() {
        Termbox.shutdown()
    }
}
