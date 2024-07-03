//
//  ISMUIViewController+Extension.swift
//  SOLD
//
//  Created by Dheeraj Kumar Sharma on 29/08/23.
//  Copyright © 2023 rahulSharma. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func ism_hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.ism_dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func ism_dismissKeyboard() {
        view.endEditing(true)
    }
    
    func ism_add(_ child: UIViewController, frame: CGRect? = nil) {
        addChild(child)

        if let frame = frame {
            child.view.frame = frame
        }

        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func ism_remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    public func ism_showAlert(_ title: String, message: String) {
        
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
            // do something like...
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func dismissViewController(){
        guard let window = self.view.window else { return }
        window.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
}


