import UIKit
import IsometrikStream

public protocol ISMExternalDelegate: ISMGoLiveActionDelegate, ISMStreamActionDelegate {}

final public class ISMExternalActions {
    
    var isometrik: IsometrikSDK
    
    public init(isometrik: IsometrikSDK) {
        self.isometrik = isometrik
    }
    
    @MainActor
    public func openStream(streamId: String, scene: UIWindowScene?) {
        
        if let viewController = getTopViewController(scene: scene), streamId.isEmpty {
            viewController.view.showToast(message: "stream id not found!")
        }
        
        // get stream data
        let streamQuery = StreamQuery(streamId: streamId)
        
        isometrik.getIsometrik().fetchStreams(streamParam: streamQuery) { streamData in
            self.routeToStream(streamData: streamData, scene: scene)
        } failure: { error in
            if let viewController = self.getTopViewController(scene: scene) {
                viewController.view.showToast(message: error.localizedDescription)
            }
        }
        
    }
    
    func routeToStream(streamData: ISMStreamsData, scene: UIWindowScene?) {
        
        let streams = streamData.streams ?? []
        let viewModel = StreamViewModel(isometrik: self.isometrik, streamsData: streams)
        let streamController = StreamViewController(viewModel: viewModel)
        let navVC = UINavigationController(rootViewController: streamController)
        navVC.modalPresentationStyle = .fullScreen
        
        if let topVC = getTopViewController(scene: scene) {
            topVC.present(navVC, animated: true)
        }
        
    }
    
    func getTopViewController(scene: UIWindowScene?) -> UIViewController? {
        
        if let windowScene = scene {
            for window in windowScene.windows {
                if let rootVC = window.rootViewController {
                    let topVC = rootVC.topMostViewController()
                    return topVC
                }
            }
        }
        
        return nil
        
    }
    
    
    
}
