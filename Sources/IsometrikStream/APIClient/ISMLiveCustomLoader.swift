//
//  ISMLiveCustomLoader.swift
//  PicoAdda
//
//  Created by Rahul Sharma on 27/11/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

class ISMLiveCustomIndicatorView: UIView {
    
    private let activityIndicatorView: UIActivityIndicatorView
    
    init() {
        activityIndicatorView = UIActivityIndicatorView(style: .large)
        super.init(frame: .zero)
        
        backgroundColor = UIColor(white: 0, alpha: 0.5)
        addSubview(activityIndicatorView)
        
        // Customize the appearance of your indicator view here
        activityIndicatorView.color = .white
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimating() {
        activityIndicatorView.startAnimating()
    }
    
    func stopAnimating() {
        activityIndicatorView.stopAnimating()
    }
}


public class ISMLiveShowLoader {
    
    
    public static let shared = ISMLiveShowLoader()
    
    private var customAPIIndicatorView: ISMLiveCustomIndicatorView?
    private var topMostViewController: UIViewController?
    
    init(){
        self.updateTopMostController()
        customAPIIndicatorView = ISMLiveCustomIndicatorView()
        customAPIIndicatorView?.frame = topMostViewController?.view.bounds ?? .zero
        customAPIIndicatorView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        topMostViewController?.view.addSubview(customAPIIndicatorView!)
        
    }
    
    
    // To start the indicator
    public func startLoading() {
        DispatchQueue.main.async {
            self.updateTopMostController()
            self.customAPIIndicatorView?.startAnimating()
            self.topMostViewController?.view.addSubview(self.customAPIIndicatorView!)
        }
        
    }
    
    // To stop the indicator
    public func stopLoading() {
        DispatchQueue.main.async {
            self.customAPIIndicatorView?.stopAnimating()
            self.customAPIIndicatorView?.removeFromSuperview()
        }
    }
    
    
    public func updateTopMostController(){
        
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            self.topMostViewController = rootViewController
        }
        
        while let presentedViewController = topMostViewController?.presentedViewController {
            self.topMostViewController =  presentedViewController
        }
        
    }
    
}
