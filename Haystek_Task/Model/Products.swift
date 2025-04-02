//
//  Products.swift
//  Haystek_Task
//
//  Created by MangiReddy on 01/04/25.
//

import Foundation

struct Products: Decodable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    let rating: Rating
}

struct Rating: Decodable {
    let rate: Double
    let count: Int
}

struct CartItem {
    let product: Products
    var isInCart: Bool
}
