
import Foundation

public struct ISMPresignedUrlResponse: Codable {
    public let msg: String?
    public let mediaUrl: String?
    public let presignedUrl: String?
    public let ttl: Int?
}
