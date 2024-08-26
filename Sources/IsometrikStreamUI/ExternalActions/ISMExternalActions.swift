import UIKit
import IsometrikStream

final public class ISMExternalActions {
    
    var isometrik: IsometrikSDK
    
    public init(isometrik: IsometrikSDK) {
        self.isometrik = isometrik
    }
    
    @MainActor
    public func openStream(streamId: String, completion: @escaping(UIViewController?, String?) -> Void) {
        
        if streamId.isEmpty {
            completion(nil,"stream id not found!")
        }
        
        // get stream data
        let streamQuery = StreamQuery(streamId: streamId)
        
        isometrik.getIsometrik().fetchStreams(streamParam: streamQuery) { streamData in
            
            let streams = streamData.streams ?? []
            let viewModel = StreamViewModel(isometrik: self.isometrik, streamsData: streams)
            let streamController = StreamViewController(viewModel: viewModel)
            let navVC = UINavigationController(rootViewController: streamController)
            navVC.modalPresentationStyle = .fullScreen
            completion(navVC, nil)
            
        } failure: { error in
            completion(nil, error.localizedDescription)
        }
        
        
    }
    
    
    
}
