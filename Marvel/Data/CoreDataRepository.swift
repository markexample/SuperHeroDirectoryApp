//
//  CoreDataRepository.swift
//  Marvel
//
//  Created by Mark Dalton on 7/4/21.
//

import UIKit
import CoreData

/// Enum for CoreData errors
enum CoreDataError: Error {
    case invalidManagedObject
}

/// Generic class for handling NSManagedObject subclasses.
class CoreDataRepository<T: NSManagedObject>: Repository {
    typealias Entity = T
    
    /// The NSManagedObjectContext instance used for performing operations.
    private let managedObjectContext: NSManagedObjectContext
    
    /// Initializer
    /// - Parameter managedObjectContext: The instance for performing operations.
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    /// Get array of entities.
    /// - Parameters:
    ///   - predicate: Predicate for fetching.
    ///   - sortDescriptors: Sort descriptors for sorting results.
    /// - Returns: A result consiting of an array of entities or an error.
    func get(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> Result<[T], Error> {
        /// Fetch request for NSMAnagedObjectContext type.
        let request = Entity.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        do {
            /// Perform fetch request
            if let result = try managedObjectContext.fetch(request) as? [Entity] {
                return .success(result)
            } else {
                return .failure(CoreDataError.invalidManagedObject)
            }
        } catch {
            return .failure(error)
        }
    }
    
    /// Creates an entity.
    /// - Returns: A result consisting of an entity or an error.
    func create() -> Result<T, Error> {
        guard let managedObject = NSEntityDescription.insertNewObject(forEntityName: String(describing: Entity.self), into: managedObjectContext) as? Entity else {
            return .failure(CoreDataError.invalidManagedObject)
        }
        return .success(managedObject)
    }
    
    /// Deletes an entity.
    /// - Parameter entity: The NSManagedObject to be deleted.
    /// - Returns: A result of a Bool set to true or an error.
    func delete(entity: T) -> Result<Bool, Error> {
        managedObjectContext.delete(entity)
        return .success(true)
    }
    
    /// Save the context
    /// - Returns: True or error.
    @discardableResult func save() -> Result<Bool, Error> {
        do {
            try managedObjectContext.save()
            return .success(true)
        } catch {
            managedObjectContext.rollback()
            return .failure(error)
        }
    }
}
