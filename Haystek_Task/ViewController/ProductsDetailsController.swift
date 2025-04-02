//
//  ProductsDetailsController.swift
//  Haystek_Task
//
//  Created by MangiReddy on 01/04/25.
//

import UIKit

class ProductsDetailsController: UIViewController {
    
    @IBOutlet weak var imagePages: UIPageControl!
    @IBOutlet weak var imageScroll: UIImageView!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var reviewLbl: UILabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var likesView: UIView!
    @IBOutlet weak var commentsView: UIView!
    @IBOutlet weak var priceView: UIView!
    var product: Products?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableViewDataLayout()
    }
    @IBAction func backBtnTapped(_ sender: UIButton) {
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 0
        }
    }
    
    func setUpTableViewDataLayout(){
        let imageUrlString = product?.image
        if let cachedImage = ImageCache.shared.getImage(forKey: imageUrlString ?? "") {
            imageScroll.image = cachedImage
        } else {
            DispatchQueue.global().async {
                if let url = URL(string: imageUrlString ?? ""), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    ImageCache.shared.saveImage(image, forKey: imageUrlString ?? "")
                    DispatchQueue.main.async {
                        self.imageScroll.image = image
                    }
                }
            }
        }
        
        favouriteButton.setImage(xImage, for: .normal)
        Cart.shared.cartItems.forEach { item in
            if item.id == product?.id {
                favouriteButton.setImage(yImage, for: .normal)
            }
        }
        titleLbl.text = product?.title
        descLbl.text = product?.description
        priceLbl.text = "$\(product?.price ?? 00)"
        countLbl.text = "\(product?.id ?? 0)"
        likesLbl.text = "94%"
        reviewLbl.text = "\(product?.rating.rate ?? 0) \(product?.rating.count ?? 0) reviews"
        likesView.applyCardStyle(cornerRadius: 15.0, shadowColor: .gray, shadowOpacity: 0.5, shadowOffset: CGSize(width: 0, height: 3), shadowRadius: 10.0)
        priceView.applyCardStyle(cornerRadius: 15.0, shadowColor: .gray, shadowOpacity: 0.5, shadowOffset: CGSize(width: 0, height: 3), shadowRadius: 10.0)
        ratingView.applyCardStyle(cornerRadius: 15.0, shadowColor: .gray, shadowOpacity: 0.5, shadowOffset: CGSize(width: 0, height: 3), shadowRadius: 10.0)
        commentsView.applyCardStyle(cornerRadius: 15.0, shadowColor: .gray, shadowOpacity: 0.5, shadowOffset: CGSize(width: 0, height: 3), shadowRadius: 10.0)
    }
}
