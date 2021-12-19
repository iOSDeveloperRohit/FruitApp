//
//  FruitListViewModel.swift
//  FruitsApp
//
//  Created by Rohit on 19/12/2021.
//

import Foundation
import ChameleonFramework

class FruitListViewModel {
    var usageStatViewModel = UsageStatViewModel()

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


extension FruitListViewModel:ObservableObject {
    func fetchFruits(completion: @escaping (Result<Any,NetworkError>)->(Void)) {
        
        guard let url = URL(string: FruitListViewModel.fruitsURL) else {
            let usageStat = UsageStat(event: UsageEventType.error, data: "\(#function) : URL cannot be formed")
            self.usageStatViewModel.usageStat =  usageStat
            return
        }
        let fruitResource = Resource<FruitList>(url: url)
        
        let startTime = CACurrentMediaTime();

        WebService().sendRequest(resource: fruitResource) {[unowned self] (result) in
            switch result {
            case .success(let fruits):
                let data = (CACurrentMediaTime() - startTime) * 1000.0
                self.usageStatViewModel.usageStat = UsageStat(event: UsageEventType.load, data: "\(data)")
                print(fruits)
                self.fruitViewModels = fruits.fruitsList.map{(FruitViewModel.init(fruit: $0))}
                completion(.success(true))
            case .failure(let error):
                self.usageStatViewModel.usageStat = UsageStat(event: UsageEventType.error, data: "\(error.errorDescription ?? "")")
                print(error)
                completion(.failure(error))
            }
        }
    }
}





