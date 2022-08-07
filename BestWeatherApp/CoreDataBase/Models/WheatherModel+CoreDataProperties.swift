//
//  WheatherModel+CoreDataProperties.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 05.08.2022.
//
//

import Foundation
import CoreData


extension WheatherModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WheatherModel> {
        return NSFetchRequest<WheatherModel>(entityName: "WheatherModel")
    }

    @NSManaged public var city: CityModel?
    @NSManaged public var fact: FactModel?
    @NSManaged public var forecasts: NSSet

}

extension WheatherModel : Identifiable {

}
