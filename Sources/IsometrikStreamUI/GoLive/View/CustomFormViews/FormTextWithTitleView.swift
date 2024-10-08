//
//  FormTextWithTitleView.swift
//  PicoAdda
//
//  Created by Dheeraj Kumar Sharma on 08/09/23.
//  Copyright © 2023 Rahul Sharma. All rights reserved.
//

import UIKit

public class FormTextWithTitleView: UIView, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    
    public lazy var formTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Form Title Text".localized
        label.font = appearance.font.getFont(forTypo: .h6)
        label.textColor = .white
        return label
    }()
    
    public let formTextView: FormTextView = {
        let view = FormTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public lazy var infoTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = appearance.font.getFont(forTypo: .h9)
        label.textColor = .black
        label.isHidden = true
        return label
    }()
    
    // MARK: - MAIN
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - FUNCTIONS
    
    func setupViews(){
        addSubview(formTitleLabel)
        addSubview(formTextView)
        addSubview(infoTextLabel)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            formTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            formTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 3),
            formTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            formTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            formTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            formTextView.heightAnchor.constraint(equalToConstant: 45),
            formTextView.topAnchor.constraint(equalTo: formTitleLabel.bottomAnchor, constant: 5),
            
            infoTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            infoTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            infoTextLabel.topAnchor.constraint(equalTo: formTextView.bottomAnchor, constant: 4)
        ])
    }

}
