import Foundation

public protocol GenricErrorModel {
    var error: String? { get }
    var errors: [String: [String]]? { get }
}
