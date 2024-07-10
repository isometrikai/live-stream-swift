
import Foundation

public struct ISMOptionsConfiguration {
    
    /// This will activates the delegate methods to add custom profile views within the stream
    public let customProfile: Bool
    
    /// This will activates the delegate methods to add custom product views within the stream
    public let customProduct: Bool
    
    /// This will activates the pk function for a stream
    public let isPKEnabled: Bool
    
    /// This will activates the group streaming functions for a stream
    public let isGroupStreamingEnabled: Bool
    
    /// This will activates the product option in the stream option stack
    public let isProductEnabled: Bool
    
    /// This will activates the restream options
    public let isRestreamEnabled: Bool
    
    /// This will activates the rtmp stream options
    public let isRTMPStreamEnabled: Bool
    
    /// This will activates the paid stream options
    public let isPaidStreamOptionEnabled: Bool
    
    /// This will activates the paid stream options
    public let isScheduleStreamOptionEnabled: Bool
    
    public init(
        customProfile: Bool = false,
        customProduct: Bool = false,
        isGroupStreamingEnabled: Bool = false,
        isPKEnabled: Bool = false,
        isProductEnabled: Bool = false,
        isRTMPStreamEnabled: Bool = false,
        isPaidStreamOptionEnabled: Bool = false,
        isRestreamEnabled: Bool = false,
        isScheduleStreamOptionEnabled: Bool = false
    ) {
        self.customProfile = customProfile
        self.customProduct = customProduct
        self.isPKEnabled = isPKEnabled
        self.isGroupStreamingEnabled = isGroupStreamingEnabled
        self.isProductEnabled = isProductEnabled
        self.isRTMPStreamEnabled = isRTMPStreamEnabled
        self.isPaidStreamOptionEnabled = isPaidStreamOptionEnabled
        self.isRestreamEnabled = isRestreamEnabled
        self.isScheduleStreamOptionEnabled = isScheduleStreamOptionEnabled
    }
    
}
