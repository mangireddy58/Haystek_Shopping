//
//  ProductsViewModel.swift
//  Haystek_Task
//
//  Created by MangiReddy on 01/04/25.
//

import Foundation

class ProductViewModel {
    
    private var productService = ProductService()
    
    var products: [Products] = []
    var categories = [String]()
        
    var onDataFetched: (() -> Void)?
    var onError: ((String) -> Void)?
    
    func fetchProducts() {
        productService.fetchProducts { [weak self] result in
            switch result {
            case .success(let fetchedProducts):
                self?.products = fetchedProducts
                for i in fetchedProducts{
                    self!.categories.append(i.category)
                    self?.categories = Array(Set((self?.categories)!))
                }
                DispatchQueue.main.async {
                    self?.onDataFetched?()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.onError?(error.localizedDescription)
                }
            }
        }
    }
    
    func toggleCart(for product: Products) {
//        print("Product to add: ", product.id)
//        var found: Bool = false
//        var itemIndex: Int = -1
//        cartItems.enumerated().forEach { index, item in
//            if item.id == product.id {
//                found = true
//                itemIndex = index
//            }
//        }
//        if found {
//            cartItems.remove(at: itemIndex)
//        } else {
//            cartItems.append(product)
//        }
    }
    
    func cartItemCount() -> Int {
        return Cart.shared.cartItems.count
    }
}
