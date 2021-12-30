//
//  mockWebservice.swift
//  FruitsAppTests
//
//  Created by Rohit on 30/12/2021.
//

import Foundation
@testable import FruitsApp

class MockWebservice: ServiceRequestable {
    
    static var stubResponseModel:FruitList?
    static var networkError:NetworkError?
    
    
    func sendRequest<T>(resource: Resource<T>, completion: @escaping (Result<T, NetworkError>) -> Void) {
        if let error = MockWebservice.networkError {
            completion(.failure(error))
        } else if let fruitList = MockWebservice.stubResponseModel as? T{
            completion(.success(fruitList))
        } else {
            completion(.failure(NetworkError.noData))
        }
    }
    
    
}
