//
//  SettingsView.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 11.08.2022.
//

import Foundation
import UIKit

class SettingsView: UIViewController {
    
    var pageController: PageViewController?
    private lazy var image = UIImageView.getImage("partly-cloudy")
    private lazy var label = UILabel.getlabel(18, .left, .white, "Погода", true)
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.toAutoLayout()
        tableView.backgroundColor = ConstValue.backgroundColor
        tableView.isScrollEnabled = true
        tableView.isUserInteractionEnabled = true
        tableView.separatorColor = .white
        tableView.rowHeight = 35
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(updateTable), for: .valueChanged)
        return tableView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = ConstValue.backgroundColor
        view.addSubviews(image, label, tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SettingsViewCell.self, forCellReuseIdentifier: SettingsViewCell.identifire)
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(clouseMenu))
        swipe.direction = [.left]
        view.addGestureRecognizer(swipe)
        
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            image.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35),
            image.widthAnchor.constraint(equalToConstant: 25),
            image.heightAnchor.constraint(equalToConstant: 25),
            
            label.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 15),
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35),
            label.widthAnchor.constraint(equalToConstant: 100),
            label.heightAnchor.constraint(equalToConstant: 25),
            
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -70)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    @objc func updateTable() {
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
    }
    
    @objc func clouseMenu() {
        if let parent = parent as? GlobalViewController {
            parent.toggleMenu()
        }
    }
    
}

extension SettingsView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return (pageController?.citys.count ?? 1) + 1
        } else {
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsViewCell",
                                                 for: indexPath) as! SettingsViewCell
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.setupContent(imageName: "redact", text: "Редактировать", value: nil)
            } else {
                let city = pageController?.citys[indexPath.row - 1]
                if let city = city {
                    cell.setupContent(imageName: "geo", text: city.name, value: nil)
                }
            }
        } else {
            switch indexPath.row {
            case 0:
                let notifications = Settings.sharedSettings.notifications == .on ? true : false
                cell.setupContent(imageName: "bal", text: "Уведомления", value: "", switcher: notifications)
            case 1:
                let temp = Settings.sharedSettings.temp == .celsius ? "Cº" : "Fº"
                cell.setupContent(imageName: "thermometer", text: "Единица температуры", value: temp)
            case 2:
                let speed = Settings.sharedSettings.speed == .metric ? "m/s" : "ya/s"
                cell.setupContent(imageName: "fan", text: "Единица скорости ветра", value: speed)
            case 3:
                let time = Settings.sharedSettings.time == .full ? "24 часа" : "12 часов"
                cell.setupContent(imageName: "clock", text: "Формат времени", value: time)
            default:
                break
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            navigationController?.setNavigationBarHidden(true, animated: true)
            navigationController?.pushViewController(SetSettingsController(), animated: true)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if indexPath.section == 0 && indexPath.row > 0 {
            
            let curentCity = pageController?.citys[indexPath.row - 1]
            let deleteAction = UIContextualAction(style: .destructive, title: "Удалить", handler: {[weak self] _, _, completionHandler in
                guard let controller = self?.pageController else { return }
                controller.citys.removeAll(where: { city in
                    city == curentCity
                })
                
                let city =  controller.citys.first
                if let city = city {
                    self?.parent?.title = city.name + ", " + city.country
                } else {
                    self?.parent?.title = ""
                }
                
                controller.setViewControllers([controller.coordinator.getViewController(city: city, index: 0)], direction: .forward, animated: true)
                controller.pageControl.numberOfPages = controller.citys.count
                controller.pageControl.currentPage = 0
                
                DispatchQueue.global().async {
                    controller.coordinator.removeFromDatabase(city: curentCity!)
                }
                
                tableView.deleteRows(at: [indexPath], with: .left)
            })
            
            let swipe = UISwipeActionsConfiguration(actions: [deleteAction])
            return swipe
        }
        
        let swipe = UISwipeActionsConfiguration(actions: [])
        return swipe
    }
    
}
