import UIKit
import Lottie

final public class CustomLoaderView: UIView {
    
    // MARK: PROPERTIES -
    
    var animationView: LottieAnimationView?
    
    private let loaderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    // MARK: MAIN -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: FUNCTIONS -
    
    func setUpViews(){
        backgroundColor = UIColor.black.withAlphaComponent(0.8)
        addSubview(loaderView)
        isHidden = true
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            loaderView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loaderView.centerYAnchor.constraint(equalTo: centerYAnchor),
            loaderView.widthAnchor.constraint(equalToConstant: 150),
            loaderView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    public func startLoading() {
        isHidden = false
        guard let animationView else { return }
        animationView.play()
    }
    
    public func stopLoading() {
        isHidden = true
        guard let animationView else { return }
        animationView.stop()
    }
    
    public func setCreateAnimation() {
        animationView = .init(filePath: ISMAppearance.default.json.loaderAnimation)
        animationView?.frame = self.loaderView.bounds
        animationView?.contentMode = .scaleAspectFit
        animationView?.loopMode = .loop
        animationView?.animationSpeed = 0.7
        loaderView.addSubview(animationView!)
        animationView?.pin(to: loaderView)
        animationView?.play()
    }
    
}

final public class CustomLoader {
    
    public static let shared = CustomLoader()
    
    private var loaderView: CustomLoaderView?
    private var topMostViewController: UIViewController?
    
    init(){
        self.updateTopMostController()
        loaderView = CustomLoaderView()
        loaderView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        loaderView?.setCreateAnimation()
        
        // Delay adding the loader view to ensure the view hierarchy is set up
        DispatchQueue.main.async {
            if let topMostViewController = self.topMostViewController {
                topMostViewController.view.setNeedsLayout()
                topMostViewController.view.layoutIfNeeded()
                self.loaderView?.frame = UIScreen.main.bounds
                topMostViewController.view.addSubview(self.loaderView!)
            }
        }
    }
    
    public func startLoading(){
        DispatchQueue.main.async {
            self.updateTopMostController()
            self.loaderView?.startLoading()
            self.topMostViewController?.view.addSubview(self.loaderView!)
        }
    }
    
    public func stopLoading(){
        DispatchQueue.main.async {
            self.loaderView?.stopLoading()
            self.loaderView?.removeFromSuperview()
        }
    }
    
    private func updateTopMostController(){
        
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            self.topMostViewController = rootViewController
        }
        while let presentedViewController = topMostViewController?.presentedViewController {
            self.topMostViewController =  presentedViewController
        }
        
    }
    
}
