import Foundation
import SwiftUI

struct MoonShadow: Shape {
    let phaseAge: Double

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let fraction: CGFloat = 0.7
        let direction: CGFloat = -1.0

        // swiftformat:disable all
        path.move(to:           CGPoint(x: rect.midX,                                               y: rect.minY))
        path.addCurve(to:       CGPoint(x: rect.midX + direction * (rect.maxX - rect.midX),         y: rect.midY),
                      control1: CGPoint(x: rect.midX + direction * (rect.maxX - rect.midX) * 0.55,  y: rect.minY),
                      control2: CGPoint(x: rect.midX + direction * (rect.maxX - rect.midX),         y: rect.midY - (rect.midY - rect.minY) * 0.55))
        path.addCurve(to:       CGPoint(x: rect.midX,                                               y: rect.maxY),
                      control1: CGPoint(x: rect.midX + direction * (rect.maxX - rect.midX),         y: rect.midY + (rect.midY - rect.minY) * 0.55),
                      control2: CGPoint(x: rect.midX + direction * (rect.maxX - rect.midX) * 0.55,  y: rect.maxY))

        path.addCurve(to:       CGPoint(x: rect.midX + fraction * (rect.maxX - rect.midX),          y: rect.midY),
                      control1: CGPoint(x: rect.midX + fraction * (rect.maxX - rect.midX) * 0.55,   y: rect.maxY),
                      control2: CGPoint(x: rect.midX + fraction * (rect.maxX - rect.midX),          y: rect.midY + (rect.midY - rect.minY) * 0.55))
        path.addCurve(to:       CGPoint(x: rect.midX,                                               y: rect.minY),
                      control1: CGPoint(x: rect.midX + fraction * (rect.maxX - rect.midX),          y: rect.midY - (rect.midY - rect.minY) * 0.55),
                      control2: CGPoint(x: rect.midX + fraction * (rect.maxX - rect.midX) * 0.55,   y: rect.minY))
        // swiftformat:enable all

        return path
    }
}

struct MoonShadow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MoonShadow(phaseAge: 0.77)
                .stroke(Color.red)
                .frame(width: 50, height: 50)
        }
    }
}
