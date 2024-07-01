//
//  StreamReportTableViewCell.swift
//  Shopr
//
//  Created by Appscrip 3Embed on 03/01/24.
//  Copyright © 2024 Rahul Sharma. All rights reserved.
//

import UIKit

class StreamReportTableViewCell: UITableViewCell, AppearanceProvider {

    // MARK: - PROPERTIES
    
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
        view.layer.cornerRadius = 5
        return view
    }()
    
    lazy var reasonLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = appearance.font.getFont(forTypo: .h6)
        return label
    }()
    
    
    // MARK: MAIN -
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: FUNCTIONS -
    
    func setupViews(){
        addSubview(cardView)
        cardView.addSubview(reasonLabel)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            cardView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            cardView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            
            reasonLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            reasonLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10),
            reasonLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor)
            
        ])
    }

}
