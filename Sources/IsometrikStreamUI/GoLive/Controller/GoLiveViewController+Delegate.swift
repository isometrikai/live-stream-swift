//
//  GoLiveViewController+Delegate.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 07/09/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

extension GoLiveViewController: UIScrollViewDelegate {

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
}

