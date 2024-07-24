//
//  GoLiveOptionsContentView.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 07/09/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

protocol LiveOptionsActionDelegate {
    func didToggleOptionTapped(withStreamOption: StreamOptionToggle)
    func didRTMPURLCopied()
    func didStreamKeyCopied()
    func didHelpLabelViewTapped()
    func didRestreamTapped()
    func didTapAddProduct()
    func didRemoveProduct(index: Int)
    func didDateTimeSelectorTapped()
    func didActionButtonTapped(with actionType: GoLivePremiumActionType)
}

extension LiveOptionsActionDelegate {
    func didRTMPURLCopied(){}
    func didStreamKeyCopied(){}
    func didHelpLabelViewTapped(){}
    func didRestreamTapped(){}
    func didTapAddProduct(){}
}

class GoLiveOptionsContentView: UIView {

    // MARK: - PROPERTIES
    
    var delegate: LiveOptionsActionDelegate?
    
    lazy var goLiveContentContainerView: GoLiveContentContainerView = {
        let view = GoLiveContentContainerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    // MARK: - MAIN
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        manageTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - FUNCTIONS
    
    func setupViews(){
        addSubview(goLiveContentContainerView)
    }
    
    func setupConstraints(){
        goLiveContentContainerView.ism_pin(to: self)
    }
    
    func manageTargets(){
        
        goLiveContentContainerView.rtmpURLView.formTextView.copyButton.addTarget(self, action: #selector(rtmpURlCopied), for: .touchUpInside)
        
        goLiveContentContainerView.streamKeyView.formTextView.copyButton.addTarget(self, action: #selector(streamKeyCopied), for: .touchUpInside)
        
        goLiveContentContainerView.helpLabelView.actionButton.addTarget(self, action: #selector(helpLabelViewTapped), for: .touchUpInside)
        
        goLiveContentContainerView.restreamOption.actionButton.addTarget(self, action: #selector(restreamTapped), for: .touchUpInside)
        
        goLiveContentContainerView.addProductView.addButton.addTarget(self, action: #selector(addProductTapped), for: .touchUpInside)
        
        goLiveContentContainerView.addProductView.delegate = self
        
    }
    
    // MARK: - ACTIONS
    
    @objc func rtmpURlCopied(){
        delegate?.didRTMPURLCopied()
    }
    
    @objc func streamKeyCopied() {
        delegate?.didStreamKeyCopied()
    }
    
    @objc func helpLabelViewTapped() {
        delegate?.didHelpLabelViewTapped()
    }
    
    @objc func restreamTapped() {
        delegate?.didRestreamTapped()
    }
    
    @objc func addProductTapped(){
        delegate?.didTapAddProduct()
    }

}

extension GoLiveOptionsContentView: LiveOptionsActionDelegate, GoLiveAddProductActionDelegate {
    
    func didActionButtonTapped(with actionType: GoLivePremiumActionType) {
        delegate?.didActionButtonTapped(with: actionType)
    }
    
    
    func didDateTimeSelectorTapped() {
        delegate?.didDateTimeSelectorTapped()
    }
    
    func didRemoveProduct(index: Int) {}
    
    func didToggleOptionTapped(withStreamOption: StreamOptionToggle) {
        delegate?.didToggleOptionTapped(withStreamOption: withStreamOption)
    }
    
    func didAddProductTapped() {
        delegate?.didTapAddProduct()
    }
    
    func didRemoveProductTapped(index: Int) {
        delegate?.didRemoveProduct(index: index)
    }
    
}
