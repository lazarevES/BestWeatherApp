//
//  RealmProtocol.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 30.07.2022.
//

import Foundation
import CoreData

enum DatabaseError: Error {
    //Невозможно добавить хранилище.
    case store(model: String)
    //Не найден momd файл.
    case find(model: String, bundle: Bundle?)
    //Не найдена модель объекта.
    case wrongModel
    //Кастомная ошибка.
    case error(desription: String)
    //Неизвестная ошибка.
    case unknown(error: Error)
}

protocol CoreDataProtocol {
    
    func create(_ city: City, completion: @escaping (Result<City, DatabaseError>) -> Void)

    func update(_ city: City, predicate: NSPredicate?, completion: @escaping (Result<City, DatabaseError>) -> Void)

    func delete(predicate: NSPredicate?, completion: @escaping (Result<[City], DatabaseError>) -> Void)

    func deleteAll(completion: @escaping (Result<[City], DatabaseError>) -> Void)

    func fetch(predicate: NSPredicate?, completion: @escaping (Result<[City], DatabaseError>) -> Void)
    
    func fetchModel(predicate: NSPredicate?, completion: @escaping (Result<[CityModel], DatabaseError>) -> Void)

    func fetchAll(completion: @escaping (Result<[City], DatabaseError>) -> Void)
}
