
import UIKit

public struct ISMStreamAppearance {
    public var json = ISM_JSON()
    public init() {}
}

// MARK: - Appearance + Default

public extension ISMStreamAppearance {
    static var `default`: ISMStreamAppearance = .init()
}

