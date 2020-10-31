//
//  MainViewController.swift
//  AboutCanada
//
//  Created by Veera Venkata Sateesh Pasala on 31/10/20.
//  Copyright © 2020 Veera Venkata Sateesh Pasala. All rights reserved.
//
import UIKit
private let CellID = #file

class MainViewController: UIViewController {
    
    var tableview  =  UITableView()
    private var canadaListViewModel: CandaViewModel?
    var safeArea: UILayoutGuide!
    var navBar: UINavigationBar!
    var navBarTittle : String?
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(frame: .zero)
        activityIndicator.style = .medium
        activityIndicator.color = UIColor.black
        return activityIndicator
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpView()
        fetchData()
    }
    
    override func loadView() {
        super.loadView()
        
        safeArea = view.layoutMarginsGuide
        setNavigationBar()
        setupTableView()
        
    }
    
    func setupTableView() {
        view.addSubview(tableview)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        tableview.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableview.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    func setNavigationBar() {
        let screenSize: CGRect = UIScreen.main.bounds
         navBar = UINavigationBar(frame: CGRect(x: 0, y:20, width: screenSize.width, height: 44))
        let navItem = UINavigationItem(title: navBarTittle ?? "")
        let activityIndicatorItem = UIBarButtonItem(customView: self.activityIndicator)
        let refreshItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.refresh, target: nil, action: #selector(refresh))
        navItem.rightBarButtonItem = refreshItem
        navItem.leftBarButtonItem = activityIndicatorItem
        navItem.largeTitleDisplayMode = .always
        navBar.setItems([navItem], animated: false)
        self.view.addSubview(navBar)
    }
    
    @objc func refresh() {
        fetchData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setNavigationBar()
        setUpView()
    }
    
    
    
    
    private func setUpView() {
        
        tableview.delegate = self
        tableview.register(InfoTableViewCell.self, forCellReuseIdentifier: CellID)
        tableview.dataSource = self
        tableview.rowHeight = UITableView.automaticDimension
        tableview.estimatedRowHeight = 100
        tableview.allowsSelection = false
        tableview.accessibilityIdentifier = "tableView"
    }
    
    
    /// Refresh button action
    @objc private func refreshData(_ sender: Any) {
        fetchData()
    }
    
    private func fetchData() {
        activityIndicator.startAnimating()
        Networking.fetchData { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let cellData):
                ///update UI on main thread
                DispatchQueue.main.async {
                    self.navBarTittle = cellData.title
                    self.navBar.topItem?.title = cellData.title
                }
                self.canadaListViewModel =  CandaViewModel.init(cellData:cellData.rows!)
            case .failure(let error):
                
                /// Showing alert for errors
                DispatchQueue.main.async() {
                    let alert = Alert.init(subTitle: error.localizedDescription,
                                           cancelTitle: "OK")
                    alert.presentAlert(from: self)
                }
            }
            
            /// Reload tableView and dismiss activity indicator
            DispatchQueue.main.async() {
                self.activityIndicator.stopAnimating()
                self.tableview.reloadData()
            }
        }
    }
    
    
}

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let assetData = self.canadaListViewModel?.sendData()
            else { return ConstantNumber.noOfRows.rawValue }
        return assetData.count
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          guard let assetData = self.canadaListViewModel?.sendData() else{ return UITableViewCell() }
    
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellID, for: indexPath) as? InfoTableViewCell
            else { fatalError() }
        cell.cellImage.image = nil
        let canadaListViewModel = CanadaListCellDataSource(asset: assetData[indexPath.row])
        cell.show(data: canadaListViewModel)

        return cell
    }
}


extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

