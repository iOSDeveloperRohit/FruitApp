//
//  WebService.swift
//  FruitsApp
//
//  Created by Rohit on 18/12/2021.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
    case noData
    case failedRequest
    case invalidData
    case urlError
}

// Generic Resource which can be used to load any Jason from received from Server
struct Resource<T:Codable> {
    var url:URL
}

class WebService {
    func sendRequest<T>(resource:Resource<T>, completion:@escaping (Result<T,NetworkError>)->Void) {
        
        URLSession.shared.dataTask(with: resource.url) { (data, response, error) in
            DispatchQueue.main.async{
                guard error == nil else {
                  print("Failed request from \(resource.url): \(error!.localizedDescription)")
                    completion(.failure(.failedRequest))
                  return
                }
                
                guard let data = data else {
                  print("No data returned from \(resource.url)")
                    completion(.failure(.noData))
                  return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    print("Unable to process \(resource.url) response")
                    completion(.failure(.invalidResponse))
                  return
                }
                
                guard response.statusCode == 200 else {
                    print("Failure response from \(resource.url): \(response.statusCode)")
                    completion(.failure(.failedRequest))
                  return
                }
                // Try parsing data with generic class and catch the error
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(result))
                } catch {
                    print("Unable to decode \(resource.url) response: \(error.localizedDescription)")
                    completion(.failure(.invalidData))

                }
            }
        }.resume()
        
        
    }
}
