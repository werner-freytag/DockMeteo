import Foundation
import SwiftToolbox
import SwiftUI

struct MoonShadowMask: Shape {
    let ageAngle: Angle
    let rotationAngle: Angle

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let radians = normalizeRadians(.pi + ageAngle.radians)
        guard !((Double.pi - 0.0001) ... (Double.pi + 0.0001)).contains(radians) else { return path }

        let leftFraction: CGFloat = radians < .pi ? -1 : CGFloat(-cos(radians))
        let rightFraction: CGFloat = radians > .pi ? 1 : CGFloat(-cos(radians + .pi))

        // swiftformat:disable all
        path.move(to:           CGPoint(x: rect.midX,                                                   y: rect.minY))
        path.addCurve(to:       CGPoint(x: rect.midX + rightFraction * (rect.maxX - rect.midX),         y: rect.midY),
                      control1: CGPoint(x: rect.midX + rightFraction * (rect.maxX - rect.midX) * 0.55,  y: rect.minY),
                      control2: CGPoint(x: rect.midX + rightFraction * (rect.maxX - rect.midX),         y: rect.midY - (rect.midY - rect.minY) * 0.55))
        path.addCurve(to:       CGPoint(x: rect.midX,                                                   y: rect.maxY),
                      control1: CGPoint(x: rect.midX + rightFraction * (rect.maxX - rect.midX),         y: rect.midY + (rect.midY - rect.minY) * 0.55),
                      control2: CGPoint(x: rect.midX + rightFraction * (rect.maxX - rect.midX) * 0.55,  y: rect.maxY))

        path.addCurve(to:       CGPoint(x: rect.midX + leftFraction * (rect.maxX - rect.midX),          y: rect.midY),
                      control1: CGPoint(x: rect.midX + leftFraction * (rect.maxX - rect.midX) * 0.55,   y: rect.maxY),
                      control2: CGPoint(x: rect.midX + leftFraction * (rect.maxX - rect.midX),          y: rect.midY + (rect.midY - rect.minY) * 0.55))
        path.addCurve(to:       CGPoint(x: rect.midX,                                                   y: rect.minY),
                      control1: CGPoint(x: rect.midX + leftFraction * (rect.maxX - rect.midX),          y: rect.midY - (rect.midY - rect.minY) * 0.55),
                      control2: CGPoint(x: rect.midX + leftFraction * (rect.maxX - rect.midX) * 0.55,   y: rect.minY))
        // swiftformat:enable all

        let transform: CGAffineTransform = .init(translationX: rect.midX, y: rect.midY)
            .rotated(by: CGFloat(rotationAngle.radians))
            .translatedBy(x: -rect.midX, y: -rect.midY)

        return path.applying(transform)
    }
}

struct MoonShadowMask_Previews: PreviewProvider {
    static var previews: some View {
        let angles = Array(stride(from: 0.0, to: 360.0, by: 30))
        Group {
            ForEach(angles, id: \.self) { angle in
                ZStack {
                    MoonShadowMask(ageAngle: .degrees(angle), rotationAngle: .degrees(0))
                        .fill(Color.white)
                        .frame(width: 25, height: 25)
                        .padding(10)
                }
                .background(Color(red: 0.03137254902, green: 0.3137254902, blue: 0.5647058824))
            }
        }
    }
}
