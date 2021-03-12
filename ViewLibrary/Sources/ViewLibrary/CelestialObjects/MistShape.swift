import SwiftUI

public struct MistShape: Shape {
    public static let originalSize = CGSize(width: 44, height: 29)

    public init() {}

    public func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: 0, y: 21))
        path.addLine(to: CGPoint(x: 15, y: 21))

        path.move(to: CGPoint(x: 5, y: 14))
        path.addLine(to: CGPoint(x: 27, y: 14))

        path.move(to: CGPoint(x: 10, y: 0))
        path.addLine(to: CGPoint(x: 32, y: 0))

        path.move(to: CGPoint(x: 0, y: 28))
        path.addLine(to: CGPoint(x: 13, y: 28))

        path.move(to: CGPoint(x: 0, y: 7))
        path.addLine(to: CGPoint(x: 20, y: 7))

        path.move(to: CGPoint(x: 30, y: 7))
        path.addLine(to: CGPoint(x: 43, y: 7))

        return path.applying(.init(scaleX: rect.width / Self.originalSize.width, y: rect.height / Self.originalSize.height))
    }
}

struct MistShape_Previews: PreviewProvider {
    static var previews: some View {
        MistShape()
            .stroke(Color.white.opacity(0.5), style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
            .frame(width: 44, height: 29)
            .padding()
            .shadow(radius: 5)
    }
}
