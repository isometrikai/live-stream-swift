//
//  StreamContainerView.swift
//  Yelo
//
//  Created by Dheeraj Kumar Sharma on 07/08/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit

class StreamContainerView: UIView {

    // MARK: - PROPERTIES
    
    var footerBottomConstraint: NSLayoutConstraint?
    
    var streamMessageViewConstraint: NSLayoutConstraint?
    var streamMessageTrailingConstraints: NSLayoutConstraint?
    
    var bottomGradientBottomAnchor: NSLayoutConstraint?
    var streamingInfoMessageViewHeightConstraints: NSLayoutConstraint?
    var streamingEventUpdateMessageViewHeightConstraints: NSLayoutConstraint?
    var streamOptionViewBottomConstraints: NSLayoutConstraint?
    
    let dismissButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    let streamHeaderView: StreamHeaderView = {
        let view = StreamHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let disclaimerView: DisclaimerView = {
        let view = DisclaimerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let streamGiftMessageView: StreamGiftMessageContainerView = {
        let view = StreamGiftMessageContainerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let streamMessageView: StreamMessageContainer = {
        let view = StreamMessageContainer()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let streamEventUpdateInfoMessageView: StreamEventUpdateInfoMessageView = {
        let view = StreamEventUpdateInfoMessageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    let streamInfoMessageView: StreamingInfoMessageView = {
        let view = StreamingInfoMessageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let streamAnimationPopup: StreamAnimationPopupView = {
        let view = StreamAnimationPopupView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let streamFooterView: StreamFooterView = {
        let footerView = StreamFooterView()
        footerView.translatesAutoresizingMaskIntoConstraints = false
        return footerView
    }()
    
    let topGradientView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bottomGradientView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var streamOptionsView: StreamOptionsView = {
        let view = StreamOptionsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var streamItemPinnedView: StreamPinnedItemView = {
        let view = StreamPinnedItemView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.dropShadow(color: .red, opacity: 1, offSet: CGSize(width: 0, height: 2))
        return view
    }()
    
    let videoContainer: CustomVideoContainer = {
        let container = CustomVideoContainer()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    let giftAnimationCoverView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    // MARK: - MAIN
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        addObservers()
        defaults()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeObservers()
    }
    
    // MARK: - FUNCTIONS
    
    func setupViews(){
        addSubview(videoContainer)
        addSubview(topGradientView)
        addSubview(bottomGradientView)
        
        addSubview(dismissButton)
        
        addSubview(streamOptionsView)
        addSubview(streamItemPinnedView)
        addSubview(streamHeaderView)
        
        addSubview(streamGiftMessageView)
        addSubview(streamMessageView)
        addSubview(streamEventUpdateInfoMessageView)
        addSubview(streamInfoMessageView)
        addSubview(disclaimerView)
        
        addSubview(streamAnimationPopup)
        addSubview(streamFooterView)
        addSubview(giftAnimationCoverView)
    }
    
    func setupConstraints(){
        dismissButton.ism_pin(to: self)
        streamAnimationPopup.ism_pin(to: self)
        videoContainer.ism_pin(to: self)
        giftAnimationCoverView.ism_pin(to: self)
        NSLayoutConstraint.activate([
            streamHeaderView.leadingAnchor.constraint(equalTo: leadingAnchor),
            streamHeaderView.trailingAnchor.constraint(equalTo: trailingAnchor),
            streamHeaderView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            streamHeaderView.heightAnchor.constraint(equalToConstant: 90),
            
            streamGiftMessageView.bottomAnchor.constraint(equalTo: streamMessageView.topAnchor, constant: -10),
            streamGiftMessageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6),
            streamGiftMessageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            streamGiftMessageView.heightAnchor.constraint(equalToConstant: 90),
            
            streamMessageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            streamMessageView.trailingAnchor.constraint(equalTo: streamItemPinnedView.leadingAnchor, constant: -10),
            streamMessageView.bottomAnchor.constraint(equalTo: streamEventUpdateInfoMessageView.topAnchor, constant: -5),
            
            streamEventUpdateInfoMessageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            streamEventUpdateInfoMessageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.65),
            streamEventUpdateInfoMessageView.bottomAnchor.constraint(equalTo: streamInfoMessageView.topAnchor, constant: -5),
            
            streamInfoMessageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            streamInfoMessageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.65),
            streamInfoMessageView.bottomAnchor.constraint(equalTo: streamFooterView.topAnchor, constant: -5),
            
            streamFooterView.leadingAnchor.constraint(equalTo: leadingAnchor),
            streamFooterView.trailingAnchor.constraint(equalTo: trailingAnchor),
            streamFooterView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -ism_windowConstant.getBottomPadding),
            streamFooterView.heightAnchor.constraint(equalToConstant: 60),
            
            topGradientView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topGradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topGradientView.topAnchor.constraint(equalTo: topAnchor),
            topGradientView.heightAnchor.constraint(equalToConstant: ism_windowConstant.getTopPadding + 90),
            
            bottomGradientView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomGradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomGradientView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomGradientView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.40),
            
            streamOptionsView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            streamOptionsView.widthAnchor.constraint(equalToConstant: 45),
            
            streamItemPinnedView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            streamItemPinnedView.widthAnchor.constraint(equalToConstant: 160),
            streamItemPinnedView.heightAnchor.constraint(equalToConstant: 220),
            streamItemPinnedView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -(50 + ism_windowConstant.getBottomPadding)),
            
            disclaimerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            disclaimerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            disclaimerView.bottomAnchor.constraint(equalTo: streamFooterView.topAnchor, constant: -30)
        ])
        
        bottomGradientBottomAnchor = NSLayoutConstraint(item: bottomGradientView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        addConstraint(bottomGradientBottomAnchor!)
        
        footerBottomConstraint = NSLayoutConstraint(item: streamFooterView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        addConstraint(footerBottomConstraint!)
        
        streamMessageViewConstraint = streamMessageView.heightAnchor.constraint(equalToConstant: 250)
        streamMessageViewConstraint?.isActive = true
        
        streamMessageTrailingConstraints = streamMessageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -80)
        streamMessageTrailingConstraints?.isActive = true
        
        streamingInfoMessageViewHeightConstraints = streamInfoMessageView.heightAnchor.constraint(equalToConstant: 0)
        streamingInfoMessageViewHeightConstraints?.isActive = true
        
        streamingEventUpdateMessageViewHeightConstraints = streamEventUpdateInfoMessageView.heightAnchor.constraint(equalToConstant: 0)
        streamingEventUpdateMessageViewHeightConstraints?.isActive = true
        
        streamOptionViewBottomConstraints = streamOptionsView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -(50 + ism_windowConstant.getBottomPadding + 30))
        // For normal stream : -(50 + windowConstant.getBottomPadding + 250)
        // For schedule stream : -(50 + windowConstant.getBottomPadding + 30)
        streamOptionViewBottomConstraints?.isActive = true
        
    }
    
    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification) , name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification) , name: UIResponder.keyboardWillHideNotification , object: nil)
    }
    
    func removeObservers(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func defaults(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            topGradientView.setGradient(withColors: [UIColor.black.withAlphaComponent(0.7).cgColor, UIColor.clear.cgColor], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 0, y: 1))
            
            bottomGradientView.setGradient(withColors: [UIColor.black.withAlphaComponent(0.85).cgColor, UIColor.clear.cgColor], startPoint: CGPoint(x: 0, y: 1), endPoint: CGPoint(x: 0, y: 0))
        }
    }
    
    

}

extension StreamContainerView {
    
    @objc func handleKeyboardNotification(notification: NSNotification){
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            
            self.dismissButton.isHidden = !isKeyboardShowing
            
            footerBottomConstraint?.constant = isKeyboardShowing ? -keyboardHeight : -ism_windowConstant.getBottomPadding
            
            bottomGradientBottomAnchor?.constant = isKeyboardShowing ? -keyboardHeight : 0
            
            UIView.animate(withDuration:0.2, delay: 0 , options: .curveEaseOut , animations: {
                self.layoutIfNeeded()
            } , completion: {(completed) in
            })
        }
    }
    
}
