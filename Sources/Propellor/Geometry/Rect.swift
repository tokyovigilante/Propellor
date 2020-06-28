public struct Rect {

    public var origin: Point
    public var size: Size

    public var x: Int {
        get {
            return origin.x
        }
        set {
            if origin.x != newValue {
                origin.x = newValue
            }
        }
    }
    public var y: Int {
        get {
            return origin.y
        }
        set {
            if origin.y != newValue {
                origin.y = newValue
            }
        }
    }
    public var width: Int {
        get {
            return size.width
        }
        set {
            if size.width != newValue {
                size.width = newValue
            }
        }
    }
    public var height: Int {
        get {
            return size.height
        }
        set {
            if size.height != newValue {
                size.height = newValue
            }
        }
    }

    public var endX: Int {
        return origin.x + size.width
    }

    public var endY: Int {
        return origin.y + size.height
    }

    var zero: Bool {
        return width == 0 || height == 0
    }

    public init (x: Int, y: Int, width: Int, height: Int) {
        self.origin = Point(x: x, y: y)
        self.size = Size(width: width, height: height)
    }

    public init (origin: Point, size: Size) {
        self.origin = origin
        self.size = size
    }

    func offset (by point: Point) -> Rect {
        return Rect(origin: Point(x: self.x + point.x, y: self.y + point.y), size: self.size)
    }

}

extension Rect: Equatable {}
