//
//  PkChallengeViewModel.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 12/12/22.
//  Copyright © 2022 Rahul Sharma. All rights reserved.
//

import UIKit

struct PKChallengeDuration {
    let duration : Int
    let title: String
}

class PkChallengeViewModel: NSObject {
    
    var challengeDuration: [PKChallengeDuration]?
    var selectedIndex: IndexPath = IndexPath(row: 0, section: 0)
    
    var startPK_CallBack: ((String?) -> ())?
    
    func setDefaultChallengeDuration() {
        self.challengeDuration = [
            PKChallengeDuration(duration: 1, title: "1 min"),
            PKChallengeDuration(duration: 3, title: "3 min"),
            PKChallengeDuration(duration: 5, title: "5 min"),
            PKChallengeDuration(duration: 10, title: "10 min"),
        ]
    }
    
}
