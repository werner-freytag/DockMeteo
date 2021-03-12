//
//  SunRayBigPath.swift
//  DockSunshine
//
//  Created by Werner on 08.03.21.
//  Copyright © 2021 Pecora GmbH. All rights reserved.
//

import SwiftUI

struct SunRaySmallPath: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 1.5, y: 0))
        path.addCurve(to: CGPoint(x: 2, y: 2.1), control1: CGPoint(x: 1.7, y: 0), control2: CGPoint(x: 1.7, y: 0.8))
        path.addCurve(to: CGPoint(x: 3, y: 5.2), control1: CGPoint(x: 2.2, y: 3.4), control2: CGPoint(x: 3, y: 4.3))
        path.addCurve(to: CGPoint(x: 1.5, y: 7), control1: CGPoint(x: 3, y: 6.1), control2: CGPoint(x: 2.3, y: 7))
        path.addCurve(to: CGPoint(x: 0, y: 5.2), control1: CGPoint(x: 0.7, y: 7), control2: CGPoint(x: 0, y: 6.1))
        path.addCurve(to: CGPoint(x: 1.1, y: 2.1), control1: CGPoint(x: 0, y: 4.3), control2: CGPoint(x: 0.8, y: 3.4))
        path.addCurve(to: CGPoint(x: 1.5, y: 0), control1: CGPoint(x: 1.3, y: 0.8), control2: CGPoint(x: 1.3, y: 0))

        return path
    }
}

struct SunRaySmallPath_Previews: PreviewProvider {
    static var previews: some View {
        SunRayShape()
            .fill(Color.yellow)
            .frame(width: 3, height: 11)
    }
}
