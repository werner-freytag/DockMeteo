import SwiftUI

public struct MoonView: View {
    public init(fill fillColor: Color = .white, spotFill spotColor: Color = Color(white: 0).opacity(0.05)) {
        self.fillColor = fillColor
        self.spotColor = spotColor
    }

    let fillColor: Color
    let spotColor: Color

    public var body: some View {
        GeometryReader { geometry in
            let diameter = min(geometry.size.width, geometry.size.height)

            ZStack {
                Group {
                    Circle().fill(self.fillColor)
                    Circle().fill(RadialGradient(gradient: Gradient(colors: [Color.black.opacity(0), Color(white: 0).opacity(0.1)]), center: .center, startRadius: diameter * 0.2, endRadius: diameter))
                }
                Group {
                    Circle()
                        .fill(spotColor)
                        .frame(width: diameter * 0.15, height: diameter * 0.15)
                        .transformEffect(.init(translationX: diameter * 0.2, y: diameter * -0.25))
                    Circle()
                        .fill(spotColor)
                        .frame(width: diameter * 0.21, height: diameter * 0.21)
                        .transformEffect(.init(translationX: diameter * 0.3, y: diameter * 0.05))
                    Circle()
                        .fill(spotColor)
                        .frame(width: diameter * 0.31, height: diameter * 0.31)
                        .transformEffect(.init(translationX: diameter * -0.25, y: diameter * -0.1))
                    Circle()
                        .fill(spotColor)
                        .frame(width: diameter * 0.125, height: diameter * 0.125)
                        .transformEffect(.init(translationX: diameter * -0.18, y: diameter * -0.35))
                    Circle()
                        .fill(spotColor)
                        .frame(width: diameter * 0.17, height: diameter * 0.17)
                        .transformEffect(.init(translationX: diameter * -0.05, y: diameter * 0.3))
                }
            }
        }
    }
}

struct Moon_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MoonView()
            MoonView().applyingSphericShadowMask(yAngle: .degrees(30), zAngle: .degrees(0))
            MoonView().applyingSphericShadowMask(yAngle: .degrees(30), zAngle: .degrees(0))
            MoonView().applyingSphericShadowMask(yAngle: .degrees(120), zAngle: .degrees(10))
            MoonView().applyingSphericShadowMask(yAngle: .degrees(210), zAngle: .degrees(20))
            MoonView().applyingSphericShadowMask(yAngle: .degrees(300), zAngle: .degrees(30))
        }
        .padding(10)
        .background(Color(red: 0.03137254902, green: 0.3137254902, blue: 0.5647058824))
    }
}
