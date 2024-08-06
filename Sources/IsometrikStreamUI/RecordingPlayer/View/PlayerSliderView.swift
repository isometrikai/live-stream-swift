//
//  PlayerSliderView.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 26/09/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

protocol PlayerSliderActionDelegate {
    func didScrub(_ playbackSlider:UISlider, event: UIEvent)
}

class PlayerSliderView: UIView, ISMAppearanceProvider {

    // MARK: PROPERTIES -
    
    var delegate: PlayerSliderActionDelegate?
    
    lazy var playerSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = appearance.colors.appColor
        slider.maximumTrackTintColor = .white.withAlphaComponent(0.5)
        slider.addTarget(self, action: #selector(playerScrub(_:_:)), for: .valueChanged)
        return slider
    }()
    
    let playerTimerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        label.textColor = .white
        label.font = .monospacedDigitSystemFont(ofSize: 10, weight: .semibold)
        return label
    }()
    
    // MARK: MAIN -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: FUNCTIONS -
    
    func setUpViews(){
        addSubview(playerSlider)
        addSubview(playerTimerLabel)
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            playerTimerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            playerTimerLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            playerTimerLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 100),
            
            playerSlider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            playerSlider.trailingAnchor.constraint(equalTo: playerTimerLabel.leadingAnchor, constant: -10),
            playerSlider.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    // MARK: - ACTIONS
    
    @objc func playerScrub(_ slider: UISlider, _ event: UIEvent) {
        delegate?.didScrub(slider, event: event)
    }

}
