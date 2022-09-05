//
//  CoreDataCoordinator.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 05.08.2022.
//

import Foundation
import CoreData

final class CoreDataCoordinator {
    
    let modelName: String
    
    private let model: NSManagedObjectModel
    private let persistentStoreCoordinator: NSPersistentStoreCoordinator
    
    private lazy var backgroundContext: NSManagedObjectContext = {
        let backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.mergePolicy = NSOverwriteMergePolicy
        backgroundContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return backgroundContext
    }()
    
    private lazy var mainContext: NSManagedObjectContext = {
        let mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return mainContext
    }()
    
    private init(url: URL) throws {
        let pathExtension = url.pathExtension
        
        guard let name = try? url.lastPathComponent.replace(pathExtension, replacement: "") else {
            throw DatabaseError.error(desription: "")
        }
        
        guard let model = NSManagedObjectModel(contentsOf: url) else {
            throw DatabaseError.error(desription: "")
        }
        
        self.modelName = name
        self.model = model
        self.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
    }
    
    private convenience init(name: String, bundle: Bundle? = nil) throws {
        let fileExtension = "momd"
        
        if
            let bundle = bundle,
            let url = bundle.url(forResource: name, withExtension: fileExtension) {
            try self.init(url: url)
        } else if let url = Bundle.main.url(forResource: name, withExtension: fileExtension) {
            try self.init(url: url)
        } else {
            throw DatabaseError.find(model: name, bundle: bundle)
        }
    }
    
    static func create(url modelUrl: URL) -> Result<CoreDataCoordinator, DatabaseError> {
        do {
            let coordinator = try CoreDataCoordinator(url: modelUrl)
            return Self.setup(coordinator: coordinator)
        } catch let error as DatabaseError {
            return .failure(error)
        } catch {
            return .failure(.unknown(error: error))
        }
    }
    
    private static func setup(coordinator: CoreDataCoordinator) -> Result<CoreDataCoordinator, DatabaseError> {
        let storeCoordinator = coordinator.persistentStoreCoordinator
        
        let fileManager = FileManager.default
        let storeName = "\(coordinator.modelName)" + "sqlite"
        
        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let persistentStoreURL = documentsDirectoryURL?.appendingPathComponent(storeName)
        
        var databaseError: DatabaseError?
        do {
            let options = [
                NSMigratePersistentStoresAutomaticallyOption: true,
                NSInferMappingModelAutomaticallyOption: true
            ]
            
            try storeCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                    configurationName: nil,
                                                    at: persistentStoreURL,
                                                    options: options)
        } catch {
            databaseError = .store(model: coordinator.modelName)
        }
        
        if let error = databaseError {
            return .failure(error)
        }
        
        return .success(coordinator)
    }
}

extension CoreDataCoordinator: CoreDataProtocol {
    
    private func fillObject<T>(_ model: T.Type, object: NSManagedObject, keyedValues: [String : Any]) where T: Storable  {
        
        switch model {
            
        case is CityModel.Type:
            
            keyedValues.forEach { keyedValue in
                if keyedValue.key == "wheather" {
                    let childDescription = NSEntityDescription.entity(forEntityName: String(describing: WheatherModel.self),
                                                                      in: self.backgroundContext)
                    
                    if let childDescription = childDescription {
                        let childObject = NSManagedObject(entity: childDescription,
                                                          insertInto: self.backgroundContext)
                        fillObject(WheatherModel.self,
                                   object: childObject as! WheatherModel,
                                   keyedValues: keyedValue.value as! [String : Any])
                        
                        object.setValue(childObject, forKey: "wheather")
                        childObject.setValue(object, forKey: "city")
                    }
                } else {
                    object.setValue(keyedValue.value, forKey: keyedValue.key)
                }
            }
            
        case is WheatherModel.Type:
            keyedValues.forEach { keyedValue in
                switch keyedValue.key {
                case "fact":
                    let childDescription = NSEntityDescription.entity(forEntityName: String(describing: FactModel.self),
                                                                      in: self.backgroundContext)
                    if let childDescription = childDescription {
                        let childObject = NSManagedObject(entity: childDescription,
                                                          insertInto: self.backgroundContext)
                        fillObject(FactModel.self,
                                   object: childObject as! FactModel,
                                   keyedValues: keyedValue.value as! [String : Any])
                        
                        object.setValue(childObject, forKey: "fact")
                        childObject.setValue(object, forKey: "wheather")
                    }
                case "forecasts":
                    let keyedValues = keyedValue.value as! [[String : Any]]
                    var forecasts = Set<NSManagedObject>()
                    let childDescription = NSEntityDescription.entity(forEntityName: String(describing: ForecastModel.self),
                                                                      in: self.backgroundContext)
                    if let childDescription = childDescription {
                        keyedValues.forEach { forecastKeyedValue in
                            let childObject = NSManagedObject(entity: childDescription,
                                                              insertInto: self.backgroundContext)
                            fillObject(ForecastModel.self,
                                       object: childObject as! ForecastModel,
                                       keyedValues: forecastKeyedValue)
                            
                            forecasts.insert(childObject)
                            childObject.setValue(object, forKey: "wheather")
                        }
                    }
                    object.setValue(forecasts, forKey: "forecasts")
                default:
                    break
                }
            }
        case is FactModel.Type:
            keyedValues.forEach { keyedValue in
                if keyedValue.key != "wheather" {
                    object.setValue(keyedValue.value, forKey: keyedValue.key)
                }
            }
        case is ForecastModel.Type:
            keyedValues.forEach { keyedValue in
                
                switch keyedValue.key {
                    
                case "wheather":
                    break
                case "dayparts":
                    let keyedValues = keyedValue.value as! [[String : Any]]
                    var dayParts = Set<NSManagedObject>()
                    let childDescription = NSEntityDescription.entity(forEntityName: String(describing: DayPartsModel.self),
                                                                      in: self.backgroundContext)
                    if let childDescription = childDescription {
                        keyedValues.forEach { hourKeyedValue in
                            let childObject = NSManagedObject(entity: childDescription,
                                                              insertInto: self.backgroundContext)
                            fillObject(HourModel.self,
                                       object: childObject as! DayPartsModel,
                                       keyedValues: hourKeyedValue)
                            
                            dayParts.insert(childObject)
                            childObject.setValue(object, forKey: "forecast")
                        }
                    }
                    object.setValue(dayParts, forKey: "dayparts")
                case "hours":
                    let keyedValues = keyedValue.value as! [[String : Any]]
                    var hours = Set<NSManagedObject>()
                    let childDescription = NSEntityDescription.entity(forEntityName: String(describing: HourModel.self),
                                                                      in: self.backgroundContext)
                    if let childDescription = childDescription {
                        keyedValues.forEach { hourKeyedValue in
                            let childObject = NSManagedObject(entity: childDescription,
                                                              insertInto: self.backgroundContext)
                            fillObject(HourModel.self,
                                       object: childObject as! HourModel,
                                       keyedValues: hourKeyedValue)
                            
                            hours.insert(childObject)
                            childObject.setValue(object, forKey: "forecast")
                        }
                    }
                    object.setValue(hours, forKey: "hours")
                default:
                    object.setValue(keyedValue.value, forKey: keyedValue.key)
                }
            }
        case is HourModel.Type:
            keyedValues.forEach { keyedValue in
                if keyedValue.key != "forecast" {
                    object.setValue(keyedValue.value, forKey: keyedValue.key)
                }
            }
        case is DayPartsModel.Type:
            keyedValues.forEach { keyedValue in
                if keyedValue.key != "forecast" {
                    object.setValue(keyedValue.value, forKey: keyedValue.key)
                }
            }
        default:
            return
            
        }
    }
    
    func create<T>(_ model: T.Type, keyedValues: [[String : Any]], completion: @escaping (Result<[T], DatabaseError>) -> Void) where T : Storable {
        self.backgroundContext.perform { [weak self] in
            guard let self = self else { return }
            
            var entities: [Any] = Array(repeating: true, count: keyedValues.count)
            
            keyedValues.enumerated().forEach { (index, keyedValues) in
                guard let entityDescription = NSEntityDescription.entity(forEntityName: String(describing: model.self),
                                                                         in: self.backgroundContext)
                else {
                    completion(.failure(.wrongModel))
                    return
                }
                
                let entity = NSManagedObject(entity: entityDescription,
                                             insertInto: self.backgroundContext)
                self.fillObject(T.self, object: entity, keyedValues: keyedValues)
                entities[index] = entity
            }
            
            guard let objects = entities as? [T] else {
                completion(.failure(.wrongModel))
                return
            }
            
            guard self.backgroundContext.hasChanges else {
                completion(.failure(.store(model: String(describing: model.self))))
                return
            }
            
            do {
                try self.backgroundContext.save()
                
                self.mainContext.perform {
                    completion(.success(objects))
                }
            } catch let error {
                completion(.failure(.error(desription: "Unable to save changes of main context.\nError - \(error.localizedDescription)")))
            }
        }
    }
    
    func update<T>(_ model: T.Type, predicate: NSPredicate?, keyedValues: [String: Any], completion: @escaping (Result<[T], DatabaseError>) -> Void) where T : Storable {
        self.fetch(model, predicate: predicate) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let fetchedObjects):
                guard let fetchedObjects = fetchedObjects as? [NSManagedObject] else {
                    completion(.failure(.wrongModel))
                    return
                }
                
                self.backgroundContext.perform {
                    fetchedObjects.forEach { fetchedObject in
                        self.fillObject(T.self, object: fetchedObject, keyedValues: keyedValues)
                    }
                    
                    let castFetchedObjects = fetchedObjects as? [T] ?? []
                    
                    guard self.backgroundContext.hasChanges else {
                        completion(.failure(.store(model: String(describing: model.self))))
                        return
                    }
                    
                    do {
                        try self.backgroundContext.save()
                        
                        self.mainContext.perform {
                            completion(.success(castFetchedObjects))
                        }
                    } catch let error {
                        self.mainContext.perform {
                            completion(.failure(.error(desription: "Unable to save changes of main context.\nError - \(error.localizedDescription)")))
                        }
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func delete<T>(_ model: T.Type, predicate: NSPredicate?, completion: @escaping (Result<[T], DatabaseError>) -> Void) where T : Storable {
        self.fetch(model, predicate: predicate) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let fetchedObjects):
                guard let fetchedObjects = fetchedObjects as? [NSManagedObject] else {
                    completion(.failure(.wrongModel))
                    return
                }
                
                self.backgroundContext.perform {
                    fetchedObjects.forEach { fetchedObject in
                        self.backgroundContext.delete(fetchedObject)
                    }
                    let deletedObjects = fetchedObjects as? [T] ?? []
                    
                    guard self.backgroundContext.hasChanges else {
                        completion(.failure(.store(model: String(describing: model.self))))
                        return
                    }
                    
                    do {
                        try self.backgroundContext.save()
                        
                        self.mainContext.perform {
                            completion(.success(deletedObjects))
                        }
                    } catch let error {
                        self.mainContext.perform {
                            completion(.failure(.error(desription: "Unable to save changes of main context.\nError - \(error.localizedDescription)")))
                        }
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteAll<T>(_ model: T.Type, completion: @escaping (Result<[T], DatabaseError>) -> Void) where T : Storable {
        self.delete(model, predicate: nil, completion: completion)
    }
    
    func fetch<T>(_ model: T.Type, predicate: NSPredicate?, completion: @escaping (Result<[T], DatabaseError>) -> Void) where T : Storable {
        guard let model = model as? NSManagedObject.Type else {
            completion(.failure(.wrongModel))
            return
        }
        
        self.backgroundContext.perform {
            let request = model.fetchRequest()
            request.predicate = predicate
            guard
                let fetchRequestResult = try? self.backgroundContext.fetch(request),
                let fetchedObjects = fetchRequestResult as? [T]
            else {
                self.mainContext.perform {
                    completion(.failure(.wrongModel))
                }
                return
            }
            
            self.mainContext.perform {
                completion(.success(fetchedObjects))
            }
        }
    }
    
    func fetchAll<T>(_ model: T.Type, completion: @escaping (Result<[T], DatabaseError>) -> Void) where T : Storable {
        self.fetch(model, predicate: nil, completion: completion)
    }
}
