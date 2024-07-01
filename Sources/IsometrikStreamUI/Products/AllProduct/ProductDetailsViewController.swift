//
//  ProductDetailsViewController.swift
//  Shopr
//
//  Created by Dheeraj Kumar Sharma on 30/10/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit
import IsometrikStream

class ProductDetailsViewController: UIViewController, UITextFieldDelegate {

    // MARK: - PROPERTIES
    var addButtonBottomConstraint: NSLayoutConstraint?
    
    // For Update Offer scenarios
    
    var productData: StreamProductModel?
    var productViewModel: ProductViewModel?
    var editableDiscountPercentage: Double? {
        didSet {
            guard let editableDiscountPercentage else { return }
            if editableDiscountPercentage == 0 {
                discountPercentage.formTextView.inputTextField.text = ""
            } else {
                discountPercentage.formTextView.inputTextField.text = "\(editableDiscountPercentage)"
            }
            discountedPercentage = editableDiscountPercentage
            addButton.setTitle("Update".localized, for: .normal)
        }
    }
    
    //:
    
    var discountedPercentage: Double?
    var addCallback: ((Double?) -> Void)?
    
    lazy var headerView: CustomHeaderView = {
        let view = CustomHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.headerTitle.text = "Discount Percentage".localized
//        Fonts.setFont(view.headerTitle, fontFamiy: .monstserrat(.Bold), size: .custom(17), color: .black)
        view.headerTitle.textAlignment = .left
        
        view.trailingActionButton.isHidden = false
        view.trailingActionButton.setImage(Appearance.default.images.close.withRenderingMode(.alwaysTemplate), for: .normal)
        view.trailingActionButton.imageView?.tintColor = .black
        view.trailingActionButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        return view
    }()
    
    lazy var discountPercentage: FormTextWithTitleView = {
        
        let view = FormTextWithTitleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.formTitleLabel.text = "Discount Percentage".localized
        view.formTitleLabel.textColor = .black
        
        view.formTextView.copyButton.isHidden = false
        view.formTextView.copyButton.setImage(Appearance.default.images.percentage.withRenderingMode(.alwaysTemplate), for: .normal)
        view.formTextView.copyButton.imageView?.tintColor = .black.withAlphaComponent(0.8)
        
        view.formTextView.customTextLabel.isHidden = true
        view.formTextView.inputTextField.isHidden = false
        view.formTextView.inputTextField.keyboardType = .numberPad
        view.formTextView.inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        view.formTextView.inputTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter Discount Percentage".localized,
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.7),
                NSAttributedString.Key.font: Appearance.default.font.getFont(forTypo: .h6)!
            ]
        )
        view.formTextView.inputTextField.tintColor = .black
        view.formTextView.inputTextField.textColor = .black
        view.formTextView.inputTextField.delegate = self
        view.formTextView.inputTextField.keyboardType = .decimalPad
        view.formTextView.inputTextField.font = Appearance.default.font.getFont(forTypo: .h6)
        
        return view
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        Fonts.setFont(label, fontFamiy: .monstserrat(.Regular), size: .custom(12), color: UIColor.colorWithHex(color: "#EA5C03"))
        label.text = "This discount will be given additionally on the cost price of the products".localized
        label.numberOfLines = 2
        return label
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add".localized, for: .normal)
//        Fonts.setFont(button.titleLabel!, fontFamiy: .monstserrat(.Bold), size: .custom(14), color: .white)
        button.backgroundColor = .black
        button.layer.cornerRadius = 25
        button.ismTapFeedBack()
        button.isEnabled = false
        button.alpha = 0.3
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.style = .medium
        indicator.color = .white
        indicator.isHidden = true
        return indicator
    }()
    
    // MARK: - MAIN
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        observers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        discountedPercentage = nil
        self.textFieldDidChange(discountPercentage.formTextView.inputTextField)
        self.discountPercentage.formTextView.inputTextField.becomeFirstResponder()
    }
    
    // MARK: - FUNCTIONS
    
    func setupViews(){
        view.backgroundColor = .white
        view.addSubview(headerView)
        view.addSubview(discountPercentage)
        view.addSubview(infoLabel)
        view.addSubview(addButton)
        view.addSubview(activityIndicator)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 55),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            discountPercentage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -5),
            discountPercentage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 5),
            discountPercentage.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            discountPercentage.heightAnchor.constraint(equalToConstant: 75),
            
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            infoLabel.topAnchor.constraint(equalTo: discountPercentage.bottomAnchor, constant: 5),
            
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            addButton.heightAnchor.constraint(equalToConstant: 50),
            
            activityIndicator.leadingAnchor.constraint(equalTo: addButton.leadingAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: addButton.trailingAnchor),
            activityIndicator.topAnchor.constraint(equalTo: addButton.topAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: addButton.bottomAnchor)
        ])
        
        addButtonBottomConstraint = NSLayoutConstraint(item: addButton, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(addButtonBottomConstraint!)
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification) , name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification) , name: UIResponder.keyboardWillHideNotification , object: nil)
    }
    
    func showButtonLoader(){
        addButton.setTitle("", for: .normal)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
    }
    
    func hideButtonLoader(){
        addButton.setTitle("Update".localized, for: .normal)
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        self.view.isUserInteractionEnabled = true
    }
    
    // MARK: - ACTIONS
    
    @objc func closeButtonTapped(){
        self.dismiss(animated: true)
    }
    
    @objc func addButtonTapped(){
        
//        if editableDiscountPercentage != nil {
//            guard let productViewModel else { return }
//            
//            // start loading
//            self.showButtonLoader()
//            
//            productViewModel.updateOfferOnProduct(productData: productData, discountPercentage: discountedPercentage ?? 0) { success, error in
//                
//                // stop loading
//                self.hideButtonLoader()
//                if success {
//                    self.addCallback?(self.discountedPercentage ?? 0)
//                    self.dismiss(animated: true)
//                } else {
//                    self.ism_showAlert("Error", message: "\(error)")
//                    self.dismiss(animated: true)
//                }
//            }
//            
//        } else {
//            
//        }
        
        addCallback?(discountedPercentage)
        self.dismiss(animated: true)
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        let percentage = Double(textField.text ?? "0") ?? 0
        
        if percentage == 0 || percentage > 100 {
            discountedPercentage = nil
            addButton.isEnabled = false
            addButton.alpha = 0.3
        } else {
            addButton.isEnabled = true
            addButton.alpha = 1
            discountedPercentage = percentage
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }

        let newText = oldText.replacingCharacters(in: r, with: string)
        let isNumeric = newText.isEmpty || (Double(newText) != nil)
        let numberOfDots = newText.components(separatedBy: ".").count - 1

        let numberOfDecimalDigits: Int
        if let dotIndex = newText.firstIndex(of: ".") {
            numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
        } else {
            numberOfDecimalDigits = 0
        }

        return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
    }
    
    @objc func handleKeyboardNotification(notification: NSNotification){
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            
            addButtonBottomConstraint?.constant = isKeyboardShowing ? -(keyboardHeight + 10) : -(ism_windowConstant.getBottomPadding + 10)
            
            UIView.animate(withDuration: 0.2, delay: 0 , options: .curveEaseOut , animations: {
                self.view.layoutIfNeeded()
            } , completion: {(completed) in
            })
        }
    }

}
