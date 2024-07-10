
import UIKit
import IsometrikStream

extension BuyCoinsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.coinPlans.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CoinPlanCollectionViewCell", for: indexPath) as! CoinPlanCollectionViewCell
        let coinPlan = viewModel.coinPlans[indexPath.row]
        cell.configureCell(data: coinPlan)
        cell.backgroundColor = .clear
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let estimatedW = (UIScreen.main.bounds.width - 48) / 3
        return CGSize(width: estimatedW, height: estimatedW + estimatedW * 0.2)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CoinPlanCollectionViewCell {
            UIView.animate(withDuration: 0.3) {
                cell.coverView.transform = .init(scaleX: 0.9, y: 0.9)
            }
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CoinPlanCollectionViewCell {
            UIView.animate(withDuration: 0.3) {
                cell.coverView.transform = .identity
            }
        }
    }
    
}

extension BuyCoinsViewController {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let skProduct = viewModel.skProducts[indexPath.row]
        
        // show loader
        IAPManager.shared.buy(product: skProduct, withHandler: { (result) in
            // hide loader
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.viewModel.purchasePlan { success, error in
                        if success {
                            
                        } else {
                            // show error
                            guard let error else { return }
                            print(error)
                        }
                    }
                }
                
                break
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        })
        
    }
    
}
