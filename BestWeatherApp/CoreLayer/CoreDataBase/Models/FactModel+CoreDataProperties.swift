//
//  FactModel+CoreDataProperties.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 05.08.2022.
//
//

import Foundation
import CoreData


extension FactModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FactModel> {
        return NSFetchRequest<FactModel>(entityName: "FactModel")
    }

    @NSManaged public var temp: Int16
    @NSManaged public var condition: String?
    @NSManaged public var humidity: Int16
    @NSManaged public var polar: Bool
    @NSManaged public var feelsLike: Int16
    @NSManaged public var windSpeed: Double
    @NSManaged public var windGust: Double
    @NSManaged public var windDirKey: String?
    @NSManaged public var pressure: Int16
    @NSManaged public var daytimeKey: String?
    @NSManaged public var seasonKey: String?
    @NSManaged public var precTypeKey: Int16
    @NSManaged public var precStrengthKey: Double
    @NSManaged public var isThunder: Bool
    @NSManaged public var cloudnessKey: Double
    @NSManaged public var obsTime: Int64
    @NSManaged public var wheather: WheatherModel?

}

extension FactModel : Identifiable {

}

extension FactModel : Storable {

}
