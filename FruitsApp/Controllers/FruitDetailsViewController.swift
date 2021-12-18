//
//  FruitDetailsViewController.swift
//  FruitsApp
//
//  Created by Rohit on 18/12/2021.
//

import UIKit

class FruitDetailsViewController: UIViewController {

    @IBOutlet weak var priceTitleLabel: UILabel!
    @IBOutlet weak var priceDetailsLabel: UILabel!
    @IBOutlet weak var weightTitleDetails: UILabel!
    @IBOutlet weak var weightDetailsLabel: UILabel!
    
    var friutVM:FruitViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    }

    private func setUpUI() {
        
        if let fruitVM = self.friutVM {
            self.priceTitleLabel.text = fruitVM.priceTitle
            self.priceDetailsLabel.text = fruitVM.price
            
            self.weightTitleDetails.text = fruitVM.weightTitle
            self.weightDetailsLabel.text = fruitVM.weight
            
        }
    }
    
}
