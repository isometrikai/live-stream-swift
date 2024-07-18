
import UIKit

class PaidStreamCardViewController: UIViewController, ISMStreamUIAppearanceProvider {
    
    // MARK: - PROPERTIES
    
    var selectedCoin: ((Int) -> ())?
    var bottomConstraints: NSLayoutConstraint?
    
    lazy var headerIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = appearance.images.premiumBadgeBG
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Premium Broadcast"
        label.textAlignment = .center
        label.textColor = .white
        label.font = appearance.font.getFont(forTypo: .h5)
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Set coins you want to get from your fans"
        label.textColor = appearance.colors.appLightGray.withAlphaComponent(0.7)
        label.font = appearance.font.getFont(forTypo: .h6)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Custom Coin TextField
    
    lazy var coinTextView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = appearance.colors.appLightGray.withAlphaComponent(0.3)
        view.layer.borderColor = appearance.colors.appLightGray.withAlphaComponent(0.5).cgColor
        view.layer.borderWidth = 1.5
        view.layer.cornerRadius = 5
        return view
    }()
    
    lazy var coinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = appearance.images.coin
        return imageView
    }()
    
    lazy var coinTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tintColor = .white
        textField.textColor = .white
        textField.font = appearance.font.getFont(forTypo: .h6)
        textField.keyboardType = .phonePad
        return textField
    }()
    
    //:
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save", for: .normal)
        button.setTitleColor(appearance.colors.appSecondary, for: .normal)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h5)
        button.backgroundColor = appearance.colors.appColor
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - MAIN
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        addObservers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        removeObservers()
    }
    
    // MARK: - FUNCTIONS
    
    func setupViews(){
        view.backgroundColor = appearance.colors.appDarkGray
        view.addSubview(headerIconView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        
        view.addSubview(coinTextView)
        coinTextView.addSubview(coinImageView)
        coinTextView.addSubview(coinTextField)
        
        view.addSubview(saveButton)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            headerIconView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerIconView.heightAnchor.constraint(equalToConstant: 120),
            headerIconView.widthAnchor.constraint(equalToConstant: 120),
            headerIconView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: headerIconView.bottomAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            coinTextView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
            coinTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            coinTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            coinTextView.heightAnchor.constraint(equalToConstant: 50),
            
            coinImageView.leadingAnchor.constraint(equalTo: coinTextView.leadingAnchor, constant: 10),
            coinImageView.centerYAnchor.constraint(equalTo: coinTextView.centerYAnchor),
            coinImageView.widthAnchor.constraint(equalToConstant: 30),
            coinImageView.heightAnchor.constraint(equalToConstant: 30),
            
            coinTextField.leadingAnchor.constraint(equalTo: coinImageView.trailingAnchor, constant: 10),
            coinTextField.trailingAnchor.constraint(equalTo: coinTextView.trailingAnchor, constant: -5),
            coinTextField.centerYAnchor.constraint(equalTo: coinTextView.centerYAnchor),
            
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
        
        bottomConstraints = NSLayoutConstraint(item: saveButton, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraints!)
    }
    
    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification) , name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification) , name: UIResponder.keyboardWillHideNotification , object: nil)
    }
    
    func removeObservers(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    // MARK: - ACTIONS
    
    @objc func saveButtonTapped(){
        self.dismiss(animated: true)
        let coins = Int(coinTextField.text ?? "0") ?? 0
        self.selectedCoin?(coins)
    }
    
    @objc func handleKeyboardNotification(notification: NSNotification){
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            
            bottomConstraints?.constant = isKeyboardShowing ? -(keyboardHeight + 10) : -(ism_windowConstant.getBottomPadding + 20)
            
            UIView.animate(withDuration:0.2, delay: 0 , options: .curveEaseOut , animations: {
                self.view.layoutIfNeeded()
            } , completion: {(completed) in
            })
        }
    }

}
