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
    
    lazy var rtmpOptionsContainerView: RTMPOptionsContainerView = {
        let view = RTMPOptionsContainerView()
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
        addSubview(rtmpOptionsContainerView)
    }
    
    func setupConstraints(){
        rtmpOptionsContainerView.pin(to: self)
    }
    
    func manageTargets(){
        
        rtmpOptionsContainerView.rtmpURLView.formTextView.copyButton.addTarget(self, action: #selector(rtmpURlCopied), for: .touchUpInside)
        
        rtmpOptionsContainerView.streamKeyView.formTextView.copyButton.addTarget(self, action: #selector(streamKeyCopied), for: .touchUpInside)
        
        rtmpOptionsContainerView.helpLabelView.actionButton.addTarget(self, action: #selector(helpLabelViewTapped), for: .touchUpInside)
        
        rtmpOptionsContainerView.restreamOption.actionButton.addTarget(self, action: #selector(restreamTapped), for: .touchUpInside)
        
        rtmpOptionsContainerView.addProductView.addButton.addTarget(self, action: #selector(addProductTapped), for: .touchUpInside)
        
        rtmpOptionsContainerView.addProductView.delegate = self
        
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
