//
//  FruitViewModel.swift
//  FruitsApp
//
//  Created by Rohit on 18/12/2018.
//

import Foundation
import UIKit
struct FruitViewModel {
    let fruit : Fruit
}

extension FruitViewModel {
    
    var name:String {
        return fruit.type.capitalized
    }
    
    //To display price in Pounds
    var price:String {
        let priceInPounds = Double(fruit.price)/100
        return (String(format: "£%.2f", priceInPounds))
    }
    
    // To display weight in KG
    var weight:String {
        let weightInKG = Double(fruit.weight)/1000
        return (String(format: "%.3f KG", weightInKG))
    }
    
    var priceTitle:String {
         "\(self.name) price in pounds"
    }
    
    var weightTitle:String {
         "\(self.name) weight in KG"
    }
    
    var cellColor:UIColor {
        //Assign a random color if not already presnt
         UIColor(hexString: fruit.cellColor)!
    }
}
