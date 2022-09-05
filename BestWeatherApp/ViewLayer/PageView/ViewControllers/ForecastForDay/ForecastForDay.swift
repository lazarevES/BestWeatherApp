//
//  ForecastForDay.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 10.08.2022.
//

import Foundation
import UIKit

class ForecastForDay: UIViewController {
    
    private var city: City
    private var selectedForecast: Forecast
    
    private lazy var cityLabel: UILabel = UILabel.getlabel(18, .left, .black, city.name + ", " + city.country, true)
    
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
    
    init(city: City, forecast: Forecast) {
        self.city = city
        self.selectedForecast = forecast
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        navigationItem.title = "Дневная погода"
        
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
        tableView.register(ForecastForDayDays.self, forCellReuseIdentifier: ForecastForDayDays.identifire)
        tableView.register(ForecastForDayParts.self, forCellReuseIdentifier: ForecastForDayParts.identifire)
        tableView.register(ForecastForDaySunAndMoon.self, forCellReuseIdentifier: ForecastForDaySunAndMoon.identifire)
        
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
            tableView.topAnchor.constraint(equalTo: cityLabel.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    @objc func updateTable() {
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
    }
    
    @objc func dismissVC() {
        navigationController?.popViewController(animated: true)
    }
    
}

extension ForecastForDay: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ForecastForDayDays.identifire,
                                                     for: indexPath) as! ForecastForDayDays
            cell.selectionStyle = .none
            if let wheather = city.wheather {
                cell.setupContent(wheather.forecasts, selectedForecast: selectedForecast) { [weak self] forecast in
                    self?.selectedForecast = forecast
                    self?.tableView.reloadData()
                }
            }
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ForecastForDayParts.identifire,
                                                     for: indexPath) as! ForecastForDayParts
            cell.setupContent(part: selectedForecast.dayForecast!, partName: "День")
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ForecastForDayParts.identifire,
                                                     for: indexPath) as! ForecastForDayParts
            cell.setupContent(part: selectedForecast.nightForecast!, partName: "Ночь")
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ForecastForDaySunAndMoon.identifire,
                                                     for: indexPath) as! ForecastForDaySunAndMoon
            cell.selectionStyle = .none
            cell.setupContent(forecast: selectedForecast)
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        4
    }
}
