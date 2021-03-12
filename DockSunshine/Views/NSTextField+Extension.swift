import Cocoa

extension NSTextField {
    @discardableResult
    func fontDesign(_ design: NSFontDescriptor.SystemDesign) -> Self {
        if let font = self.font, let descriptor = font.fontDescriptor.withDesign(design) {
            self.font = NSFont(descriptor: descriptor, size: font.pointSize)
        }
        return self
    }

    @discardableResult
    func shadow(color: NSColor = .init(white: 0, alpha: 0.33), radius: CGFloat, x: CGFloat = 0, y: CGFloat = 0) -> Self {
        let shadow = NSShadow()
        shadow.shadowBlurRadius = radius
        shadow.shadowOffset = .init(width: x, height: y)
        shadow.shadowColor = color
        self.shadow = shadow

        return self
    }
}
