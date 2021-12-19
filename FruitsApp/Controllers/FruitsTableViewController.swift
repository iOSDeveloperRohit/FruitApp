//
//  FruitsTableViewController.swift
//  FruitsApp
//
//  Created by Rohit on 18/12/2021.
//

import UIKit
import ChameleonFramework

class FruitsTableViewController: UITableViewController {
    @IBOutlet var fruitsTableView: UITableView!
    var fruitsListVM = FruitListViewModel()
    var usageStatViewModel = UsageStatViewModel()
    
    // Activity indicator
    private let activityIndicatorView: UIActivityIndicatorView = {
        let actView = UIActivityIndicatorView(style: .large)
        actView.hidesWhenStopped = true
        return actView
    }()
    
    // Refresh Controller
    lazy var fruitsRefreshControl: UIRefreshControl = {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(handleProductRefresh(_:)), for: .valueChanged)
            refreshControl.tintColor = UIColor.black
            return refreshControl
        }()
    
    // MARK: View Lifecycle and UI Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.populateFruits()
    }

    func setUpUI() {
        self.view.addSubview(activityIndicatorView)
        self.fruitsTableView.addSubview(fruitsRefreshControl)
        // apply constraints
        self.activityIndicatorView.center = self.view.center
        self.fruitsTableView.rowHeight = 80.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation controller does not exist.")
        }
        navBar.backgroundColor = UIColor(hexString: "#1D9BF6")
        navBar.prefersLargeTitles = true
        self.title = "FruitApp"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFruitsDetails" {
            guard let fruitsDetailsVC = segue.destination as? FruitDetailsViewController else {
                let usageStat = UsageStat(event: UsageEventType.error, data: "\(#function) : FruitDetailsViewController not found")
                self.usageStatViewModel.usageStat =  usageStat
                return
            }
            if let selectedIndex = self.tableView.indexPathForSelectedRow?.row {
                fruitsDetailsVC.fruitVM = self.fruitsListVM.fruitVMAt(index: selectedIndex)
            }
        }
        
    }
    
    func stopRefreshAndActivityControl() {
        self.fruitsRefreshControl.endRefreshing()
        self.activityIndicatorView.stopAnimating()
        self.fruitsTableView.alpha = 1.0
    }
    
    // MARK: Service Call
    private func populateFruits() {
        activityIndicatorView.startAnimating()
        self.fruitsListVM.fetchFruits {[unowned self] (result) in
            //Perform UI activities on main Thread
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    //Sucessfully retrived fruits data. reload tableview
                    self.fruitsTableView.reloadData()
                case .failure(let error):
                    print(error)
                    let alert = UIAlertController(title: "Error retriving data, Do you wish to retry?", message: error.localizedDescription, preferredStyle: .alert)
                    let doneAction = UIAlertAction(title: "Retry", style: .default) { (action) in
                        self.populateFruits()
                    }
                    let cancelAction = UIAlertAction(title: "No", style: .default,handler: nil)
                    alert.addAction(doneAction)
                    alert.addAction(cancelAction)
                    present(alert, animated: true)
                }
                self.stopRefreshAndActivityControl()
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
        
        // Use Framework to set random colors
        cell.backgroundColor = fruitVM.cellColor
        cell.textLabel?.textColor = ContrastColorOf(fruitVM.cellColor, returnFlat: true)
        
        return cell
    }
    
    
    //MARK: Refresh Control
    @objc private func handleProductRefresh(_ refreshControl: UIRefreshControl) {
        self.fruitsTableView.alpha = 0.5
        self.populateFruits()
    }
    
}
