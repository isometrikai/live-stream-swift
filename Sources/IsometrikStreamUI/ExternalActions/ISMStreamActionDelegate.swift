
import UIKit
import IsometrikStream

public protocol ISMStreamActionDelegate {
    func didStreamStoreOptionTapped(forUserType: StreamUserType, root: UINavigationController)
    func didShareStreamTapped(streamData: SharedStreamData, root: UINavigationController)
}
