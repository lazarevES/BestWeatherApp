//
//  ForecastForDayDays.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 10.08.2022.
//

import Foundation
import UIKit

class ForecastForDayDays: UITableViewCell {
    
    static let identifire = "ForecastForDayDays"
    
    private var forecasts = [Forecast]()
    private var selectedForecast: Forecast?
    private var callback: ((Forecast) -> Void)?
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        collectionView.register(ForecastForDayDaysItem.self, forCellWithReuseIdentifier: ForecastForDayDaysItem.identifire)
        useConstraint()
    }
    
   private func useConstraint() {
        NSLayoutConstraint.activate([collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                                     collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                                     collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
                                     collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                                     collectionView.heightAnchor.constraint(equalToConstant: 50)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func setupContent(_ forecasts: [Forecast], selectedForecast: Forecast, _ callback: @escaping ((Forecast) -> Void)) {
        self.forecasts = forecasts
        self.selectedForecast = selectedForecast
        self.callback = callback
        collectionView.reloadData()
        
        let index = forecasts.firstIndex { forecast in
            forecast.date == selectedForecast.date
        }
        
        if let index = index {
            collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        }
    }
}

extension ForecastForDayDays: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastForDayDaysItem.identifire, for: indexPath) as? ForecastForDayDaysItem
        else {
            return UICollectionViewCell()
        }
        
        let forecast = forecasts[indexPath.item]
        cell.setupContent(forecast)
        cell.isSelected = forecast.date == (selectedForecast?.date ?? "")
        cell.switchSelected()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedForecast = forecasts[indexPath.item]
        if let callback = self.callback, let selectedForecast = selectedForecast {
            callback(selectedForecast)
        }
        
    }
}
