//
//  FakeFruitListmodel.swift
//  FruitsAppTests
//
//  Created by Rohit on 29/12/2021.
//

import Foundation
@testable import FruitsApp

class FakeFruitListmodel {
    
    fileprivate class func createFakeData()->Data {
        let fakeFruitData = Data("""
                {
                    "fruit":[
                    {
                    "type": "apple",
                    "price": 149,
                    "weight": 120
                    },
                    {
                    "type": "banana",
                    "price": 129,
                    "weight": 80
                    },
                    {
                    "type": "blueberry",
                    "price": 19,
                    "weight": 18
                    },
                    {
                    "type": "orange",
                    "price": 199,
                    "weight": 150
                    },
                    {
                    "type": "pear",
                    "price": 99,
                    "weight": 100
                    },
                    {
                    "type": "strawberry",
                    "price": 99,
                    "weight": 20
                    },
                    {
                    "type": "kumquat",
                    "price": 49,
                    "weight": 80
                    },
                    {
                    "type": "pitaya",
                    "price": 599,
                    "weight": 100
                    },
                    {
                    "type": "kiwi",
                    "price": 89,
                    "weight": 200
                    }
                    ]
                }
        """.utf8)
        return fakeFruitData
    }
    
    func getFakeFruitListModel() -> FruitList {
        let data = FakeFruitListmodel.createFakeData()
        guard let fakeFruitModel = try? JSONDecoder().decode(FruitList.self, from: data) else {
            fatalError()
        }
        return fakeFruitModel
    }
    
}
