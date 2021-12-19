//
//  FruitViewModel.swift
//  FruitsApp
//
//  Created by Rohit on 18/12/2021.
//

import Foundation
import UIKit
import ChameleonFramework

class FruitListViewModel {
    
    static let fruitsURL = "https://raw.githubusercontent.com/fmtvp/recruit-test-data/master/data.json"
   
    var fruitViewModels:[FruitViewModel]
    
    init() {
        self.fruitViewModels = [FruitViewModel]()
    }
    
    func fruitVMAt(index:Int) -> FruitViewModel {
        return self.fruitViewModels[index]
    }
    
    func numberOfRows(_ section: Int) -> Int {
        return self.fruitViewModels.count
    }
}


struct FruitViewModel {
    let fruit : Fruit
}

extension FruitViewModel {
    
    var name:String {
        return fruit.type.capitalized
    }
    var price:String {
        let priceInPounds = Double(fruit.price)/100
        return (String(format: "£%.2f", priceInPounds))
    }
    var weight:String {
        let weightInKG = Double(fruit.weight)/1000
        return (String(format: "%.3f KG", weightInKG))
    }
    
    var priceTitle:String {
        return "\(self.name) price in pounds"
    }
    
    var weightTitle:String {
        return "\(self.name) weight in KG"
    }
    
    var cellColor:UIColor {
        //Assign a random color if not already presnt
        return UIColor(hexString: fruit.cellColor) ?? UIColor.randomFlat()
    }
}
