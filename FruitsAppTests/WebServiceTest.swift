//
//  WebServiceTest.swift
//  FruitsAppTests
//
//  Created by Rohit on 29/12/2021.
//

import XCTest
@testable import FruitsApp

class WebServiceTest: XCTestCase {
    
    var sut:WebService!
    var url:URL?
    var fruitResource:Resource<FruitList>!
    
    override func setUpWithError() throws {
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: config)
        
        sut = WebService(session: urlSession)
        guard let url = URL(string: FruitListViewModel.fruitsURL) else {
            return
        }
        self.url = url
        fruitResource = Resource<FruitList>(url: url)
    }

    override func tearDownWithError() throws {
        sut = nil
        url = nil
        fruitResource = nil
        MockURLProtocol.stubError = nil
        MockURLProtocol.stubResponseData = nil
    }

    
    
    func testWebService_SendRequestSuccess_whenRequestIsSuccessful() throws {
        //Arrange
        
        let fruitListModel = FakeFruitListmodel().getFakeFruitListModel()
        let mockData:Data! = try JSONEncoder().encode(fruitListModel)
    
        MockURLProtocol.stubResponseData = mockData
        
        let expectation = self.expectation(description: "Expectation for webservice receiving the fruits.")
        
        sut.sendRequest(resource: fruitResource) { (result) in
            
            switch result {
            case .success(let fruits):
                XCTAssertNotNil(fruits, "The list of fruits were expected but received Nil")
                expectation.fulfill()

            case .failure(_):
                XCTFail("The success was expected but received an error instead")
            }
        }
        self.wait(for: [expectation], timeout: 2.0)
    }

    
    func testWebSErvice_sendRequestNetworkError_returnsErrorMessageDescription() {
        let expectation = self.expectation(description: "Expectation for webservice receiving the error.")
        let serviceError = NetworkError.serviceError("Some network error")
        MockURLProtocol.stubError = serviceError
        
        
        sut.sendRequest(resource: fruitResource) { (result) in
            switch result {
            case .success(let result):
                XCTAssertNotNil(result,"Returned result for webservice while expecting the error")
            case .failure(let error):
                XCTAssertNotEqual(error, serviceError)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 2.0)
        
    }
    
    func testWebservice_whenNoDataIsReceived_shouldReturnError(){
        let expectation = self.expectation(description: "Expecation for webservice returning no data")
        MockURLProtocol.stubResponseData = nil

        sut.sendRequest(resource: fruitResource) { (result) in
            switch result {
            case .success(let result):
                XCTAssertNotNil(result,"Returned result for webservice while expecting the error")
            case .failure(let error):
                if error == NetworkError.noData {
                    expectation.fulfill()
                } else {
                    XCTFail("Error expected was no data but different error received")
                }
            }
        }
        
        wait(for: [expectation], timeout: 2.0)
        
    }
    
    func testWebservice_whenInvalidDataIsReceived_shouldReturnError(){
        let expectation = self.expectation(description: "Expecation for webservice returning no data")
        let fakeInvalidData = Data("""
                {
                    "fake":"Data"
                }
        """.utf8)
        MockURLProtocol.stubResponseData = fakeInvalidData
        
        sut.sendRequest(resource: fruitResource) { (result) in
            switch result {
            case .success(let result):
                XCTAssertNil(result,"Returned result for webservice while expecting the error")
            case .failure(_):
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 2.0)
        
    }
    
    
}
