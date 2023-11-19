import Termbox

struct ShapeView<S: Shape>: BuiltinView, View {

    var shape: S

    func render (context: Termbox, size: ProposedSize) {
        //context.saveGState()
        //context.setFillColor(NSColor.red.cgColor)
        //context.addPath(shape.path(in: CGRect(origin: .zero, size: size)))
        //context.fillPath()
        //context.restoreGState()
    }

}

protocol Shape {

    func path(in rect: Rect)

}
