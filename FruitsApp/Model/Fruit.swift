//
//  Fruit.swift
//  FruitsApp
//
//  Created by Rohit on 18/12/2021.
//

import Foundation
import UIKit
import ChameleonFramework

struct FruitList: Codable {
    let fruitsList:[Fruit]
    
    enum CodingKeys: String, CodingKey {
      case fruitsList = "fruit"
    }
}

struct Fruit:Codable {
    let type:String
    let price:Int
    let weight:Int
    
    // Assigned a value. Will not be decoded
    let cellColor = UIColor.randomFlat().hexValue()
}
