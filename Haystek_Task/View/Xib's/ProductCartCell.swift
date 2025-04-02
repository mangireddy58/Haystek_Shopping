//
//  ProductCartCell.swift
//  TaskPoc
//
//  Created by Prakash's Mac on 09/11/24.
//

import UIKit

class ProductCartCell: UITableViewCell {
    @IBOutlet weak var cartImage: UIImageView!
    @IBOutlet weak var cartSelectBtn: UIButton!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var cartView: UIView!
    @IBOutlet weak var checkmarkSelectedBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cartView.applyCardStyle(cornerRadius: 5.0, shadowColor: .gray, shadowOpacity: 0.5, shadowOffset: CGSize(width: 0, height: 3), shadowRadius: 10.0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func loadData(_ cartItem: Products) {
        descLbl.text = cartItem.title
        priceLbl?.text = "$\(cartItem.price)"
        
        let imageUrlString = cartItem.image
        if let cachedImage = ImageCache.shared.getImage(forKey: imageUrlString) {
            cartImage?.image = cachedImage
        } else {
            DispatchQueue.global().async {
                if let url = URL(string: imageUrlString), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    ImageCache.shared.saveImage(image, forKey: imageUrlString)
                    DispatchQueue.main.async { [self] in
                        cartImage?.image = image
                    }
                }
            }
        }
    }
    
    @IBAction func cartValueSelected(_ sender: UIButton) {
        cartSelectBtn.isSelected.toggle()
        
        cartSelectBtn.setImage(UIImage(named: "check-mark"), for: .normal)
    }
}
