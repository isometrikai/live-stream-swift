import UIKit
import IsometrikStream

class StreamerDefaultProfileViewController: UIViewController, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    
    let profilePicture: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var defaultProfile: CustomDefaultProfileView = {
        let view = CustomDefaultProfileView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.initialsText.font = appearance.font.getFont(forTypo: .h3)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.font = appearance.font.getFont(forTypo: .h4)
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = appearance.colors.appLightGray
        label.font = appearance.font.getFont(forTypo: .h6)
        return label
    }()
    
    // MARK: MAIN -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
            self.profilePicture.layer.cornerRadius = (self.view.frame.width * 0.3) / 2
            self.defaultProfile.layer.cornerRadius = (self.view.frame.width * 0.3) / 2
        }
    }
    
    // MARK: FUNCTIONS -
    
    func setUpViews(){
        view.backgroundColor = appearance.colors.appDarkGray
        view.addSubview(defaultProfile)
        view.addSubview(profilePicture)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            defaultProfile.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            defaultProfile.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            defaultProfile.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            defaultProfile.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            
            profilePicture.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profilePicture.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            profilePicture.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            profilePicture.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            titleLabel.topAnchor.constraint(equalTo: defaultProfile.bottomAnchor, constant: 30),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5)
        ])
    }
    
    func configureData(userData: ISMMember?){
        
        guard let userData else { return }
        
        let firstName = userData.metaData?.firstName ?? ""
        let lastName = userData.metaData?.lastName ?? ""
        let userName = userData.metaData?.userName ?? userData.userName.unwrap
        
        if !firstName.isEmpty && lastName.isEmpty {
            titleLabel.text = "\(firstName) \(lastName)"
            subtitleLabel.text = "\(userName)"
        } else {
            titleLabel.text = "\(userName)"
            subtitleLabel.text = ""
        }
        
        let profileImage = userData.userProfileImageURL.unwrap
        
        if !profileImage.isEmpty && profileImage != UserDefaultsProvider.shared.getIsometrikDefaultProfile(), let imageUrl = URL(string: profileImage) {
            profilePicture.kf.setImage(with: imageUrl)
        } else {
            profilePicture.image = UIImage()
        }
        
        if !firstName.isEmpty && !lastName.isEmpty {
            defaultProfile.initialsText.text = "\(firstName.prefix(1))\(lastName.prefix(1))".uppercased()
        } else {
            defaultProfile.initialsText.text = "\(userData.userName?.prefix(2) ?? "--")".uppercased()
        }
        
    }


}
