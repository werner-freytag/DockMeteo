import SwiftUI

public struct MoonView: View {
    let ageAngle: Angle
    let shadowAngle: Angle

    public init(ageAngle: Angle = .degrees(180), shadowAngle: Angle = .zero) {
        self.ageAngle = ageAngle
        self.shadowAngle = shadowAngle
    }

    static let spotColor = Color(white: 0.5).opacity(0.1)

    public var body: some View {
        GeometryReader { geometry in
            let diameter = min(geometry.size.width, geometry.size.height)

            ZStack {
                Circle()
                    .fill(RadialGradient(gradient: Gradient(colors: [Color.white, Color(white: 0.9)]), center: .center, startRadius: diameter * 0.2, endRadius: diameter))
                Group {
                    Circle()
                        .fill(Self.spotColor)
                        .frame(width: diameter * 0.15, height: diameter * 0.15)
                        .transformEffect(.init(translationX: diameter * 0.2, y: diameter * -0.25))
                    Circle()
                        .fill(Self.spotColor)
                        .frame(width: diameter * 0.21, height: diameter * 0.21)
                        .transformEffect(.init(translationX: diameter * 0.3, y: diameter * 0.05))
                    Circle()
                        .fill(Self.spotColor)
                        .frame(width: diameter * 0.31, height: diameter * 0.31)
                        .transformEffect(.init(translationX: diameter * -0.25, y: diameter * -0.1))
                    Circle()
                        .fill(Self.spotColor)
                        .frame(width: diameter * 0.125, height: diameter * 0.125)
                        .transformEffect(.init(translationX: diameter * -0.18, y: diameter * -0.35))
                    Circle()
                        .fill(Self.spotColor)
                        .frame(width: diameter * 0.17, height: diameter * 0.17)
                        .transformEffect(.init(translationX: diameter * -0.05, y: diameter * 0.3))
                }
            }
            .mask(MoonShadowMask(ageAngle: ageAngle, rotationAngle: shadowAngle))
        }
    }
}

struct Moon_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MoonView()
            MoonView(ageAngle: .degrees(30), shadowAngle: .degrees(0))
            MoonView(ageAngle: .degrees(120), shadowAngle: .degrees(10))
            MoonView(ageAngle: .degrees(210), shadowAngle: .degrees(20))
            MoonView(ageAngle: .degrees(300), shadowAngle: .degrees(30))
        }
        .padding(10)
        .background(Color(red: 0.03137254902, green: 0.3137254902, blue: 0.5647058824))
    }
}
