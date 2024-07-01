//
//  IsometrikStream.swift
//  NewLiveStream
//
//  Created by Dheeraj Kumar Sharma on 12/11/22.
//

import UIKit
import Toast

public protocol IsometrikStreamDelegate {
    func didFail(error: IsometrikError?)
}

/// An object that coordinates a group of related Isometrik network events
public class IsometrikStream : NSObject {
    
    /// Instance identifier
    public let instanceID: UUID
    
    /// A copy of the configuration object used for this session
    public var configuration: ISMConfiguration
    
    public var rtcWrapper : RtcWrapper
    
    public var delegate: IsometrikStreamDelegate?
    
    /// - Parameters:
    ///   - configuration: The default configurations that will be used
    ///   - session: Session used for performing request/response REST calls
    ///   - subscribeSession: The network session used for Subscription only
    public init(configuration: ISMConfiguration, isRtcWrapper: Bool = true) {
        instanceID = UUID()
        self.configuration = configuration
        rtcWrapper = RtcWrapper.init(config: self.configuration,isLoad: isRtcWrapper)
    }
    

}

/// Implements  rtc wrapper protocol methods to expose them to the client app
public protocol RtcProtocol: AnyObject {
    func videoSessionsDidSet()
}
