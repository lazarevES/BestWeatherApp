//
//  CoreDataProtocol.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 30.07.2022.
//

import Foundation
import CoreData

protocol Storable {}
extension NSManagedObject: Storable {}

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
    
    var mainContext: NSManagedObjectContext { get set }

    func create<T: Storable>(_ model: T.Type, keyedValues: [[String: Any]], completion: @escaping (Result<[T], DatabaseError>) -> Void)

    func update<T: Storable>(_ model: T.Type, predicate: NSPredicate?, keyedValues: [String: Any], completion: @escaping (Result<[T], DatabaseError>) -> Void)

    func delete<T: Storable>(_ model: T.Type, predicate: NSPredicate?, completion: @escaping (Result<[T], DatabaseError>) -> Void)

    func deleteAll<T: Storable>(_ model: T.Type, completion: @escaping (Result<[T], DatabaseError>) -> Void)

    func fetch<T: Storable>(_ model: T.Type, predicate: NSPredicate?, completion: @escaping (Result<[T], DatabaseError>) -> Void)

    func fetchAll<T: Storable>(_ model: T.Type, completion: @escaping (Result<[T], DatabaseError>) -> Void)
}
