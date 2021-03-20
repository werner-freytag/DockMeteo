//
//  Created by Werner on 18.03.21.
//  Copyright © 2021 Pecora GmbH. All rights reserved.
//

import Foundation
import SwiftToolbox

enum SkyDirection: CaseIterable {
    case N, NNE, NE, ENE, E, ESE, SE, SSE, S, SSW, SW, WSW, W, WNW, NW, NNW

    public init(degrees: Double) {
        let index = Int(floor(normalizeDegrees(degrees + 360 / 32) / 360 * 16)) % 16
        self = SkyDirection.allCases[index]
    }

    public init(angle: Measurement<UnitAngle>) {
        self.init(degrees: angle.converted(to: .degrees).value)
    }
}
