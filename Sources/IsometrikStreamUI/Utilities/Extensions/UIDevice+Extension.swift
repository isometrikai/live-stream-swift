//
//  UIDevice+Extension.swift
//  Shopr
//
//  Created by Appscrip 3Embed on 11/01/24.
//  Copyright © 2024 Rahul Sharma. All rights reserved.
//

import UIKit
import AVKit

extension UIDevice {
    public static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
