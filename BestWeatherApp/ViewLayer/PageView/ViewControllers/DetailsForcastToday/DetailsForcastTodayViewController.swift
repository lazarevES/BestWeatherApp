//
//  DetailsForcastTodayViewController.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 09.08.2022.
//

import Foundation
import UIKit

class DetailsForcastTodayViewController: UIViewController {
    
    private var forecast = [(date: String, hour: Hour)]()
    
    private var cityName: String = "" {
        didSet {
            cityLabel.text = cityName
        }
    }
    
    private lazy var cityLabel: UILabel = UILabel.getlabel(18, .left, .black, "", true)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.toAutoLayout()
        tableView.refreshControl = UIRefreshControl()
        tableView.isScrollEnabled = true
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.refreshControl?.addTarget(self, action: #selector(updateTable), for: .valueChanged)
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    override func viewDidLoad() {
        
        navigationItem.title = "Прогноз на 24 часа"
                
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.lightGray]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.lightGray]
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let item = UIBarButtonItem(title: "←", style: .plain, target: self, action: #selector(dismissVC))
        item.tintColor = .black
        navigationItem.leftBarButtonItem = item
        
        view.backgroundColor = .white
        view.addSubviews(cityLabel, tableView)
        useConstraint()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DetailsHourCell.self, forCellReuseIdentifier: DetailsHourCell.identifire)
        tableView.register(DetailsGraphicCell.self, forCellReuseIdentifier: DetailsGraphicCell.identifire)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let appearance = UINavigationBarAppearance()
        navigationController?.navigationBar.tintColor = ConstValue.backgroundColor
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
    }
    
    private func useConstraint() {
        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ConstValue.indent),
            cityLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: ConstValue.leading),
            cityLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: ConstValue.trailing),
            tableView.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: ConstValue.indent),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
        
    func setupContent(_ forecast: [(date: String, hour: Hour)], cityName: String) {
        self.forecast = forecast
        self.cityName = cityName
        tableView.reloadData()
    }
    
    @objc func updateTable() {
        setupContent(forecast, cityName: cityName)
        tableView.refreshControl?.endRefreshing()
    }
    
    @objc func dismissVC() {
        navigationController?.popViewController(animated: true)
    }
    
}

extension DetailsForcastTodayViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return self.forecast.count
        }
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailsGraphicCell.identifire,
                                                     for: indexPath) as! DetailsGraphicCell
            cell.setupContent(forecast)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailsHourCell.identifire,
                                                     for: indexPath) as! DetailsHourCell
            cell.setupContent(forecast: forecast[indexPath.row])
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
}
