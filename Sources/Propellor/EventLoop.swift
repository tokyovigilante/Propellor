import Foundation
import LoggerAPI
import Termbox

class EventLoop {

    var handleEvent: ((Event) -> Void)? = nil

    private var _ttyDispatchSource: DispatchSourceRead? = nil
    private var _resizeDispatchSource: DispatchSourceRead? = nil

    func start () {
        if _ttyDispatchSource != nil || _resizeDispatchSource != nil {
            stop()
        }
        let fds = Termbox.getFDs()
        _ttyDispatchSource = DispatchSource.makeReadSource(fileDescriptor: fds.tty, queue: DispatchQueue.main)
        _resizeDispatchSource = DispatchSource.makeReadSource(fileDescriptor: fds.resize, queue: DispatchQueue.main)

        let eventHandler = DispatchWorkItem() {
            do {
                repeat {
                    let event = try Termbox.peekEvent(timeout: 0)
                    self.handleEvent?(event)
                } while true
            } catch let error as TermboxError {
                switch error {
                case .noEvent:
                    return
                default:
                    Log.error(error.description)
                }
            } catch let error {
                Log.error(error.localizedDescription)
            }
        }

        _ttyDispatchSource?.setEventHandler(handler: eventHandler)
        _resizeDispatchSource?.setEventHandler(handler: eventHandler)

        _ttyDispatchSource?.activate()
        _resizeDispatchSource?.activate()

        Log.debug("termbox: event handler activated")
    }

    func stop () {
        _ttyDispatchSource?.cancel()
        _resizeDispatchSource?.cancel()
        _ttyDispatchSource = nil
        _resizeDispatchSource = nil
    }
}
