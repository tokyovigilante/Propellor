import Foundation
import LoggerAPI
import Termbox

class EventLoop {

    var handleEvent: ((Event) -> Void)? = nil

    private var _running = false

    private let _eventQueue: DispatchQueue

    init () {
        _eventQueue = DispatchQueue(label: "com.testtoast.spitfire.terminalevents")
    }

    func start () {
        _running = true
        _eventQueue.async {
            while self._running {
                let event = Termbox.peekEvent(timeout: 100)
                if event == .timeout {
                    continue
                }
                DispatchQueue.main.async {
                    self.handleEvent?(event)
                }
            }
        }
    }

    func stop () {
        _running = false
    }
}
