//
//  Extensions.swift
//  Haystek_Task
//
//  Created by MangiReddy on 01/04/25.
//

import UIKit

extension UIView {
    
    @objc func setCornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func applyCardStyle(cornerRadius: CGFloat = 10.0, shadowColor: UIColor = .black, shadowOpacity: Float = 0.3, shadowOffset: CGSize = CGSize(width: 0, height: 4), shadowRadius: CGFloat = 6.0) {
        
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = false
        
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
        
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func applyTiledBackground(with image: UIImage) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleToFill
        self.backgroundColor = .clear
        self.insertSubview(imageView, at: 0)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.leftAnchor.constraint(equalTo: self.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = maskPath.cgPath
        self.layer.mask = shapeLayer
        self.layer.masksToBounds = true
    }
}
@IBDesignable
class CircleView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
    }
    
    private func updateCornerRadius() {
        self.layer.cornerRadius = self.bounds.width / 2
        self.layer.masksToBounds = true
    }
}
@IBDesignable
class CircleButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
    }
    
    private func updateCornerRadius() {
        self.layer.cornerRadius = self.bounds.width / 2
        self.layer.masksToBounds = true
    }
}
