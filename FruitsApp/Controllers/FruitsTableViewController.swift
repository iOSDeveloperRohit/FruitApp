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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFruitsDetails" {
            guard let fruitsDetailsVC = segue.destination as? FruitDetailsViewController else {
                let usageStat = UsageStat(event: UsageEventType.error, data: "\(#function) : FruitDetailsViewController not found")
                self.usageStatViewModel.usageStat =  usageStat
                return
            }
            if let selectedIndex = self.tableView.indexPathForSelectedRow?.row {
                fruitsDetailsVC.friutVM = self.fruitsListVM.fruitVMAt(index: selectedIndex)
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
        
        
        guard let url = URL(string: FruitListViewModel.fruitsURL) else {
            let usageStat = UsageStat(event: UsageEventType.error, data: "\(#function) : URL cannot be formed")
            self.usageStatViewModel.usageStat =  usageStat
            return
        }
        let fruitResource = Resource<FruitList>(url: url)
        activityIndicatorView.startAnimating()
        
        let startTime = CACurrentMediaTime();

        WebService().sendRequest(resource: fruitResource) {[unowned self] (result) in
            switch result {
            case .success(let fruits):
                let data = (CACurrentMediaTime() - startTime) * 1000.0
                self.usageStatViewModel.usageStat = UsageStat(event: UsageEventType.load, data: "\(data)")
                print(fruits)
                self.fruitsListVM.fruitViewModels = fruits.fruitsList.map{(FruitViewModel.init(fruit: $0))}
                self.fruitsTableView.reloadData()
            case .failure(let error):
                self.usageStatViewModel.usageStat = UsageStat(event: UsageEventType.error, data: "\(error.localizedDescription)")
                print(error)
            }
            DispatchQueue.main.async {
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
        
        return cell
    }
    
    
    //MARK: Refresh Control
    @objc private func handleProductRefresh(_ refreshControl: UIRefreshControl) {
        self.fruitsTableView.alpha = 0.5
        self.populateFruits()
    }
    
}
