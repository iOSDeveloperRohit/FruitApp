//
//  FruitViewModelTest.swift
//  FruitsAppTests
//
//  Created by Rohit on 29/12/2018.
//

import XCTest
@testable import FruitsApp

class FruitViewModelTest: XCTestCase {
    var sut:FruitViewModel!
    override func setUpWithError() throws {
        sut = FruitViewModel(fruit: Fruit(type: "Apple", price: 325, weight: 45689))
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testFruitViewModel_amountInPence_shouldDisplayInPounds() {
        XCTAssertEqual(sut.price, "£3.25")
    }

    func testFruitViewModel_weightInGrams_shouldDisplayInKG() {
        XCTAssertEqual(sut.weight, "45.689 KG")
    }
    
    func testFruitViewModel_weightTitle_shouldIncludeUnits() {
        XCTAssertEqual(sut.weightTitle, "Apple weight in KG")
    }

    func testFruitViewModel_priceTitle_shouldIncludeUnits() {
        XCTAssertEqual(sut.priceTitle, "Apple price in pounds")
    }
    
    func testFruitViewModel_cellHasColor() {
        XCTAssertNotNil(sut.cellColor)
    }

}
