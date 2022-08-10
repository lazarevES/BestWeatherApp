//
//  ForecastForDayParts.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 10.08.2022.
//

import Foundation
import UIKit

class ForecastForDayParts: UITableViewCell {
    
    static let identifire = "ForecastForDayParts"
    
    private var partName: String = "" {
        didSet {
            partlabel.text = partName
        }
    }
    
    private var parts = [(image: String, title: String, data: String)]()
    
    private lazy var partlabel = UILabel.getlabel(18, .left, .black, "", true)
    private lazy var tempLabel = UILabel.getlabel(30)
    private lazy var wheatherIcon = UIImageView.getImage("")
    private lazy var conditionLabel = UILabel.getlabel(18)
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.toAutoLayout()
        tableView.refreshControl = UIRefreshControl()
        tableView.isScrollEnabled = true
        tableView.separatorStyle = .none
        tableView.backgroundColor = ConstValue.backgroundColorLight
        tableView.refreshControl?.addTarget(self, action: #selector(updateTable), for: .valueChanged)
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = ConstValue.backgroundColorLight
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        contentView.addSubviews(partlabel, tempLabel, wheatherIcon, conditionLabel, tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ForecastForDayPartsCell.self, forCellReuseIdentifier: ForecastForDayPartsCell.identifire)
        
        useConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func useConstraint() {
        NSLayoutConstraint.activate([
            partlabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            partlabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            partlabel.widthAnchor.constraint(equalToConstant: 70),
            partlabel.heightAnchor.constraint(equalToConstant: 22),
            
            wheatherIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            wheatherIcon.leadingAnchor.constraint(equalTo: partlabel.trailingAnchor, constant: 75),
            wheatherIcon.widthAnchor.constraint(equalToConstant: 26),
            wheatherIcon.heightAnchor.constraint(equalToConstant: 32),
            
            tempLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            tempLabel.leadingAnchor.constraint(equalTo: wheatherIcon.trailingAnchor, constant: 10),
            tempLabel.widthAnchor.constraint(equalToConstant: 70),
            tempLabel.heightAnchor.constraint(equalToConstant: 32),
            
            conditionLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 10),
            conditionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            conditionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            conditionLabel.heightAnchor.constraint(equalToConstant: 22),
            
            tableView.topAnchor.constraint(equalTo: conditionLabel.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
    
    func setupContent(part: DayPart, partName: String) {
        self.partName = partName
        self.wheatherIcon.image = part.wheatherIcon.getImage()
        self.tempLabel.text = String(part.temp) + "º"
        self.conditionLabel.text = part.wheatherIcon.rawValue
        
        self.parts.removeAll()
        
        self.parts.append(("hot", "По ощущениям", String(part.feelsLike) + "º"))
        self.parts.append(("wind", "Ветер", String(part.windSpeed) + " m\\s " + part.windDir.rawValue))
        self.parts.append(("showers", "Дождь", part.precStrenght.rawValue))
        self.parts.append(("overcast", "Облачность", part.cloudness.rawValue))
        
        tableView.reloadData()
    }
    
    @objc func updateTable() {
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
    }
}


extension ForecastForDayParts: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ForecastForDayPartsCell.identifire,
                                                 for: indexPath) as! ForecastForDayPartsCell
        cell.selectionStyle = .none
        cell.setupContent(parts[indexPath.row])
        return cell
    }
}
