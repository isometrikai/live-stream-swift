import UIKit

class Toast: UIView, ISMAppearanceProvider {
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = appearance.font.getFont(forTypo: .h6)
        return label
    }()
    
    init(message: String) {
        super.init(frame: .zero)
        self.messageLabel.text = message
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        self.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            messageLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            messageLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
    
    func show(in view: UIView, duration: TimeInterval) {
        self.alpha = 0
        view.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            self.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
        
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: duration, options: .curveEaseOut, animations: {
                self.alpha = 0
            }) { _ in
                self.removeFromSuperview()
            }
        }
    }
}

class ToastManager {
    
    static let shared = ToastManager()
    
    private init() {}
    
    func showToast(message: String, in view: UIView, duration: TimeInterval = 2.0) {
        let toast = Toast(message: message)
        toast.show(in: view, duration: duration)
    }
    
}


