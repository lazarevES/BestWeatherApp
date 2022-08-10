//
//  ForecastForDaySunAndMoon.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 10.08.2022.
//

import Foundation
import UIKit

class ForecastForDaySunAndMoon: UITableViewCell {
    
    static let identifire = "ForecastForDaySunAndMoon"
    
    private var forecast: Forecast?
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.toAutoLayout()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isUserInteractionEnabled = true
        return collectionView
    }()
    
    private lazy var label = UILabel.getlabel(19, .left, .black, "Солнце и Луна", true)
    private lazy var view: UIView = {
        let view = UIView()
        view.toAutoLayout()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.backgroundColor = ConstValue.backgroundColor
        return view
    }()
    
    private lazy var moonLabel = UILabel.getlabel(14, .left, .black, "", true)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubviews(collectionView, label, view, moonLabel)
        collectionView.register(ForecastForDaySunAndMoonItem.self,
                                forCellWithReuseIdentifier: ForecastForDaySunAndMoonItem.identifire)
        collectionView.register(ForecastForDaySunAndMoonSeparator.self,
                                forCellWithReuseIdentifier: ForecastForDaySunAndMoonSeparator.identifire)
        useConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func useConstraint() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.widthAnchor.constraint(equalToConstant: 160),
            label.heightAnchor.constraint(equalToConstant: 22),
            
            moonLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:  -5),
            moonLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            moonLabel.widthAnchor.constraint(equalToConstant: 130),
            
            view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            view.trailingAnchor.constraint(equalTo: moonLabel.leadingAnchor, constant: -5),
            view.heightAnchor.constraint(equalToConstant: 16),
            view.widthAnchor.constraint(equalToConstant: 16),
            
            collectionView.topAnchor.constraint(equalTo: label.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
    }
    
    func setupContent(forecast: Forecast) {
        self.forecast = forecast
        moonLabel.text = forecast.moon.rawValue        
    }
}

extension ForecastForDaySunAndMoon: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastForDaySunAndMoonItem.identifire, for: indexPath) as! ForecastForDaySunAndMoonItem
            
            if let forecast = forecast {
                cell.setupContent(sunrise: forecast.sunrise, sunset: forecast.sunset, sun: true)
            }
            return cell
        } else if indexPath.item == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastForDaySunAndMoonItem.identifire, for: indexPath) as! ForecastForDaySunAndMoonItem
            
            if let forecast = forecast {
                cell.setupContent(sunrise: forecast.sunset, sunset: forecast.sunrise, sun: false)
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastForDaySunAndMoonSeparator.identifire,
                                                          for: indexPath) as! ForecastForDaySunAndMoonSeparator
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 1 {
            return CGSize(width: 2, height: 80)
        } else {
            return CGSize(width: 160, height: 80)
        }
    }
}
