//
//  ProductCell.swift
//  TaskPoc
//
//  Created by Prakash's Mac on 09/11/24.
//

import UIKit

class ProductCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productView: UIView!
    @IBOutlet weak var favouriteBtn: UIButton!
    
    var viewModel = ProductViewModel()
    
    var heartButtonAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        favouriteBtn.makeCircular()
        productView.applyCardStyle(cornerRadius: 15.0, shadowColor: .gray, shadowOpacity: 0.5, shadowOffset: CGSize(width: 0, height: 3), shadowRadius: 10.0)
    }
    
    @IBAction func heartButtonTapped(_ sender: UIButton) {
        var found: Bool = false
        var itemIndex: Int = -1
        let productItem = viewModel.products[sender.tag]
        
        Cart.shared.cartItems.enumerated().forEach { index, item in
            if item.id == productItem.id {
                found = true
                itemIndex = index
            }
        }
        if found {
            Cart.shared.cartItems.remove(at: itemIndex)
        } else {
            Cart.shared.cartItems.append(productItem)
        }
        
        var isFavourite: Bool = false
        Cart.shared.cartItems.forEach { item in
            if item.id == productItem.id {
                isFavourite = true
            }
        }
        if isFavourite {
            favouriteBtn.setImage(yImage, for: .normal)
        }
        else {
            favouriteBtn.setImage(xImage, for: .normal)
        }
        heartButtonAction?()
    }
    
    func configureCell(with product: Products) {
        titleLbl.text = product.title
        priceLbl.text = "$\(product.price)"
        ratingLbl.text = "Rating: \(product.rating.rate)"
        self.setPriceWithDiscount(originalPrice: Double(product.rating.count), discountedPrice: product.price, originalLabel: priceLbl, discountedLabel: ratingLbl)
        var found: Bool = false
        Cart.shared.cartItems.forEach { item in
            if item.id == product.id {
                found = true
            }
        }
        
        if found {
            favouriteBtn.setImage(yImage, for: .normal)
        }
        else {
            favouriteBtn.setImage(xImage, for: .normal)
        }
        
        let imageUrlString = product.image
        if let cachedImage = ImageCache.shared.getImage(forKey: imageUrlString) {
            productImg.image = cachedImage
        } else {
            DispatchQueue.global().async {
                if let url = URL(string: imageUrlString), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    ImageCache.shared.saveImage(image, forKey: imageUrlString)
                    DispatchQueue.main.async {
                        self.productImg.image = image
                    }
                }
            }
        }
    }
    func setPriceWithDiscount(originalPrice: Double, discountedPrice: Double, originalLabel: UILabel, discountedLabel: UILabel) {
        let originalPriceText = "$\(originalPrice)"
        let discountedPriceText = "$\(discountedPrice)"
        
        let strikethroughAttributes: [NSAttributedString.Key: Any] = [
            .strikethroughStyle: NSUnderlineStyle.single.rawValue,
            .strikethroughColor: UIColor.red,
            .foregroundColor: UIColor.gray
        ]
        let originalAttributedString = NSAttributedString(string: originalPriceText, attributes: strikethroughAttributes)
        ratingLbl.attributedText = originalAttributedString
        
        priceLbl.text = discountedPriceText
    }
}
