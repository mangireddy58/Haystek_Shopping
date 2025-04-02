//
//  CustomImagesCell.swift
//  TaskPoc
//
//  Created by Prakash's Mac on 09/11/24.
//

import UIKit

class CustomImagesCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryImg: UIImageView!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryLbl: UILabel!
    
    var viewModel = ProductViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func category(with category: String){
        categoryLbl.text = category
        for i in viewModel.products{
            if i.category == category{
                let imageUrlString = i.image
                if let cachedImage = ImageCache.shared.getImage(forKey: imageUrlString) {
                    categoryImg.image = cachedImage
                } else {
                    DispatchQueue.global().async {
                        if let url = URL(string: imageUrlString), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                            ImageCache.shared.saveImage(image, forKey: imageUrlString)
                            DispatchQueue.main.async {
                                self.categoryImg.image = image
                            }
                        }
                    }
                }
            }
        }
    }
}
