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
    var refreshControl = UIRefreshControl()
    private var canadaListViewModel: CandaViewModel?
    var navigationBar: UINavigationBar!
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
        let screenSize: CGRect = UIScreen.main.bounds
        setNavigationBar(width: screenSize.width)
        setupTableView()
        
    }
    
    func setupTableView() {
        view.addSubview(tableview)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        tableview.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableview.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        refreshControl.accessibilityLabel = ConstantStrings.refreshControlAccessibilityLabel.rawValue
        tableview.addSubview(refreshControl)
    }
    
    
    func setNavigationBar(width: CGFloat) {
        navigationBar = UINavigationBar(frame: CGRect(x: 0, y:30, width:width, height: 44))
        navigationBar.barTintColor = UIColor.white
        let navItem = UINavigationItem(title: navBarTittle ?? "")
        let activityIndicatorItem = UIBarButtonItem(customView: self.activityIndicator)

        navItem.leftBarButtonItem = activityIndicatorItem
        navItem.largeTitleDisplayMode = .always
        navigationBar.setItems([navItem], animated: false)
        self.view.addSubview(navigationBar)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setNavigationBar(width: size.width)
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
    
    
    @objc func refresh(_ sender: AnyObject) {
        if(Networking.connectedToNetwork()){
            fetchData()
        }else{
            DispatchQueue.main.async() {
                self.refreshControl.endRefreshing()
                self.tableview.contentOffset = CGPoint.zero
                let alert = Alert.init(subTitle: ConstantStrings.noInternetAlertTitle.rawValue,
                                       cancelTitle: ConstantStrings.okButtonTitle.rawValue)
                alert.presentAlert(from: self)
                
            }
        }
    }
    
    private func fetchData() {
        activityIndicator.startAnimating()
        Networking.fetchData { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let cellData):
                ///update UI on main thread
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.navBarTittle = cellData.title
                    self.navigationBar.topItem?.title = cellData.title
                }
                self.canadaListViewModel =  CandaViewModel.init(cellData:cellData.rows!)
            case .failure(let error):
                
                /// Showing alert for errors
                DispatchQueue.main.async() {
                    let errorString = error.localizedDescription == ConstantStrings.noInternetError.rawValue  ? ConstantStrings.noInternetAlertTitle.rawValue : error.localizedDescription
                    let alert = Alert.init(subTitle: errorString,
                                           cancelTitle: ConstantStrings.okButtonTitle.rawValue)
                    alert.presentAlert(from: self)
                }
            }
            
            /// Reload tableView and dismiss activity indicator
            DispatchQueue.main.async() {
                self.activityIndicator.stopAnimating()
                self.refreshControl.endRefreshing()
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
        let canadaListViewModel = CanadaListCellDataSource(asset: assetData[indexPath.row])
        cell.show(data: canadaListViewModel)

        return cell
    }
}


extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // we can write future navigation and cell press action here 
    }
}

