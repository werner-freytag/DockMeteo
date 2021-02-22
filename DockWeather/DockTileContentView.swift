//
//  Created by Werner on 22.02.21.
//  Copyright © 2021 Pecora GmbH. All rights reserved.
//

import Cocoa

class DockTileContentView: NSView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        wantsLayer = true
        layer = makeBackingLayer()

        guard let layer = layer else { return }

        let shadow = NSShadow()
        shadow.shadowOffset = .init(width: 0, height: -1.8)
        shadow.shadowBlurRadius = 1.8
        shadow.shadowColor = NSColor.black.withAlphaComponent(0.18)

        self.shadow = shadow
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidMoveToSuperview() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.WeatherData.didRefresh, object: nil, queue: nil) {
            guard let weatherData = $0.userInfo?["data"] as? WeatherData else { return assertionFailure() }

            print(weatherData)
        }
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
}
