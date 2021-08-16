import Foundation
import Termbox
import LoggerAPI

public class Propellor {

    public var height: Int {
        return _renderer.height
    }

    public var width: Int {
        return _renderer.width
    }

    public var focusedComponent: Component? = nil

    public var onResize: ((Size) -> Void)? = nil

    public var onEvent: ((Bool) -> Void)? = nil

    private let _eventLoop: EventLoop
    private let _renderer: Renderer

    public init () throws {
        try _renderer = Renderer()
        _eventLoop = EventLoop()
        _eventLoop.handleEvent = handle
    }

    public func run () {
        _eventLoop.start()
    }

    public func draw (components: [Component]) {
        assert(Thread.isMainThread, "Drawing must be done on main thread")
        _renderer.beginDraw()
        for component in components {
            component.update(focused: focusedComponent === component)
        }
        _renderer.endDraw()
    }

    public func shutdown() {
        Termbox.shutdown()
    }

    private func handle (event: Event) {

        Log.debug("\(String(describing: event))")
        switch event {
        case let .key(modifier, value):
            handle(key: value, modifier: modifier)
        case let .character(modifier, value):
            handle(character: value, modifier: modifier)
        case let .resize(width, height):
            handle(resize: (Int(width), Int(height)))
  /*      case let .mouse(x, y, event):

        case let .other(type):

        case timeout:*/
        default:
            Log.warning("Unhandled event \(String(reflecting: event))")
        }
        onEvent?(true)
    }

    private func handle (key: Key, modifier: Modifier) {
        if let component = focusedComponent as? Responder {
            if component.handle(key: key, modifier: modifier) {
                return
            }
        }
        switch key {
        default:
            return
        }
    }

    private func handle (character: UnicodeScalar, modifier: Modifier) {
        if let component = focusedComponent as? Responder {
            if component.handle(character: character, modifier: modifier) {
                return
            }
        }
        switch character {
        case "q":
            shutdown()
            exit(0)
        default:
            return
        }
    }

    private func handle (resize: (width: Int, height: Int)) {
        Log.verbose("Screen resized to \(resize.width)x\(resize.height)")
        onResize?(Size(width: width, height: height))
    }
}
