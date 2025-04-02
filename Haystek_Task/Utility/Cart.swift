//
//  Cart.swift
//  Haystek_Task
//
//  Created by MangiReddy on 01/04/25.
//

import UIKit

class Cart {
    static let shared = Cart()
    
    var cartItems: [Products] = []
    
    private init() {}
}
