//
//  DayPartsModel+CoreDataProperties.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 09.08.2022.
//
//

import Foundation
import CoreData


extension DayPartsModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DayPartsModel> {
        return NSFetchRequest<DayPartsModel>(entityName: "DayPartsModel")
    }

    @NSManaged public var temp: Int16
    @NSManaged public var tempMin: Int16
    @NSManaged public var feelsLike: Int16
    @NSManaged public var condition: String?
    @NSManaged public var windSpeed: Double
    @NSManaged public var windGust: Double
    @NSManaged public var windDirKey: String?
    @NSManaged public var humidity: Int16
    @NSManaged public var precTypeKey: Int16
    @NSManaged public var precStrengthKey: Double
    @NSManaged public var cloudnessKey: Double
    @NSManaged public var isDay: Bool
    @NSManaged public var forecast: ForecastModel?

}

extension DayPartsModel : Identifiable {

}
