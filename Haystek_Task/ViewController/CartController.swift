//
//  CartController.swift
//  Haystek_Task
//
//  Created by MangiReddy on 01/04/25.
//

import UIKit

class CartController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var addressBtn: UIButton!
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var cartLocView: UIView!
    @IBOutlet weak var productview: UIView!
    @IBOutlet weak var productLocview: UIView!
    @IBOutlet weak var productBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.shared.requestLocationPermission()
        LocationManager.shared.startUpdatingLocation()
        if let address = LocationManager.shared.currentAddress {
            self.addressBtn.setTitle(address, for: .normal)
        }
        LocationManager.shared.addressUpdateHandler = { [weak self] address in
            DispatchQueue.main.async {
                self?.addressBtn.setTitle(address, for: .normal)
            }
        }
        productLocview.applyCardStyle(cornerRadius: 15.0, shadowColor: .gray, shadowOpacity: 0.5, shadowOffset: CGSize(width: 0, height: 3), shadowRadius: 10.0)
        
        cartTableView.register(UINib(nibName: customCells.productCartCell, bundle: nil), forCellReuseIdentifier: customCells.productCartCell)
        cartTableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.cartLocView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
        self.productview.roundCorners(corners: [.topLeft, .topRight], radius: 10)
    }
    @IBAction func checkoutBtnTapped(_ sender: UIButton) {
        self.presentThankYouPopup()
    }
    
    func presentThankYouPopup() {
        let alertController = UIAlertController(title: "Thank You!", message: "We appreciate your feedback.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            Cart.shared.cartItems.removeAll()
            self.cartTableView.reloadData()
            if let tabBarController = self.tabBarController {
                tabBarController.selectedIndex = 0
            }
            if let tabBarController = self.tabBarController {
                let cartTabItem = tabBarController.tabBar.items?[2]
                cartTabItem?.badgeValue = ""
            }
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - TableView DataSource & Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Cart.shared.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: customCells.productCartCell, for: indexPath) as! ProductCartCell
        let cartItem = Cart.shared.cartItems[indexPath.row]
        cell.loadData(cartItem)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
}
