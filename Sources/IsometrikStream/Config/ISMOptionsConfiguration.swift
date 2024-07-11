
import Foundation

public class ISMOptionsConfiguration {
    
    /// This will activates the delegate methods to add custom profile views within the stream
    private let enableProfileDelegate: Bool
    
    /// This will activates the delegate methods to add custom product views within the stream
    private let enableProductDelegate: Bool
    
    /// This will activates the pk function for a stream
    private let enablePKStream: Bool
    
    /// This will activates the group streaming functions for a stream
    private let enableGroupStream: Bool
    
    /// This will activates the product option in the stream option stack
    private let enableProductInStream: Bool
    
    /// This will activates the restream options
    private let enableRestream: Bool
    
    /// This will activates the rtmp stream options
    private let enableRTMPStream: Bool
    
    /// This will activates the paid stream options
    private let enablePaidStream: Bool
    
    /// This will activates the paid stream options
    private let enableScheduleStream: Bool
    
    public init(
        enableProfileDelegate: Bool = false,
        enableProductDelegate: Bool = false,
        enableGroupStream: Bool = false,
        enablePKStream: Bool = false,
        enableProductInStream: Bool = false,
        enableRTMPStream: Bool = false,
        enablePaidStream: Bool = false,
        enableRestream: Bool = false,
        enableScheduleStream: Bool = false
    ) {
        self.enableProfileDelegate = enableProfileDelegate
        self.enableProductDelegate = enableProductDelegate
        self.enablePKStream = enablePKStream
        self.enableGroupStream = enableGroupStream
        self.enableProductInStream = enableProductInStream
        self.enableRTMPStream = enableRTMPStream
        self.enablePaidStream = enablePaidStream
        self.enableRestream = enableRestream
        self.enableScheduleStream = enableScheduleStream
    }
    
    public var isProfileDelegateEnabled: Bool {
        return enableProfileDelegate
    }
    
    public var isProductDelegateEnabled: Bool {
        return enableProductDelegate
    }
    
    public var isPKStreamEnabled: Bool {
        return enablePKStream
    }
    
    public var isGroupStreamEnabled: Bool {
        return enableGroupStream
    }
    
    public var isProductInStreamEnabled: Bool {
        return enableProductInStream
    }
    
    public var isRTMPStreamEnabled: Bool {
        return enableRTMPStream
    }
    
    public var isRestreamEnabled: Bool {
        return enableRestream
    }
    
    public var isScheduleStreamEnabled: Bool {
        return enableScheduleStream
    }
    
}
