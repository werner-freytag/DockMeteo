import SwiftUI

public struct IconShape: Shape {
    public static let originalSize = CGSize(width: 256, height: 256)

    public init() {}

    public func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: 206, y: 63.845))
        path.addCurve(to: CGPoint(x: 205.986, y: 56.544), control1: CGPoint(x: 206, y: 61.412), control2: CGPoint(x: 206, y: 58.978))
        path.addCurve(to: CGPoint(x: 205.894, y: 50.395), control1: CGPoint(x: 205.974, y: 54.494), control2: CGPoint(x: 205.95, y: 52.444))
        path.addCurve(to: CGPoint(x: 204.71, y: 37.007), control1: CGPoint(x: 205.773, y: 45.928), control2: CGPoint(x: 205.508, y: 41.424))
        path.addCurve(to: CGPoint(x: 200.495, y: 24.286), control1: CGPoint(x: 203.9, y: 32.526), control2: CGPoint(x: 202.579, y: 28.357))
        path.addCurve(to: CGPoint(x: 192.58, y: 13.449), control1: CGPoint(x: 198.447, y: 20.284), control2: CGPoint(x: 195.772, y: 16.623))
        path.addCurve(to: CGPoint(x: 181.686, y: 5.577), control1: CGPoint(x: 189.389, y: 10.275), control2: CGPoint(x: 185.709, y: 7.614))
        path.addCurve(to: CGPoint(x: 168.889, y: 1.383), control1: CGPoint(x: 177.591, y: 3.504), control2: CGPoint(x: 173.397, y: 2.189))
        path.addCurve(to: CGPoint(x: 155.435, y: 0.206), control1: CGPoint(x: 164.451, y: 0.59), control2: CGPoint(x: 159.923, y: 0.327))
        path.addCurve(to: CGPoint(x: 149.252, y: 0.115), control1: CGPoint(x: 153.374, y: 0.151), control2: CGPoint(x: 151.313, y: 0.128))
        path.addCurve(to: CGPoint(x: 141.911, y: 0.101), control1: CGPoint(x: 146.805, y: 0.1), control2: CGPoint(x: 144.358, y: 0.101))
        path.addLine(to: CGPoint(x: 113.499, y: 0))
        path.addLine(to: CGPoint(x: 92.249, y: 0))
        path.addLine(to: CGPoint(x: 64.34, y: 0.101))
        path.addCurve(to: CGPoint(x: 56.985, y: 0.115), control1: CGPoint(x: 61.889, y: 0.101), control2: CGPoint(x: 59.437, y: 0.1))
        path.addCurve(to: CGPoint(x: 50.79, y: 0.206), control1: CGPoint(x: 54.92, y: 0.128), control2: CGPoint(x: 52.855, y: 0.151))
        path.addCurve(to: CGPoint(x: 37.304, y: 1.384), control1: CGPoint(x: 46.292, y: 0.327), control2: CGPoint(x: 41.753, y: 0.59))
        path.addCurve(to: CGPoint(x: 24.49, y: 5.576), control1: CGPoint(x: 32.791, y: 2.19), control2: CGPoint(x: 28.59, y: 3.504))
        path.addCurve(to: CGPoint(x: 13.573, y: 13.449), control1: CGPoint(x: 20.459, y: 7.613), control2: CGPoint(x: 16.771, y: 10.274))
        path.addCurve(to: CGPoint(x: 5.643, y: 24.284), control1: CGPoint(x: 10.375, y: 16.623), control2: CGPoint(x: 7.695, y: 20.283))
        path.addCurve(to: CGPoint(x: 1.418, y: 37.012), control1: CGPoint(x: 3.554, y: 28.357), control2: CGPoint(x: 2.23, y: 32.529))
        path.addCurve(to: CGPoint(x: 0.233, y: 50.395), control1: CGPoint(x: 0.619, y: 41.427), control2: CGPoint(x: 0.354, y: 45.93))
        path.addCurve(to: CGPoint(x: 0.141, y: 56.544), control1: CGPoint(x: 0.177, y: 52.444), control2: CGPoint(x: 0.153, y: 54.494))
        path.addCurve(to: CGPoint(x: 0, y: 64.435), control1: CGPoint(x: 0.126, y: 58.978), control2: CGPoint(x: 0, y: 62.002))
        path.addLine(to: CGPoint(x: 0, y: 91.824))
        path.addLine(to: CGPoint(x: 0, y: 113.197))
        path.addLine(to: CGPoint(x: 0.127, y: 141.168))
        path.addCurve(to: CGPoint(x: 0.141, y: 148.479), control1: CGPoint(x: 0.127, y: 143.605), control2: CGPoint(x: 0.126, y: 146.042))
        path.addCurve(to: CGPoint(x: 0.233, y: 154.637), control1: CGPoint(x: 0.153, y: 150.532), control2: CGPoint(x: 0.177, y: 152.585))
        path.addCurve(to: CGPoint(x: 1.419, y: 168.043), control1: CGPoint(x: 0.354, y: 159.109), control2: CGPoint(x: 0.62, y: 163.62))
        path.addCurve(to: CGPoint(x: 5.642, y: 180.781), control1: CGPoint(x: 2.231, y: 172.53), control2: CGPoint(x: 3.555, y: 176.705))
        path.addCurve(to: CGPoint(x: 13.573, y: 191.633), control1: CGPoint(x: 7.694, y: 184.788), control2: CGPoint(x: 10.375, y: 188.455))
        path.addCurve(to: CGPoint(x: 24.488, y: 199.516), control1: CGPoint(x: 16.77, y: 194.812), control2: CGPoint(x: 20.458, y: 197.476))
        path.addCurve(to: CGPoint(x: 37.309, y: 203.715), control1: CGPoint(x: 28.591, y: 201.592), control2: CGPoint(x: 32.794, y: 202.909))
        path.addCurve(to: CGPoint(x: 50.79, y: 204.894), control1: CGPoint(x: 41.757, y: 204.51), control2: CGPoint(x: 46.293, y: 204.773))
        path.addCurve(to: CGPoint(x: 56.985, y: 204.985), control1: CGPoint(x: 52.855, y: 204.949), control2: CGPoint(x: 54.92, y: 204.973))
        path.addCurve(to: CGPoint(x: 64.34, y: 205), control1: CGPoint(x: 59.437, y: 205), control2: CGPoint(x: 61.889, y: 205))
        path.addLine(to: CGPoint(x: 92.502, y: 205))
        path.addLine(to: CGPoint(x: 113.804, y: 205))
        path.addLine(to: CGPoint(x: 141.911, y: 205))
        path.addCurve(to: CGPoint(x: 149.252, y: 204.985), control1: CGPoint(x: 144.358, y: 205), control2: CGPoint(x: 146.805, y: 205))
        path.addCurve(to: CGPoint(x: 155.435, y: 204.894), control1: CGPoint(x: 151.313, y: 204.973), control2: CGPoint(x: 153.374, y: 204.949))
        path.addCurve(to: CGPoint(x: 168.895, y: 203.714), control1: CGPoint(x: 159.925, y: 204.773), control2: CGPoint(x: 164.454, y: 204.509))
        path.addCurve(to: CGPoint(x: 181.685, y: 199.517), control1: CGPoint(x: 173.399, y: 202.908), control2: CGPoint(x: 177.592, y: 201.592))
        path.addCurve(to: CGPoint(x: 192.58, y: 191.633), control1: CGPoint(x: 185.708, y: 197.477), control2: CGPoint(x: 189.389, y: 194.812))
        path.addCurve(to: CGPoint(x: 200.495, y: 180.783), control1: CGPoint(x: 195.772, y: 188.455), control2: CGPoint(x: 198.447, y: 184.789))
        path.addCurve(to: CGPoint(x: 204.711, y: 168.038), control1: CGPoint(x: 202.579, y: 176.705), control2: CGPoint(x: 203.901, y: 172.527))
        path.addCurve(to: CGPoint(x: 205.894, y: 154.637), control1: CGPoint(x: 205.508, y: 163.617), control2: CGPoint(x: 205.773, y: 159.108))
        path.addCurve(to: CGPoint(x: 205.986, y: 148.479), control1: CGPoint(x: 205.95, y: 152.585), control2: CGPoint(x: 205.974, y: 150.532))
        path.addCurve(to: CGPoint(x: 206, y: 141.168), control1: CGPoint(x: 206, y: 146.042), control2: CGPoint(x: 206, y: 143.605))
        path.addCurve(to: CGPoint(x: 206, y: 113.197), control1: CGPoint(x: 206, y: 141.168), control2: CGPoint(x: 206, y: 113.691))
        path.addLine(to: CGPoint(x: 206, y: 91.802))
        path.addCurve(to: CGPoint(x: 206, y: 63.845), control1: CGPoint(x: 206, y: 91.437), control2: CGPoint(x: 206, y: 63.845))

        path = path.applying(.init(translationX: 25, y: 25))

        return path.applying(.init(scaleX: rect.width / Self.originalSize.width, y: rect.height / Self.originalSize.height))
    }
}

struct IconShape_Previews: PreviewProvider {
    static var previews: some View {
        IconShape()
            .fill(Color.white)
            .frame(width: 256, height: 256)
            .shadow(radius: 8)
    }
}
