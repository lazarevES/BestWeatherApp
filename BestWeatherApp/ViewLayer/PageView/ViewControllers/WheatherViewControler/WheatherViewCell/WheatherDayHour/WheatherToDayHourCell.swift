//
//  WheatherToDayHourCell.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 02.08.2022.
//

import Foundation
import UIKit

class WheatherToDayHourCell: UITableViewCell {
    
    static let identifire = "WheatherToDayHourCell"
    
    private var city: City?
    private var forecast: Forecast?
    private var dateFormatterDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    private var dateFormatterHour: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        return formatter
    }()
    
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
        collectionView.register(WheatherToDayHourItem.self, forCellWithReuseIdentifier: WheatherToDayHourItem.identifire)
        useConstraint()
    }
    
        
   private func useConstraint() {
        NSLayoutConstraint.activate([collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                                     collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                                     collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
                                     collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContent(city: City) {
        self.city = city
        var index = 0
        if let wheather = city.wheather {
            var date = dateFormatterDay.string(from: Date())
            forecast = wheather.forecasts.first { forecast in
                forecast.date == date
            }
            
            date = dateFormatterHour.string(from: Date())
            index = forecast?.hours.firstIndex (where: { hour in
                (hour.hour.count == 1 ? "0" + hour.hour : hour.hour) == date
            }) ?? 0
            
            collectionView.reloadData()
            collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: UICollectionView.ScrollPosition.left, animated: true)
        }
    }
}

extension WheatherToDayHourCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let forecast = self.forecast {
            return forecast.hours.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WheatherToDayHourItem.identifire, for: indexPath) as? WheatherToDayHourItem
        else {
            return UICollectionViewCell()
        }
        if let forecast = forecast {
            var date = dateFormatterHour.string(from: Date())
            date = date.count == 1 ? "0" + date : date
            let hour = forecast.hours[indexPath.item]
            cell.setupContent(hour: hour)
            cell.switchActualHour((hour.hour.count == 1 ? "0" + hour.hour : hour.hour) == date)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ConstValue.hourWidth, height: ConstValue.hourHeight)
    }
    
}
