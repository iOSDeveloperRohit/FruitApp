//
//  MockURLProtocol.swift
//  FruitsAppTests
//
//  Created by Rohit on 29/12/2018.
//

import Foundation

class MockURLProtocol: URLProtocol {
    
    static var stubResponseData:Data?
    static var stubError:Error?
    
    override class func canInit(with task: URLSessionTask) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        
        if let error = MockURLProtocol.stubError {
            self.client?.urlProtocol(self, didFailWithError: error)
        } else {
            self.client?.urlProtocol(self, didLoad: MockURLProtocol.stubResponseData ?? Data())
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
    
}
