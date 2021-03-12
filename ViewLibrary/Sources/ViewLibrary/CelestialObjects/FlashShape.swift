import SwiftUI

public struct FlashShape: Shape {
    public static let originalSize = CGSize(width: 14, height: 28)

    public init() {}

    public func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: 7, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 15))
        path.addLine(to: CGPoint(x: 6.9, y: 12.6))
        path.addLine(to: CGPoint(x: 1.8, y: 27.7))
        path.addLine(to: CGPoint(x: 14.0, y: 7.4))
        path.addLine(to: CGPoint(x: 8.1, y: 9.1))
        path.addLine(to: CGPoint(x: 14, y: 0))

        return path
    }
}

struct FlashShape_Previews: PreviewProvider {
    static var previews: some View {
        FlashShape()
            .fill(Color.white)
            .frame(width: 14, height: 28)
            .padding()
            .shadow(radius: 8)
    }
}
