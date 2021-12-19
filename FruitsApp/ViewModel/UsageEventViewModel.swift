//
//  UsageEventViewModel.swift
//  FruitsApp
//
//  Created by Rohit on 18/12/2021.
//

import Foundation


struct UsageStatViewModel {
    
    private static let host = "raw.githubusercontent.com"
    private static let path = "/fmtvp/recruit-test-data/master/stats"
    
    var usageStat:UsageStat? {
        didSet{
            self.sendUsageDataToServer()
        }
    }

    var startTime:CFTimeInterval?
    var loadTime:CFTimeInterval?
    
    var data:String? {
        guard let startTime = self.startTime, let loadTime = self.loadTime else {
            return nil
        }
        let data = (loadTime - startTime) * 1000.0
        return "\(data)"
    }
    
    // URL Builder
    var url:URL?{
        guard let usageStat = self.usageStat else {
            return nil
        }
        
        var urlBuilder = URLComponents()
        urlBuilder.scheme = "https"
        urlBuilder.host = UsageStatViewModel.host
        urlBuilder.path = UsageStatViewModel.path
        urlBuilder.queryItems = [
            URLQueryItem(name: "event", value: usageStat.event.rawValue),
            URLQueryItem(name: "data", value: usageStat.data)
        ]
        return urlBuilder.url
    }
    
}

// Send usage to server
extension UsageStatViewModel {
    func sendUsageDataToServer() {
        if let url = self.url {
            let resource = Resource<UsageStat>(url: url)
            WebService().sendRequest(resource: resource) { (result) in
                switch result {
                case .success(_):
                    print("Success")
                case .failure(let error):
                    print("Error sending usage stats \(error.errorDescription ?? "No error description")")
                }
            }
        } else {
            print("Url cannot be formed")
        }
    }
}
