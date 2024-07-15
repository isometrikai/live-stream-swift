import UIKit
import IsometrikStream

class TransactionTypeOptionsHeaderView: UIView, ISMStreamUIAppearanceProvider {
    
    // MARK: - PROPERTIES
    
    let optionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var allTransaction: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("All", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h6)
        button.tag = 1
        return button
    }()
    
    lazy var creditTransaction: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Credit", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h6)
        button.tag = 2
        return button
    }()
    
    lazy var debitTransaction: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Debit", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = appearance.font.getFont(forTypo: .h6)
        button.tag = 3
        return button
    }()
    
    let dividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
        return view
    }()
    
    let indicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
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
        addSubview(optionStackView)
        optionStackView.addArrangedSubview(allTransaction)
        optionStackView.addArrangedSubview(creditTransaction)
        optionStackView.addArrangedSubview(debitTransaction)
        addSubview(dividerView)
        addSubview(indicatorView)
    }
    
    func setUpConstraints(){
        optionStackView.ism_pin(to: self)
        NSLayoutConstraint.activate([
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1.5)
        ])
    }
    
    func respondToActionUpdate(for type: TransactionType){
        
        allTransaction.setTitleColor(.lightGray, for: .normal)
        debitTransaction.setTitleColor(.lightGray, for: .normal)
        creditTransaction.setTitleColor(.lightGray, for: .normal)
        
        allTransaction.titleLabel?.font = appearance.font.getFont(forTypo: .h6)
        debitTransaction.titleLabel?.font = appearance.font.getFont(forTypo: .h6)
        creditTransaction.titleLabel?.font = appearance.font.getFont(forTypo: .h6)
        
        switch type {
        case .debit:
            debitTransaction.setTitleColor(appearance.colors.appSecondary, for: .normal)
            debitTransaction.titleLabel?.font = appearance.font.getFont(forTypo: .h5)
            break
        case .credit:
            creditTransaction.setTitleColor(appearance.colors.appSecondary, for: .normal)
            creditTransaction.titleLabel?.font = appearance.font.getFont(forTypo: .h5)
            break
        case .all:
            allTransaction.setTitleColor(appearance.colors.appSecondary, for: .normal)
            allTransaction.titleLabel?.font = appearance.font.getFont(forTypo: .h5)
        }
        
    }
    
}
