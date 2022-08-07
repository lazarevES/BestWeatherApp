//
//  ForecastModel+CoreDataProperties.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 07.08.2022.
//
//

import Foundation
import CoreData


extension ForecastModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ForecastModel> {
        return NSFetchRequest<ForecastModel>(entityName: "ForecastModel")
    }

    @NSManaged public var date: String?
    @NSManaged public var dateTs: Int64
    @NSManaged public var moonCode: Int16
    @NSManaged public var sunrise: String?
    @NSManaged public var sunset: String?
    @NSManaged public var week: Int16
    @NSManaged public var temp: Int16
    @NSManaged public var condition: String?
    @NSManaged public var humidity: Int16
    @NSManaged public var windSpeed: Double
    @NSManaged public var tempMin: Int16
    @NSManaged public var feelsLike: Int16
    @NSManaged public var windDirKey: String?
    @NSManaged public var windGust: Double
    @NSManaged public var precTypeKey: Int16
    @NSManaged public var precStrengthKey: Double
    @NSManaged public var cloudnessKey: Double
    @NSManaged public var hours: NSSet
    @NSManaged public var wheather: WheatherModel?

}

extension ForecastModel : Identifiable {

}
