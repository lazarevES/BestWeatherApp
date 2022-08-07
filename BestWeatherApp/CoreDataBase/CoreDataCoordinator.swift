//
//  CoreDataCoordinator.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 05.08.2022.
//

import Foundation
import CoreData

class CoreDataCoordinator {
    
    private enum CompletionHandlerType {
        case success
        case failure(error: DatabaseError)
    }
    
    let modelName: String
    
    private let model: NSManagedObjectModel
    private let persistentStoreCoordinator: NSPersistentStoreCoordinator
    
    private lazy var saveContext: NSManagedObjectContext = {
        let masterContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        masterContext.parent = self.mainContext
        masterContext.mergePolicy = NSOverwriteMergePolicy
        return masterContext
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        let mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.parent = self.masterContext
        mainContext.mergePolicy = NSOverwriteMergePolicy
        return mainContext
    }()
    
    private lazy var masterContext: NSManagedObjectContext = {
        let masterContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        masterContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        masterContext.mergePolicy = NSOverwriteMergePolicy
        return masterContext
    }()
    
    private let mainQueue = DispatchQueue.main
    
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
    
    static func CreateDataBase() -> CoreDataProtocol {
        let bundle = Bundle.main
        guard let url = bundle.url(forResource: "WheatherModel", withExtension: "momd") else {
            fatalError("Can't find DatabaseDemo.xcdatamodelId in main Bundle")
        }
        
        switch CoreDataCoordinator.create(url: url) {
        case .success(let database):
            return database
        case .failure:
            switch CoreDataCoordinator.create(url: url) {
            case .success(let database):
                return database
            case .failure(let error):
                fatalError("Unable to create CoreData Database. Error - \(error.localizedDescription)")
            }
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
    
    private func save(with context: NSManagedObjectContext,
                      completionHandler: (() -> Void)? = nil,
                      failureCompletion: ((DatabaseError) -> Void)? = nil) {
        
        guard context.hasChanges else {
            if context.parent != nil {
                self.handler(for: .failure(error: .error(desription: "Context has not changes")),
                             using: context,
                             contextWorksInOwnQueue: false,
                             with: completionHandler,
                             and: failureCompletion)
            }
            return
        }
        
        context.perform {
            do {
                try context.save()
            } catch let error {
                if context.parent != nil {
                    self.handler(for: .failure(error: .error(desription: "Unable to save changes of context.\nError - \(error.localizedDescription)")),
                                 using: context,
                                 with: completionHandler,
                                 and: failureCompletion)
                }
            }
            
            guard let parentContext = context.parent else { return }
            
            self.handler(for: .success, using: context, with: completionHandler, and: failureCompletion)
            self.save(with: parentContext, completionHandler: completionHandler, failureCompletion: failureCompletion)
        }
    }
    
    private func handler(for type: CompletionHandlerType,
                         using context: NSManagedObjectContext,
                         contextWorksInOwnQueue: Bool = true,
                         with completionHandler: (() -> Void)?,
                         and failureCompletion: ((DatabaseError) -> Void)?) {
        switch type {
        case .success:
            if context.concurrencyType == .mainQueueConcurrencyType {
                if contextWorksInOwnQueue {
                    completionHandler?()
                } else {
                    self.mainContext.perform {
                        completionHandler?()
                    }
                }
            }
        case .failure(let error):
            if context.concurrencyType == .privateQueueConcurrencyType {
                if context.parent != nil {
                    self.mainContext.perform {
                        failureCompletion?(error)
                    }
                }
            } else {
                if contextWorksInOwnQueue {
                    failureCompletion?(error)
                } else {
                    self.mainContext.perform {
                        failureCompletion?(error)
                    }
                }
            }
        }
    }
}

extension CoreDataCoordinator: CoreDataProtocol {
    
    private func getObject(entity: Storable, type: String, parent: NSManagedObject? = nil) -> NSManagedObject?  {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: String(describing: type),
                                                                 in: self.saveContext)
        else { return nil }
        let object = NSManagedObject(entity: entityDescription,
                                     insertInto: self.saveContext)
        object.setValuesForKeys(entity.keyedValues)
        
        switch type {
        case "CityModel":
            
            if let entity = entity as? City, let wheather = entity.wheather {
                let wheatherModel = getObject(entity: wheather, type: "WheatherModel", parent: object)
                if let wheatherModel = wheatherModel {
                    object.setValue(wheatherModel, forKey: "wheather")
                } else { return nil }
            } else { return nil }
            
        case "WheatherModel":
            
            if let entity = entity as? Wheather {
                object.setValue(parent, forKey: "city")
                
                if let fact = entity.fact {
                    let factModel = getObject(entity: fact, type: "FactModel", parent: object)
                    if let factModel = factModel {
                        object.setValue(factModel, forKey: "fact")
                    } else { return nil }
                } else { return nil }
                
                let forecastModelOptional = entity.forecasts.map({ forecast -> ForecastModel? in
                    let forecastModel = getObject(entity: forecast, type: "ForecastModel", parent: object)
                    if let forecastModel = forecastModel {
                        return forecastModel as? ForecastModel
                    }
                    return nil
                })
                
                var forecastModel = Set<ForecastModel>()
                forecastModelOptional.forEach { forecast in
                    if let forecast = forecast {
                        forecastModel.insert(forecast)
                    }
                }
                
                object.setValue(forecastModel, forKey: "forecasts")
                
            } else { return nil }
            
        case "FactModel":
            object.setValue(parent, forKey: "wheather")
        case "ForecastModel":
            object.setValue(parent, forKey: "wheather")
            
            if let entity = entity as? Forecast {
                
                let HoursModelOptional = entity.hours.map({ hour -> HourModel? in
                    let HoursModel = getObject(entity: hour, type: "HourModel", parent: object)
                    if let HoursModel = HoursModel {
                        return HoursModel as? HourModel
                    }
                    return nil
                })
                
                var HoursModel = Set<HourModel>()
                HoursModelOptional.forEach { hour in
                    if let hour = hour {
                        HoursModel.insert(hour)
                    }
                }
                object.setValue(HoursModel, forKey: "hours")
            } else { return nil }
            
        case "HourModel":
            object.setValue(parent, forKey: "forecast")
        default:
            return nil
        }
        
        return object
        
    }
    
    func create(_ city: City, completion: @escaping (Result<City, DatabaseError>) -> Void) {
        self.saveContext.perform { [weak self] in
            guard let self = self else { return }
            
            let object = self.getObject(entity: city, type: "CityModel")
            
            guard object is CityModel else {
                self.mainContext.perform {
                    completion(.failure(.wrongModel))
                }
                return
            }
            
            self.save(with: self.saveContext,
                      completionHandler: {
                completion(.success(city))
            },
                      failureCompletion: { error in
                completion(.failure(error))
            })
        }
    }
    
    func update(_ city: City, predicate: NSPredicate?, completion: @escaping (Result<City, DatabaseError>) -> Void) {
        self.fetchModel(predicate: predicate) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let fetchedObjects):
                guard let fetchedObjects = fetchedObjects as? [NSManagedObject], !fetchedObjects.isEmpty else {
                    completion(.failure(.wrongModel))
                    return
                }
                
                self.saveContext.perform {
                    
                    _ = self.getObject(entity: city, type: "CityModel")
                    
                    self.save(with: self.saveContext,
                              completionHandler: {
                        completion(.success(city))
                    },
                              failureCompletion: { error in
                        completion(.failure(error))
                    })
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func delete(predicate: NSPredicate?, completion: @escaping (Result<[City], DatabaseError>) -> Void) {
        self.fetchModel(predicate: predicate) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let fetchedObjects):
                guard let fetchedObjects = fetchedObjects as? [NSManagedObject], !fetchedObjects.isEmpty else {
                    completion(.failure(.wrongModel))
                    return
                }
                
                self.saveContext.perform {
                    fetchedObjects.forEach { fetchedObject in
                        self.saveContext.delete(fetchedObject)
                    }
                    
                    let currentFetchedObjects = fetchedObjects as? [CityModel] ?? []
                    let citys = currentFetchedObjects.map { cityModel in
                        return City(cityModel)
                    }
                    
                    self.save(with: self.saveContext,
                              completionHandler: {
                        completion(.success(citys))
                    },
                              failureCompletion: { error in
                        completion(.failure(error))
                    })
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteAll(completion: @escaping (Result<[City], DatabaseError>) -> Void) {
        self.delete(predicate: nil, completion: completion)
    }
    
    func fetch(predicate: NSPredicate?, completion: @escaping (Result<[City], DatabaseError>) -> Void) {
        
        self.saveContext.perform {
            let request = CityModel.fetchRequest()
            request.predicate = predicate
            
            guard
                let fetchRequestResult = try? self.saveContext.fetch(request)
            else {
                self.mainContext.perform {
                    completion(.failure(.wrongModel))
                }
                return
            }
                        
            let citys = fetchRequestResult.map { cityModel in
                return City(cityModel)
            }
            
            self.mainContext.perform {
                completion(.success(citys))
            }
        }
    }
    
    func fetchModel(predicate: NSPredicate?, completion: @escaping (Result<[CityModel], DatabaseError>) -> Void) {
        
        self.saveContext.perform {
            let request = CityModel.fetchRequest()
            request.predicate = predicate
            
            guard
                let fetchRequestResult = try? self.saveContext.fetch(request)
            else {
                self.mainContext.perform {
                    completion(.failure(.wrongModel))
                }
                return
            }
                                
            self.mainContext.perform {
                completion(.success(fetchRequestResult))
            }
        }
    }
    
    func fetchAll(completion: @escaping (Result<[City], DatabaseError>) -> Void) {
        self.fetch(predicate: nil, completion: completion)
    }
    
}
