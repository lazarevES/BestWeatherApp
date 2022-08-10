//
//  ForecastModel+CoreDataProperties.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 09.08.2022.
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
    @NSManaged public var hours: NSSet
    @NSManaged public var wheather: WheatherModel?
    @NSManaged public var dayparts: NSSet

}

extension ForecastModel : Identifiable {

}
