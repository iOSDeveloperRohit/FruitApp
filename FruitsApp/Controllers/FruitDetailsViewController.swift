//
//  FruitDetailsViewController.swift
//  FruitsApp
//
//  Created by Rohit on 18/12/2021.
//

import UIKit
import ChameleonFramework

class FruitDetailsViewController: UIViewController {

    //IBOulets
    @IBOutlet weak var priceTitleLabel: UILabel!
    @IBOutlet weak var priceDetailsLabel: UILabel!
    @IBOutlet weak var weightTitleLabel: UILabel!
    @IBOutlet weak var weightDetailsLabel: UILabel!
    
    var fruitDetailsVM:FruitDetailsViewModel?
    private var usageStatViewModel = UsageStatViewModel(request: WebService())

    // MARK: - View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = self.fruitDetailsVM?.usageStatViewModel {
            self.fruitDetailsVM?.usageStatViewModel.loadTime = CACurrentMediaTime()
            if let data = self.fruitDetailsVM?.usageStatViewModel.data {
                self.fruitDetailsVM?.usageStatViewModel.usageStat = UsageStat(event: .display, data: data)
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let navBar = navigationController?.navigationBar, let fruitVM = self.fruitDetailsVM?.fruitViewModel else {
            fatalError("Navigation controller does not exist.")
        }
        navBar.backgroundColor = fruitVM.cellColor
        navBar.tintColor = ContrastColorOf(fruitVM.cellColor, returnFlat: true)
        navBar.barTintColor = ContrastColorOf(fruitVM.cellColor, returnFlat: true)
        navBar.prefersLargeTitles = true
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(fruitVM.cellColor, returnFlat: true)]
        self.title = fruitVM.name
    }
    
    // MARK: - Setup UI based on data
    private func setUpUI() {
        if let fruitVM = self.fruitDetailsVM?.fruitViewModel {
            self.view.backgroundColor = fruitVM.cellColor
            self.priceTitleLabel.text = fruitVM.priceTitle
            self.priceDetailsLabel.text = fruitVM.price
            
            self.weightTitleLabel.text = fruitVM.weightTitle
            self.weightDetailsLabel.text = fruitVM.weight
            
            let titleLabelColor = ContrastColorOf(fruitVM.cellColor, returnFlat: false)
            let detailLabelColor = ContrastColorOf(fruitVM.cellColor, returnFlat: false)
            
            self.priceTitleLabel.textColor = titleLabelColor
            self.priceDetailsLabel.textColor = detailLabelColor
            self.weightTitleLabel.textColor = titleLabelColor
            self.weightDetailsLabel.textColor = detailLabelColor

        }
    }
}
