//
//  Created by Werner on 18.03.21.
//  Copyright © 2021 Pecora GmbH. All rights reserved.
//

import Contacts
import CoreLocation
import Foundation

extension CLPlacemark {
    var formattedAddress: String? {
        guard let postalAddress = postalAddress else { return nil }
        let formatter = CNPostalAddressFormatter()
        return formatter.string(from: postalAddress).replacingOccurrences(of: "\n", with: ", ")
    }
}
