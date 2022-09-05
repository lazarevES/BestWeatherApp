//
//  SetSettingsController.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 12.08.2022.
//

import Foundation
import UIKit

class SetSettingsController: UIViewController {
    
    private lazy var backView: UIView = {
        let view = UIView()
        view.toAutoLayout()
        view.backgroundColor = ConstValue.backgroundColorLight
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var claudImage1 = UIImageView.getImage("cloud1")
    private lazy var claudImage2 = UIImageView.getImage("cloud2")
    private lazy var claudImage3 = UIImageView.getImage("cloud3")
    private lazy var label = UILabel.getlabel(18, .left, .black, "Настройки", true)
    private lazy var tempLabel = UILabel.getlabel(16, .left, .gray, "Температура", true)
    private lazy var speedLabel = UILabel.getlabel(16, .left, .gray, "Скорость ветра", true)
    private lazy var timeLabel = UILabel.getlabel(16, .left, .gray, "Формат времени", true)
    private lazy var notificationLabel = UILabel.getlabel(16, .left, .gray, "Уведомления", true)

    private lazy var tempSwitch: UISegmentedControl = {
        let switcher = UISegmentedControl(items: ["Cº", "Fº"])
        switcher.toAutoLayout()
        switcher.selectedSegmentTintColor = ConstValue.backgroundColor
        switcher.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        return switcher
    }()
    
    private lazy var timeSwitch: UISegmentedControl = {
        let switcher = UISegmentedControl(items: ["12", "24"])
        switcher.toAutoLayout()
        switcher.selectedSegmentTintColor = ConstValue.backgroundColor
        switcher.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        return switcher
    }()
    
    private lazy var speedSwitch: UISegmentedControl = {
        let switcher = UISegmentedControl(items: ["M/s", "Ya/s"])
        switcher.toAutoLayout()
        switcher.selectedSegmentTintColor = ConstValue.backgroundColor
        switcher.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        return switcher
    }()
    
    private lazy var notificationSwitch: UISegmentedControl = {
        let switcher = UISegmentedControl(items: ["On", "Off"])
        switcher.toAutoLayout()
        switcher.selectedSegmentTintColor = ConstValue.backgroundColor
        switcher.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        return switcher
    }()
    
    private lazy var acceptButton: UIButton = {
        
        let button = UIButton()
        button.toAutoLayout()
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.setTitle("Установить", for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont.fontRubik(12)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 4
        button.addTarget(self, action: #selector(acceptGeo), for: .touchUpInside)
        button.addTarget(self, action: #selector(preAcceptGeo), for: .touchDown)
        button.backgroundColor = UIColor(named: "ButtonColorNormal")

        return button
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = ConstValue.backgroundColor
        view.addSubviews(claudImage1, claudImage2, claudImage3, backView, label, tempLabel, speedLabel, timeLabel,
                         notificationLabel, tempSwitch, timeSwitch, speedSwitch, notificationSwitch, acceptButton)
        useConstaraint()
        setupConten()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func useConstaraint() {
        
        NSLayoutConstraint.activate([
            backView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            backView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            backView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            backView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -50),
            
            claudImage1.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            claudImage1.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            
            claudImage2.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            claudImage2.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 170),
            
            claudImage3.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 75),
            claudImage3.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -75),
            claudImage3.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90),
            
            label.topAnchor.constraint(equalTo: backView.topAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 15),
            label.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -15),
            label.heightAnchor.constraint(equalToConstant: 20),
            
            tempLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 30),
            tempLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 15),
            tempLabel.trailingAnchor.constraint(equalTo: tempSwitch.leadingAnchor, constant: -15),
            tempLabel.heightAnchor.constraint(equalToConstant: 20),
            
            tempSwitch.centerYAnchor.constraint(equalTo: tempLabel.centerYAnchor),
            tempSwitch.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -20),
            tempSwitch.widthAnchor.constraint(equalToConstant: 90),
            tempSwitch.heightAnchor.constraint(equalToConstant: 30),
            
            speedLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 30),
            speedLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 15),
            speedLabel.trailingAnchor.constraint(equalTo: speedSwitch.leadingAnchor, constant: -15),
            speedLabel.heightAnchor.constraint(equalToConstant: 20),
            
            speedSwitch.centerYAnchor.constraint(equalTo: speedLabel.centerYAnchor),
            speedSwitch.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -20),
            speedSwitch.widthAnchor.constraint(equalToConstant: 90),
            speedSwitch.heightAnchor.constraint(equalToConstant: 30),
            
            timeLabel.topAnchor.constraint(equalTo: speedLabel.bottomAnchor, constant: 30),
            timeLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 15),
            timeLabel.trailingAnchor.constraint(equalTo: tempSwitch.leadingAnchor, constant: -15),
            timeLabel.heightAnchor.constraint(equalToConstant: 20),
            
            timeSwitch.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor),
            timeSwitch.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -20),
            timeSwitch.widthAnchor.constraint(equalToConstant: 90),
            timeSwitch.heightAnchor.constraint(equalToConstant: 30),
            
            notificationLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 30),
            notificationLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 15),
            notificationLabel.trailingAnchor.constraint(equalTo: notificationSwitch.leadingAnchor, constant: -15),
            notificationLabel.heightAnchor.constraint(equalToConstant: 20),
            
            notificationSwitch.centerYAnchor.constraint(equalTo: notificationLabel.centerYAnchor),
            notificationSwitch.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -20),
            notificationSwitch.widthAnchor.constraint(equalToConstant: 90),
            notificationSwitch.heightAnchor.constraint(equalToConstant: 30),
            
            acceptButton.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -15),
            acceptButton.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 35),
            acceptButton.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -35),
            acceptButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
    }
    
    func setupConten() {
        switch Settings.sharedSettings.time {
        case .full:
            timeSwitch.selectedSegmentIndex = 1
        case .partial:
            timeSwitch.selectedSegmentIndex = 0
        }
        
        switch Settings.sharedSettings.temp {
        case .fahrenheit:
            tempSwitch.selectedSegmentIndex = 1
        case .celsius:
            tempSwitch.selectedSegmentIndex = 0
        }
        
        switch Settings.sharedSettings.speed {
        case .imperium:
            speedSwitch.selectedSegmentIndex = 1
        case .metric:
            speedSwitch.selectedSegmentIndex = 0
        }
        
        switch Settings.sharedSettings.notifications {
        case .off:
            notificationSwitch.selectedSegmentIndex = 1
        case .on:
            notificationSwitch.selectedSegmentIndex = 0
        }
        
    }
    
    @objc func preAcceptGeo() {
        acceptButton.backgroundColor = UIColor(named: "ButtonColorFocus")
    }
    
    @objc func acceptGeo() {
        acceptButton.backgroundColor = UIColor(named: "ButtonColorNormal")
        
        Settings.sharedSettings.time = Settings.Time(rawValue: timeSwitch.selectedSegmentIndex) ?? .full
        Settings.sharedSettings.temp = Settings.Temp(rawValue: tempSwitch.selectedSegmentIndex) ?? .celsius
        Settings.sharedSettings.speed = Settings.Speed(rawValue: speedSwitch.selectedSegmentIndex) ?? .metric
        Settings.sharedSettings.notifications = Settings.Notifications(rawValue: notificationSwitch.selectedSegmentIndex) ?? .off
        
        navigationController?.popViewController(animated: true)
    }
    
}
