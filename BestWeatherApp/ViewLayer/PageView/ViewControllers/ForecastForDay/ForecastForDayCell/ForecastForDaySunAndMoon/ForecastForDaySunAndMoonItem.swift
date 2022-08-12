//
//  ForecastForDaySunAndMoonItem.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 10.08.2022.
//

import Foundation
import UIKit

class ForecastForDaySunAndMoonItem: UICollectionViewCell {
    
    static let identifire = "ForecastForDaySunAndMoonItem"
    
    private var time: String = ""
    private var sunrise: String = ""
    private var sunset: String = ""
    private var sun: Bool = false
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.toAutoLayout()
        tableView.refreshControl = UIRefreshControl()
        tableView.isScrollEnabled = true
        tableView.refreshControl?.addTarget(self, action: #selector(updateTable), for: .valueChanged)
        tableView.rowHeight = 25
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ForecastForDaySunAndMoonItemCell.self, forCellReuseIdentifier: ForecastForDaySunAndMoonItemCell.identifire)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: contentView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContent(sunrise: String, sunset: String, sun: Bool) {
        self.time = getTime(sunrise: sunrise, sunset: sunset)
        self.sunset = checkSettings(sunset)
        self.sunrise = checkSettings(sunrise)
        self.sun = sun
        tableView.reloadData()
    }
    
    func checkSettings(_ str: String) -> String {
        if Settings.sharedSettings.time == .full {
            return str
        } else {
            let timeArr = str.components(separatedBy: ":")
            let hour = Int(timeArr[0]) ?? 0
            let minute = timeArr[1]
            return String(hour > 12 ? hour - 12 : hour) + ":" + minute + " p.m."
        }
    }
    
    private func getTime(sunrise: String, sunset: String) -> String {
        
        let dateString = "2022-01-01 " + sunrise + ":00 +0000"
        let dateString2 = "2022-01-01 " + sunset + ":05 +0000"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        
        let date1 = dateFormatter.date(from: dateString)
        let date2 = dateFormatter.date(from: dateString2)
        if let date1 = date1, let date2 = date2 {
            let hour = Calendar.current.dateComponents([.hour], from: date1, to: date2).hour
            let minute = Calendar.current.dateComponents([.minute], from: date1, to: date2).minute
            
            if var hour = hour, var minute = minute {
                
                if hour < 0 {
                    hour *= -1
                    minute *= -1
                }
                
                minute -= (hour * 60)
                
                return String(hour) + "ч " + String(minute) + "мин"
                
            }
            
            return ""
        } else {
            return ""
        }
    }
                  
    
    @objc func updateTable() {
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
    }
    
}

extension ForecastForDaySunAndMoonItem: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ForecastForDaySunAndMoonItemCell.identifire,
                                                 for: indexPath) as! ForecastForDaySunAndMoonItemCell
        
        if indexPath.row == 0 {
            cell.setupContent(id: .image, data: time, sun: sun)
        } else if indexPath.row == 1 {
            cell.setupContent(id: .sunrise, data: sunrise, sun: sun)
        } else {
            cell.setupContent(id: .sunset, data: sunset, sun: sun)
        }
        
        cell.selectionStyle = .none
        return cell
    }
}
