import SwiftUI

public struct SnowFlakeShape: Shape {
    public static let originalSize = CGSize(width: 19, height: 21)

    public init() {}

    public func path(in rect: CGRect) -> Path {
        var path = Path()

        // arms
        path.move(to: CGPoint(x: 9.238, y: 0))
        path.addLine(to: CGPoint(x: 9.238, y: 7.467))
        path.move(to: CGPoint(x: 6.007, y: 1.6))
        path.addLine(to: CGPoint(x: 9.238, y: 4.8))
        path.move(to: CGPoint(x: 12.468, y: 1.6))
        path.addLine(to: CGPoint(x: 9.238, y: 4.8))
        path.move(to: CGPoint(x: 9.238, y: 20.802))
        path.addLine(to: CGPoint(x: 9.238, y: 13.337))
        path.move(to: CGPoint(x: 12.468, y: 19.202))
        path.addLine(to: CGPoint(x: 9.238, y: 16.003))
        path.move(to: CGPoint(x: 6.007, y: 19.202))
        path.addLine(to: CGPoint(x: 9.238, y: 16.003))
        path.move(to: CGPoint(x: 18.245, y: 5.2))
        path.addLine(to: CGPoint(x: 11.779, y: 8.934))
        path.move(to: CGPoint(x: 15.244, y: 3.203))
        path.addLine(to: CGPoint(x: 14.088, y: 7.6))
        path.move(to: CGPoint(x: 18.475, y: 8.798))
        path.addLine(to: CGPoint(x: 14.088, y: 7.6))
        path.move(to: CGPoint(x: 0.23, y: 15.601))
        path.addLine(to: CGPoint(x: 6.695, y: 11.869))
        path.move(to: CGPoint(x: 3.231, y: 17.6))
        path.addLine(to: CGPoint(x: 4.386, y: 13.202))
        path.move(to: CGPoint(x: 0, y: 12.004))
        path.addLine(to: CGPoint(x: 4.386, y: 13.202))
        path.move(to: CGPoint(x: 18.245, y: 15.601))
        path.addLine(to: CGPoint(x: 11.779, y: 11.868))
        path.move(to: CGPoint(x: 18.475, y: 12.003))
        path.addLine(to: CGPoint(x: 14.088, y: 13.201))
        path.move(to: CGPoint(x: 15.244, y: 17.599))
        path.addLine(to: CGPoint(x: 14.088, y: 13.201))
        path.move(to: CGPoint(x: 0.23, y: 5.2))
        path.addLine(to: CGPoint(x: 6.695, y: 8.933))
        path.move(to: CGPoint(x: 0, y: 8.798))
        path.addLine(to: CGPoint(x: 4.386, y: 7.6))
        path.move(to: CGPoint(x: 3.231, y: 3.202))
        path.addLine(to: CGPoint(x: 4.386, y: 7.6))

        // center
        path.move(to: CGPoint(x: 9.238, y: 7.5))
        path.addLine(to: CGPoint(x: 11.836, y: 8.9))
        path.addLine(to: CGPoint(x: 11.836, y: 11.9))
        path.addLine(to: CGPoint(x: 9.238, y: 13.3))
        path.addLine(to: CGPoint(x: 6.64, y: 11.9))
        path.addLine(to: CGPoint(x: 6.64, y: 8.9))
        path.addLine(to: CGPoint(x: 9.238, y: 7.5))

        return path.applying(.init(scaleX: rect.width / Self.originalSize.width, y: rect.height / Self.originalSize.height))
    }
}

struct SnowFlakeShape_Previews: PreviewProvider {
    static var previews: some View {
        SnowFlakeShape()
            .stroke(Color.white.opacity(0.8), style: StrokeStyle(lineWidth: 1.5, lineCap: .round))
            .frame(width: 19, height: 21)
            .padding()
    }
}
