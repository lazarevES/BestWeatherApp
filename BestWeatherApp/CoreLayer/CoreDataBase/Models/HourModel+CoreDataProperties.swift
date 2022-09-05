//
//  HourModel+CoreDataProperties.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 05.08.2022.
//
//

import Foundation
import CoreData


extension HourModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HourModel> {
        return NSFetchRequest<HourModel>(entityName: "HourModel")
    }

    @NSManaged public var cloudnessKey: Double
    @NSManaged public var condition: String?
    @NSManaged public var feelsLike: Int16
    @NSManaged public var hour: String?
    @NSManaged public var hourTs: Int64
    @NSManaged public var humidity: Int16
    @NSManaged public var isThunder: Bool
    @NSManaged public var precMM: Double
    @NSManaged public var precPeriod: Int16
    @NSManaged public var precStrengthKey: Double
    @NSManaged public var precTypeKey: Int16
    @NSManaged public var pressure: Int16
    @NSManaged public var temp: Int16
    @NSManaged public var windDirKey: String?
    @NSManaged public var windGust: Double
    @NSManaged public var windSpeed: Double
    @NSManaged public var forecast: ForecastModel?

}

extension HourModel : Identifiable {

}

extension HourModel : Storable {

}
