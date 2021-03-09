import SwiftUI

public struct SunView: View {
    let bright: Bool

    static let sunYellow = Color(red: 1, green: 0.96, blue: 0.54)

    public static let originalSize = CGSize(width: 54, height: 54)

    public init(bright: Bool = true) {
        self.bright = bright
    }

    public var body: some View {
        GeometryReader { geometry in

            // Because of aspectRatio we can neglect the height dimension
            let factor = geometry.size.width / Self.originalSize.width

            ZStack {
                Circle()
                    .fill(RadialGradient(gradient: Gradient(colors: [bright ? Color(red: 1, green: 0.98, blue: 0.7) : Self.sunYellow, Self.sunYellow]), center: .center, startRadius: 0, endRadius: 14))
                    .padding(13 * factor)

                SunRayShape()
                    .fill(RadialGradient(gradient: Gradient(colors: [Self.sunYellow, Self.sunYellow.opacity(0)]), center: .center, startRadius: 14 * factor, endRadius: 27 * factor))
                    .opacity(bright ? 1 : 0)
            }
        }
        .aspectRatio(contentMode: .fit)
    }
}

struct SunView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SunView()
            SunView(bright: true)
            SunView(bright: false)
        }
        .background(Color(hex: 0xABD8FF))
    }
}
