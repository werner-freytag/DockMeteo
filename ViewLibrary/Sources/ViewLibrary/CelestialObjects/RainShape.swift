import SwiftUI

public struct RainShape: Shape {
    public static let originalSize = CGSize(width: 26, height: 9)

    public init() {}

    public func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: 4, y: 1))
        path.addLine(to: CGPoint(x: 0, y: 8))

        path.move(to: CGPoint(x: 9, y: 0))
        path.addLine(to: CGPoint(x: 5, y: 7))

        path.move(to: CGPoint(x: 13, y: 1))
        path.addLine(to: CGPoint(x: 9, y: 8))

        path.move(to: CGPoint(x: 21, y: 1))
        path.addLine(to: CGPoint(x: 17, y: 8))

        path.move(to: CGPoint(x: 17.414, y: 0.026))
        path.addLine(to: CGPoint(x: 14, y: 6))

        path.move(to: CGPoint(x: 25.326, y: 0.18))
        path.addLine(to: CGPoint(x: 22, y: 6))

        return path.applying(.init(scaleX: rect.width / Self.originalSize.width, y: rect.height / Self.originalSize.height))
    }
}

struct RainShape_Previews: PreviewProvider {
    static var previews: some View {
        RainShape()
            .stroke(Color(red: 0, green: 0.2, blue: 0.5).opacity(0.2), style: StrokeStyle(lineWidth: 1.0, lineCap: .round))
            .frame(width: 26, height: 9)
            .padding()
    }
}
