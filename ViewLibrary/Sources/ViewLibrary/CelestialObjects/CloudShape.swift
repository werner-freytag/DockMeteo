import SwiftUI

public struct CloudShape: Shape {
    public static let originalSize = CGSize(width: 38, height: 24)

    public init() {}

    public func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: 6, y: 24))
        path.addCurve(to: CGPoint(x: 0, y: 16.5), control1: CGPoint(x: 2.6, y: 23.2), control2: CGPoint(x: 0, y: 20.1))
        path.addCurve(to: CGPoint(x: 5, y: 9.4), control1: CGPoint(x: 0, y: 13.2), control2: CGPoint(x: 2.1, y: 10.4))
        path.addCurve(to: CGPoint(x: 10.5, y: 4.5), control1: CGPoint(x: 5.3, y: 6.7), control2: CGPoint(x: 7.7, y: 4.5))
        path.addCurve(to: CGPoint(x: 13.2, y: 5.2), control1: CGPoint(x: 11.5, y: 4.5), control2: CGPoint(x: 12.4, y: 4.8))
        path.addCurve(to: CGPoint(x: 22, y: 0), control1: CGPoint(x: 14.9, y: 2.1), control2: CGPoint(x: 18.2, y: 0))
        path.addCurve(to: CGPoint(x: 32, y: 10), control1: CGPoint(x: 27.5, y: 0), control2: CGPoint(x: 32, y: 4.5))
        path.addCurve(to: CGPoint(x: 32, y: 10.1), control1: CGPoint(x: 32, y: 10), control2: CGPoint(x: 32, y: 10))
        path.addCurve(to: CGPoint(x: 38, y: 17), control1: CGPoint(x: 35.4, y: 10.6), control2: CGPoint(x: 38, y: 13.5))
        path.addCurve(to: CGPoint(x: 31, y: 24), control1: CGPoint(x: 38, y: 20.9), control2: CGPoint(x: 34.9, y: 24))

        return path.applying(.init(scaleX: rect.width / Self.originalSize.width, y: rect.height / Self.originalSize.height))
    }
}

struct CloudShape_Previews: PreviewProvider {
    static var previews: some View {
        CloudShape()
            .fill(Color.white)
            .frame(width: 38, height: 24)
            .padding()
            .shadow(radius: 8)
    }
}
