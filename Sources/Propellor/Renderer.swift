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
        Termbox.setCursor(x: 2, y: 10)
        Termbox.outputMode = .trueColor
    }


    func beginDraw () {
        Log.info("beginDraw")
        clear()
    }

    func clear () {
        Log.info("clear")
        Termbox.clear()
    }

    func endDraw () {
        Log.info("endDraw")
        Termbox.present()
    }

    public func shutdown() {
        Termbox.shutdown()
    }
}
