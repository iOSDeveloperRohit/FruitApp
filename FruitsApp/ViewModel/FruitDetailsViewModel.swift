//
//  FruitDetailsVM.swift
//  FruitsApp
//
//  Created by Rohit on 19/12/2018.
//

import Foundation

struct FruitDetailsViewModel {
    var usageStatViewModel = UsageStatViewModel(request: WebService())
    var fruitViewModel:FruitViewModel
}
