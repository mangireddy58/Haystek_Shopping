//
//  Untitled.swift
//  Haystek_Task
//
//  Created by MangiReddy on 01/04/25.
//

import Foundation

class ProductService {
    
    func fetchProducts(completion: @escaping (Result<[Products], Error>) -> Void) {
        guard let url = URL(string: procutsApiUrl) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: 500, userInfo: nil)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let products = try decoder.decode([Products].self, from: data)
                completion(.success(products))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
