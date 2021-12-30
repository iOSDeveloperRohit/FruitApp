//
//  WebService.swift
//  FruitsApp
//
//  Created by Rohit on 18/12/2021.
//

import Foundation
import UIKit

enum NetworkError: Error, Equatable {
    case invalidResponse
    case noData
    case invalidData(String)
    case urlError
    case serviceError(String)
    case failedRequest(Int)
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Unable to process response"
        case .noData:
            return "Service did not receive any data."
        case .invalidData(let message):
            return "Failed to parse the data with error \(message)."
        case .urlError:
            return "Url cannot be formed."
        case .serviceError(let message):
            return message
        case .failedRequest(let statusCode):
            return "Service returned invalid response code: \(statusCode)."
        }
    }
}

// Generic Resource which can be used to load any Jason from received from Server
struct Resource<T:Codable> {
    var url:URL
}

protocol ServiceRequestable {
    func sendRequest<T>(resource:Resource<T>, completion:@escaping (Result<T,NetworkError>)->Void)
}

class WebService: ServiceRequestable {
    
    private let urlSession: URLSession
    init(session: URLSession = .shared) {
        self.urlSession = session
    }
    
    func sendRequest<T>(resource:Resource<T>, completion:@escaping (Result<T,NetworkError>)->Void) {
        
        print("sending request to url: \(resource.url)")
        
        urlSession.dataTask(with: resource.url) { (data, response, error) in
            DispatchQueue.main.async{
                guard error == nil else {
                  print("Failed request from \(resource.url): \(error!.localizedDescription)")
                    completion(.failure(NetworkError.serviceError(error?.localizedDescription ?? "")))
                  return
                }
                
                guard let data = data, data.count != 0 else {
                  print("No data returned from \(resource.url)")
                    completion(.failure(.noData))
                  return
                }
                // Try parsing data with generic class and catch the error
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(result))
                } catch {
                    print("Unable to decode \(resource.url) response: \(error.localizedDescription)")
                    completion(.failure(.invalidData(error.localizedDescription)))
                }
            }
        }.resume()
        
        
    }
}
