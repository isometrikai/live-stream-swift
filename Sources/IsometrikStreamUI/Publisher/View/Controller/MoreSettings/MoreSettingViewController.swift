
import UIKit
import IsometrikStream

protocol MoreSettingActionDelegate {
    func didOptionTapped(for type: StreamSettingType?, session: VideoSession?, index: Int)
}

class MoreSettingViewController: UIViewController, ISMAppearanceProvider {

    // MARK: - PROPERTIES
    
    var session: VideoSession
    var selectedIndex: Int
    
    var settingsData: [StreamSettingData]? {
        didSet {
            self.settingsOptionTableView.reloadData()
        }
    }
    
    var delegate: MoreSettingActionDelegate?
    
    lazy var settingsOptionTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MoreSettingTableViewCell.self, forCellReuseIdentifier: "MoreSettingTableViewCell")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()
    
    // MARK: - MAIN
    
    init(session: VideoSession, selectedIndex: Int) {
        self.session = session
        self.selectedIndex = selectedIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = appearance.colors.appDarkGray
        setupViews()
        setupConstraints()
    }
    
    // MARK: - FUNTIONS
    
    func setupViews(){
        view.addSubview(settingsOptionTableView)
    }
    
    func setupConstraints(){
        settingsOptionTableView.ism_pin(to: view)
    }

}

extension MoreSettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let settingsData = settingsData else { return Int() }
        return settingsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let settingsData = settingsData else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoreSettingTableViewCell", for: indexPath) as! MoreSettingTableViewCell
        cell.data = settingsData[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let settingData = settingsData?[indexPath.row] else { return }
        delegate?.didOptionTapped(for: settingData.streamSettingType, session: session, index: selectedIndex)
        self.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? MoreSettingTableViewCell {
            UIView.animate(withDuration: 0.2) {
                cell.contentView.backgroundColor = .white.withAlphaComponent(0.2)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? MoreSettingTableViewCell {
            UIView.animate(withDuration: 0.2) {
                cell.contentView.backgroundColor = .clear
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    
    
}
