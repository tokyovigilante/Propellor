import Termbox

typealias ProposedSize = Size

protocol View {

    associatedtype Body: View
    var body: Body { get }

    func render (context: Termbox, size: ProposedSize)

}
