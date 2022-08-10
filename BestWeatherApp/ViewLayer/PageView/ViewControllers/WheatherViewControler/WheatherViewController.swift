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
    var needReload = false
    
    private var dateFormatterDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    private lazy var tableView: UITableView = {
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
                                     tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                                     tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)])
        
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
        if needReload {
            needReload.toggle()
            tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func setupCity(city: City, index: Int) {
        self.city = city
        self.index = index
    }
    
    
    func upLoadWheather() {
        if isAppear {
            tableView.reloadData()
            tableView.refreshControl?.endRefreshing()
        } else {
            needReload = true
        }
    }
    
    @objc func updateWeather() {
        if let delegate = delegate, let city = city {
            delegate.downloadingWheatherData(city: city)
        }
    }
    
    private func getForecast() -> [(date: String, hour: Hour)] {
        
        var forecast = [(date: String, hour: Hour)]()
        let dateFormatterDayMounth = DateFormatter()
        dateFormatterDayMounth.dateFormat = "dd/MM"
        
        let dateFormatterHour = DateFormatter()
        dateFormatterHour.dateFormat = "HH"
        
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: Date())
        var stringDate = ""
       
        switch weekDay {
        case 1: stringDate = "вс "
        case 2: stringDate = "пн "
        case 3: stringDate = "вт "
        case 4: stringDate = "ср "
        case 5: stringDate = "чт "
        case 6: stringDate = "пт "
        case 7: stringDate = "сб "
        default: break
        }
        
        guard let wheather = city?.wheather else { return forecast }
        let date = self.dateFormatterDay.string(from: Date())
        
        let index = wheather.forecasts.firstIndex { forecast in
            forecast.date == date
        }
        
        if var index = index {
            let now = dateFormatterHour.string(from: Date())
            var indexHour = wheather.forecasts[index].hours.firstIndex { hour in
                (hour.hour.count == 1 ? "0" + hour.hour : hour.hour) == now
            }
            
            if var indexHour = indexHour {
                let date = stringDate + dateFormatterDayMounth.string(from: Date(timeIntervalSince1970:  TimeInterval(wheather.forecasts[index].dateTs)))
                while indexHour < wheather.forecasts[index].hours.count {
                    forecast.append((date: date, hour: wheather.forecasts[index].hours[indexHour]))
                    indexHour += 1
                }
            }
            
            if forecast.count < 24 && wheather.forecasts.count > index + 1 {
                index += 1
                indexHour = 0
                if wheather.forecasts[index].hours.count > 0, var indexHour = indexHour {
                    let date = stringDate + dateFormatterDayMounth.string(from: Date(timeIntervalSince1970:  TimeInterval(wheather.forecasts[index].dateTs)))
                    while indexHour < wheather.forecasts[index].hours.count && forecast.count < 24 {
                        forecast.append((date: date, hour: wheather.forecasts[index].hours[indexHour]))
                        indexHour += 1                        
                    }
                }
            }
        }
        
        return forecast
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
            cell.selectionStyle = .none
            
            if let wheather = city?.wheather, let fact = wheather.fact {
                let date = dateFormatterDay.string(from: Date())
                let forecast = wheather.forecasts.first { forecast in
                    forecast.date == date
                }
                
                if let forecast = forecast {
                    cell.setupContent(fact: fact, forecast: forecast)
                }
            }
            
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
            headerView?.setupContent { [weak self] in
                guard let self = self else { return }
                let forecast = self.getForecast()
                    let name = self.city!.name + ", " + self.city!.country
                    let viewController = DetailsForcastTodayViewController()
                    
                    viewController.setupContent(forecast, cityName: name)
                    self.navigationController?.pushViewController(viewController, animated: true)
            }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 2, let city = city, let wheather = city.wheather {
            let selectedForecast = wheather.forecasts[indexPath.row]
            let forecastForDay = ForecastForDay(city: city, forecast: selectedForecast)
            navigationController?.pushViewController(forecastForDay, animated: true)
        }
        
    }
}
