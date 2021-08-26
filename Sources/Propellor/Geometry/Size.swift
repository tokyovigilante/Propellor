public struct Size {

    public var width: Int
    public var height: Int

    var zero: Bool {
        return width == 0 || height == 0
    }
}

extension Size: Equatable {}
