//
//  FruitListViewModelTest.swift
//  FruitsAppTests
//
//  Created by Rohit on 30/12/2018.
//

import XCTest

class FruitListViewModelTest: XCTestCase {
    
    var mockWebservice:MockWebservice!
    var sut:FruitListViewModel!
    
    override func setUpWithError() throws {
        mockWebservice = MockWebservice()
        sut = FruitListViewModel(request: mockWebservice)
        if FruitListViewModel.fruitsURL == "" {
            FruitListViewModel.fruitsURL = "https://raw.githubusercontent.com/fmtvp/recruit-test-data/master/data.json"
        }
    }

    override func tearDownWithError() throws {
        mockWebservice = nil
        MockWebservice.stubResponseModel = nil
        sut = nil
    }

    func testFruitListViewModel_shouldSetFruitsParameter_whenFruitsretrievedSuccessFully() throws {
        
        MockWebservice.stubResponseModel = FakeFruitListmodel().getFakeFruitListModel()
        
        sut.fetchFruits { (result) in
            switch result{
            case(.success(let fruitList)):
                XCTAssertNotNil(fruitList,"fruit list expected to be not nil")
                XCTAssertNotEqual(self.sut.fruitViewModels.count, 0,"Fruits View Models should have fruits when fruits are retrived")
            case .failure(let error):
                XCTAssertNil(error, "There should not have been an error as fruits were retrived")
            }
        }
    }
    
    func testFruitListViewModel_shouldSetError_whenFruitsNotRetrievedSuccessFully() throws {
        
        sut.fetchFruits { (result) in
            switch result{
            case(.success(let fruitList)):
                XCTAssertNil(fruitList,"fruit list expected to be not nil")
            case .failure(let error):
                XCTAssertNotNil(error, "There should have been an error as fruits were retrived")
            }
        }
    }
    
    func testFruitListViewModel_shouldSetErrorUsageStat_whenEmptyUrlPassed() throws {
        FruitListViewModel.fruitsURL = ""
        sut.fetchFruits { (result) in
            switch result{
            case(.success(let fruitList)):
                XCTAssertNil(fruitList,"fruit list expected to be not nil")
            case .failure(let error):
                XCTAssertNotNil(error, "There should have been an error as fruits were retrived")
            }
        }
    }
    
}
