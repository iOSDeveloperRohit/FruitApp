//
//  FruitsTableViewController.swift
//  FruitsApp
//
//  Created by Rohit on 18/12/2021.
//

import UIKit

class FruitsTableViewController: UITableViewController {
    @IBOutlet var fruitsTableView: UITableView!
    var fruitsListVM = FruitListViewModel()
    
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.populateFruits()
    }

    // MARK: Service Call
    private func populateFruits() {
        
        guard let url = URL(string: FruitListViewModel.fruitsURL) else {
            fatalError()
        }
        let fruitResource = Resource<FruitList>(url: url)
        
        WebService().load(resource: fruitResource) { (result) in
            switch result {
            case .success(let fruits):
                print(fruits)
                self.fruitsListVM.fruitViewModels = fruits.fruitsList.map{(FruitViewModel.init(fruit: $0))}
                self.fruitsTableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: UITableViewDataSource, UITableViewDelegate

extension FruitsTableViewController {
    
    // MARK: UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fruitsListVM.numberOfRows(section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fruitVM = self.fruitsListVM.fruitVMAt(index: indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FruitsTableViewCell", for: indexPath)
        cell.textLabel?.text = fruitVM.name
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFruitsDetails" {
            guard let fruitsDetailsVC = segue.destination as? FruitDetailsViewController else {
                fatalError("FruitDetailsViewController not found")
            }
            if let selectedIndex = self.tableView.indexPathForSelectedRow?.row {
                fruitsDetailsVC.friutVM = self.fruitsListVM.fruitVMAt(index: selectedIndex)
            }
        }
        
        
    }
    
}
