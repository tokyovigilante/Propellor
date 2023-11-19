import Termbox

protocol BuiltinView {

    func render (context: Termbox, size: ProposedSize)

    typealias Body = Never

}

extension View where Body == Never {

    var body: Never { fatalError("This should never be called.") }

}

extension View {

    func render (context: Termbox, size: ProposedSize) {
        if let builtin = self as? BuiltinView {
            builtin.render(context: context, size: size)
        } else {
            body.render(context: context, size: size)
        }
    }

}

extension Never: View {

    typealias Body = Never

}
