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

    public var theme: Theme = .default

    public var focusedComponent: Component? = nil

    public var onResize: ((Size) -> Void)? = nil

    public var onEvent: ((Bool) -> Void)? = nil

    public var onCharacter: ((UnicodeScalar, Modifier) -> Void)? = nil

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

    public func draw (components: [Component], forceUpdate forced: Bool = false) {
        dispatchPrecondition(condition: .onQueue(.main))
        _renderer.beginDraw()
        for component in components {
            component.update(theme: theme, focused: focusedComponent === component, forced: forced)
        }
        _renderer.endDraw()
    }

    public func shutdown() {
        Termbox.shutdown()
    }

    private func handle (event: Event) {
        Log.debug("\(String(describing: event))")
        var handled = false
        switch event {
        case let .key(modifier, value):
            handled = handle(key: value, modifier: modifier)
        case let .character(modifier, value):
            handled = handle(character: value, modifier: modifier)
            if !handled {
                onCharacter?(value, modifier)
            }
        case let .resize(width, height):
            handle(resize: (Int(width), Int(height)))
            handled = true
  /*      case let .mouse(x, y, event):

        case let .other(type):

        case timeout:*/
        default:
            Log.warning("Unhandled event \(String(reflecting: event))")
        }
        onEvent?(handled)
    }

    private func handle (key: Key, modifier: Modifier) -> Bool {
        if let component = focusedComponent as? Responder {
            if component.handle(key: key, modifier: modifier) {
                return true
            }
        }
        switch key {
        default:
            return false
        }
    }

    private func handle (character: UnicodeScalar, modifier: Modifier) -> Bool {
        if let component = focusedComponent as? Responder {
            if component.handle(character: character, modifier: modifier) {
                return true
            }
        }
        return false
    }

    private func handle (resize: (width: Int, height: Int)) {
        Log.verbose("Screen resized to \(resize.width)x\(resize.height)")
        onResize?(Size(width: resize.width, height: resize.height))
    }
}
