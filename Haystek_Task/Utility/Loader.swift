//
//  Loader.swift
//  Haystek_Task
//
//  Created by MangiReddy on 01/04/25.
//

import UIKit

class Loader {
    static let shared = Loader()
    
    private let containerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        view.backgroundColor = UIColor(white: 0, alpha: 0.6)
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private init() {
        containerView.addSubview(activityIndicator)
        containerView.addSubview(messageLabel)
    }
    
    func show(in view: UIView, message: String = "Loading...") {
        messageLabel.text = message
        containerView.center = view.center
        
        activityIndicator.frame = CGRect(x: (containerView.frame.width - 40) / 2, y: 25, width: 40, height: 40)
        
        messageLabel.frame = CGRect(x: 10, y: activityIndicator.frame.maxY + 10, width: containerView.frame.width - 20, height: 40)
        
        view.addSubview(containerView)
        view.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
    }
    
    func hide(from view: UIView) {
        DispatchQueue.global().async {
            sleep(4)
            DispatchQueue.main.async { [self] in
                activityIndicator.stopAnimating()
                containerView.removeFromSuperview()
                view.isUserInteractionEnabled = true
            }
        }
    }
}
