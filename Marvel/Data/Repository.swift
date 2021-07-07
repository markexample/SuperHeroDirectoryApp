//
//  Repository.swift
//  Marvel
//
//  Created by Mark Dalton on 7/4/21.
//
import CoreData

protocol Repository {
    
    /// The entity managed by the repository.
    associatedtype Entity
    
    /// Get an array of entities.
    /// - Parameters:
    ///   - predicate: The predicate used for fetching entities.
    ///   - sortDescriptors: The sort descriptors for sorting the returned array.
    func get(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> Result<[Entity], Error>
    
    /// Creates an entity.
    func create() -> Result<Entity, Error>
    
    /// Deletes an entity.
    /// - Parameter entity: The entity to be deleted.
    func delete(entity: Entity) -> Result<Bool, Error>
}
