
import UIKit
import SkeletonView

extension WalletTransactionViewController: UITableViewDelegate, SkeletonTableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.transactions.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "WalletTransactionTableViewCell"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletTransactionTableViewCell", for: indexPath) as! WalletTransactionTableViewCell
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let data = viewModel.transactions[indexPath.row]
        cell.configureCell(data: data, currencyType: viewModel.walletCurrencyType)
        
        cell.selectionStyle = .none
        
        // pagination logic
        if indexPath.row == viewModel.transactions.count - 1 {
            if viewModel.canBePaginate() {
                self.loadData()
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}
