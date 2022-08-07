//
//  CityModel+CoreDataProperties.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 05.08.2022.
//
//

import Foundation
import CoreData


extension CityModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CityModel> {
        return NSFetchRequest<CityModel>(entityName: "CityModel")
    }

    @NSManaged public var id: String?
    @NSManaged public var country: String?
    @NSManaged public var lat: String?
    @NSManaged public var lon: String?
    @NSManaged public var name: String?
    @NSManaged public var wheather: WheatherModel?

}

extension CityModel : Identifiable {

}
