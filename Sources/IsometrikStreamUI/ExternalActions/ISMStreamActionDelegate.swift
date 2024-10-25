
import UIKit
import IsometrikStream

public protocol ISMStreamActionDelegate {
    
    /// Called when the stream store option is tapped.
    /// - Parameters:
    ///   - forUserType: Specifies the type of user interacting with the stream store option.
    ///   - root: The navigation controller used for any required navigation.
    func didStreamStoreOptionTapped(forUserType: StreamUserType, root: UINavigationController)
    
    /// Called when the share stream option is tapped.
    /// - Parameters:
    ///   - streamData: Data associated with the stream that is being shared.
    ///   - root: The navigation controller used for any required navigation.
    func didShareStreamTapped(streamData: SharedStreamData, root: UINavigationController)
    
    /// Called when the stream close action is triggered.
    /// - Parameters:
    ///   - memberData: Data associated with the host member of a stream.
    ///   - callback: A closure that returns `true` if the stream closed successfully, allowing for actions based on the result.
    ///   - root: The navigation controller used for any required navigation.
    func didCloseStreamTapped(memberData: ISMMember?, callback: @escaping (Bool) -> (), root: UINavigationController)

}

