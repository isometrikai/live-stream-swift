import UIKit
import IsometrikStream

final public class ISMExternalActions {
    
    var isometrik: IsometrikSDK
    
    init(isometrik: IsometrikSDK) {
        self.isometrik = isometrik
    }
    
    func openStream(streamId: String, root: UINavigationController){
        
        if streamId.isEmpty {
            root.view.showToast(message: "stream id not found!", duration: 1)
        }
        
    }
    
}
