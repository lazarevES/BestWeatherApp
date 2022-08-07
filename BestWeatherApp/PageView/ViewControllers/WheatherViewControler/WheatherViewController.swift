//
//  WheatherViewController.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 02.08.2022.
//

import Foundation
import UIKit

class WheatherViewController: UIViewController, ViewControllerProtocol {
    
    var city: City?
    weak var delegate: PageViewCoordinator?
    var index: Int = 0
    var isAppear = false
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.toAutoLayout()
        tableView.refreshControl = UIRefreshControl()
        tableView.isScrollEnabled = true
        tableView.separatorStyle = .none
        tableView.refreshControl?.addTarget(self, action: #selector(updateWeather), for: .valueChanged)
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubviews(tableView)
        
        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                                     tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                                     tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                                     tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)])
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(WheatherToDayInfoCell.self, forCellReuseIdentifier: WheatherToDayInfoCell.identifire)
        tableView.register(WheatherToDayHourHeader.self, forHeaderFooterViewReuseIdentifier: WheatherToDayHourHeader.identifire)
        tableView.register(WheatherToDayHourCell.self, forCellReuseIdentifier: WheatherToDayHourCell.identifire)
        tableView.register(WheatherDayHeader.self, forHeaderFooterViewReuseIdentifier: WheatherDayHeader.identifire)
        tableView.register(WheatherDayCell.self, forCellReuseIdentifier: WheatherDayCell.identifire)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isAppear = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isAppear = false
    }
    
    func setupCity(city: City, index: Int) {
        self.city = city
        self.index = index
    }
    
    
    func upLoadWheather() {
        if isAppear {
            tableView.reloadData()
            tableView.refreshControl?.endRefreshing()
        }
    }
    
    @objc func updateWeather() {
        if let delegate = delegate, let city = city {
            delegate.downloadingWheatherData(city: city)
        }
    }
}

extension WheatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < 2 {
            return 1
        } else {
            return self.city?.wheather?.forecasts.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: WheatherToDayInfoCell.identifire,
                                                 for: indexPath) as! WheatherToDayInfoCell
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: WheatherToDayHourCell.identifire,
                                                 for: indexPath) as! WheatherToDayHourCell
            if let city = self.city {
                cell.setupContent(city: city)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: WheatherDayCell.identifire,
                                                 for: indexPath) as! WheatherDayCell
            
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
            if let city = self.city, let wheather = city.wheather {
                cell.setupContent(forecast: wheather.forecasts[indexPath.row])
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            return nil
        }
        
        if section == 1 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: WheatherToDayHourHeader.identifire) as? WheatherToDayHourHeader
            return headerView
        } else {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: WheatherDayHeader.identifire) as? WheatherDayHeader
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 200
        } else if indexPath.section == 1 {
            return 120
        } else {
            return 75
        }
    }
    
}
