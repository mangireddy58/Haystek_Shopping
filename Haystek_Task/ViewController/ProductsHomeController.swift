//
//  ViewController.swift
//  Haystek_Task
//
//  Created by MangiReddy on 01/04/25.
//

import UIKit

class ProductsHomeController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var productsView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var buttonHeader: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var categoriesAllBtn: UIButton!
    @IBOutlet weak var saleAllBtn: UIButton!
    @IBOutlet weak var couponBtn: UIButton!
    @IBOutlet weak var notifBtn: UIButton!
    @IBOutlet weak var headerBtn: UIButton!
    
    private var viewModel = ProductViewModel()
    var remainingTime: Int = 18000
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.shared.requestLocationPermission()
        LocationManager.shared.startUpdatingLocation()
        LocationManager.shared.addressUpdateHandler = { [weak self] address in
            DispatchQueue.main.async {
                self?.addressLabel.text = address
            }
        }
        self.setUpCollectionViewLayout()
        
        viewModel.fetchProducts()
        
        viewModel.onDataFetched = { [weak self] in
            self?.categoriesCollectionView.reloadData()
            self?.productsCollectionView.reloadData()
            self?.startTimer()
            Loader.shared.hide(from: self!.view)
            self?.updateCartButton()
        }
        viewModel.onError = { [weak self] errorMessage in
            self?.showError(errorMessage)
            Loader.shared.hide(from: self!.view)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.headerView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 15)
        self.productsView.setCornerRadius(15.0)
        self.buttonHeader.setCornerRadius(5.0)
        productsCollectionView.reloadData()
    }
    func formatTime(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, remainingSeconds)
    }
    @objc func cartButtonTapped() {
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 2
            if let cartVC = tabBarController.viewControllers?[2] as? CartController {
                cartVC.cartTableView.reloadData()
            }
        }
    }
    
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    @objc func updateTimer() {
        remainingTime -= 1
        timerLabel.text = formatTime(seconds: remainingTime)
        if remainingTime <= 0 {
            stopTimer()
            timerLabel.text = "00:00:00"
        }
    }
    
    // MARK: - Collection View DataSource & Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == productsCollectionView{
            return viewModel.products.count
        }else{
            return viewModel.categories.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == productsCollectionView {
            var cell: UICollectionViewCell!
            if collectionView == productsCollectionView {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: customCells.productCell, for: indexPath) as! ProductCell
                
                let product = viewModel.products[indexPath.item]
                (cell as! ProductCell).configureCell(with: product)
                (cell as! ProductCell).favouriteBtn.tag = indexPath.item
                (cell as! ProductCell).viewModel = viewModel
                
                (cell as! ProductCell).heartButtonAction = {
                    self.updateCartButton()
                }
            } else {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: customCells.defaultCell, for: indexPath) as! CustomImagesCell
                let category = viewModel.categories[indexPath.item]
                (cell as! CustomImagesCell).viewModel = viewModel
                (cell as! CustomImagesCell).category(with: category)
            }
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CustomImagesCell else {
                return UICollectionViewCell()
            }
            
            let category = viewModel.categories[indexPath.item]
            cell.viewModel = viewModel
            cell.category(with: category)
            
            return cell
        }
    }
    
    
    
    // MARK: - Collection View Delegate & Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = viewModel.products[indexPath.item]
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 1
            if let secondTabVC = tabBarController.viewControllers?[1] as? ProductsDetailsController {
                secondTabVC.product = product
                secondTabVC.viewDidLoad()
            }
        }
    }
    func updateCartBadge() {
        let cartCount = viewModel.cartItemCount()
        let tabBarController = self.tabBarController
        tabBarController?.tabBar.items?[2].badgeValue = cartCount > 0 ? "\(cartCount)" : nil
    }
    
    public func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    func updateCartButton() {
        let cartCount = viewModel.cartItemCount()
        if let tabBarController = self.tabBarController {
            let cartTabItem = tabBarController.tabBar.items?[2]
            cartTabItem?.badgeValue = cartCount > 0 ? "\(cartCount)" : nil
        }
    }
    func setUpCollectionViewLayout(){
        
        let text1 = "Delivery is "
        let text = "  50%  "
        let text2 = " cheaper"
        let attributedString1 = NSMutableAttributedString(string: text1)
        let attributedString = NSMutableAttributedString(string: text)
        let attributedString2 = NSMutableAttributedString(string: text2)
        attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(.backgroundColor, value: UIColor.white, range: NSRange(location: 0, length: text.count))
        let finalString = NSMutableAttributedString()
        finalString.append(attributedString1)
        finalString.append(attributedString)
        finalString.append(attributedString2)
        self.buttonHeader.setAttributedTitle(finalString, for: .normal)
        
        headerBtn.applyCardStyle(cornerRadius: 15.0, shadowColor: .gray, shadowOpacity: 0.5, shadowOffset: CGSize(width: 0, height: 3), shadowRadius: 10.0)
        
        self.timerLabel.text = formatTime(seconds: remainingTime)
        Loader.shared.show(in: self.view, message: "Fetching Data...")
        self.tabBarController?.delegate = self
        let cartButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(cartButtonTapped))
        self.navigationItem.rightBarButtonItem = cartButton
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = -35
        flowLayout.minimumInteritemSpacing = -10
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        let numberOfColumns: CGFloat = 2
        let spacing: CGFloat = 10
        let totalSpacing = (numberOfColumns - 1) * spacing
        let width = (productsCollectionView.frame.width - totalSpacing) / numberOfColumns
        flowLayout.itemSize = CGSize(width: width, height: 250)
        
        productsCollectionView.collectionViewLayout = flowLayout
    }
}
extension ProductsHomeController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let selectedVC = viewController as? CartController {
            selectedVC.cartTableView.reloadData()
        }
    }
}
