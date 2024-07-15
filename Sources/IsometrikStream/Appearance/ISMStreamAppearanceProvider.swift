
import UIKit

public protocol ISMStreamAppearanceProvider: AnyObject {
    /// Appearance object to change appearance of the existing views or to use default appearance of the SDK by custom components.
    var appearance: ISMStreamAppearance { get set }

    /// This function is called afther the appearance is registered.
    ///
    /// By default it's used to check that appearance is register before the view is initialized
    /// to make sure the appearance is used correctly.
    func appearanceDidRegister()
}

// MARK: - Protocol extensions for UIView

public extension ISMStreamAppearanceProvider where Self: UIResponder {
    func appearanceDidRegister() {}

    var appearance: ISMStreamAppearance {
        get {
            // If we have an appearance registered, return it
            if let appearance = associatedAppearance {
                return appearance
            }

            // Walk up the superview chain until we find a appearance provider
            // Skip non-providers
            var _next = next
            while _next != nil {
                if let _next = _next as? ISMStreamAppearanceProvider {
                    return _next.appearance
                } else {
                    _next = _next?.next
                }
            }

            // No parent provider found, return default appearance
            return .default
        }
        set {
            associatedAppearance = newValue
            appearanceDidRegister()
        }
    }
}

// MARK: - Stored property in UIView required to make this work

private extension UIResponder {
    static var associatedAppearanceKey: UInt8 = 1

    var associatedAppearance: ISMStreamAppearance? {
        get { objc_getAssociatedObject(self, &Self.associatedAppearanceKey) as? ISMStreamAppearance }
        set { objc_setAssociatedObject(self, &Self.associatedAppearanceKey, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
}

