//
//  EventRepository.swift
//  Marvel
//
//  Created by Mark Dalton on 7/6/21.
//

import CoreData

/// Protocol for describing a event repository.
protocol EventRepositoryInterface {
    /// Get a event using predicate
    /// - Parameter predicate: Predicate
    func getEvents(character: Character, predicate: NSPredicate?) -> Result<[Event], Error>
    
    /// Creates a event on persistance layer.
    /// - Parameter eventModel: The event being created.
    func create(eventModel: EventModel, for character: Character) -> Result<Event, Error>
}

protocol EventDomainModel {
    associatedtype DomainModelType
    func toDomainModel(character: CharacterModel) -> DomainModelType
}

/// Event repository class.
class EventRepository {
    /// The Core Data event repository.
    private let repository: CoreDataRepository<Event>
    
    /// Initializer
    /// - Parameter context: The context for storing and querying Core Data.
    init(context: NSManagedObjectContext) {
        self.repository = CoreDataRepository<Event>(managedObjectContext: context)
    }
}

extension EventRepository: EventRepositoryInterface {
    /// Get events from prediate
    /// - Parameter predicate: Predicate used.
    /// - Returns: Result of event list or error.
    @discardableResult func getEvents(character: Character, predicate: NSPredicate?) -> Result<[Event], Error> {
        let result = repository.get(predicate: predicate, sortDescriptors: nil)
        switch result {
        case .success(let eventList):
            return .success(eventList)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    /// Creates a event on the persitance layer.
    /// - Parameter eventModel: Event to create.
    /// - Returns: Result consiting of a Bool set to true or error.
    @discardableResult func create(eventModel: EventModel, for character: Character) -> Result<Event, Error> {
        let result = repository.create()
        switch result {
        case .success(let event):
            event.name = eventModel.name
            event.imageUrl = eventModel.imageUrl
            event.desc = eventModel.description
            event.mutableSetValue(forKey: "characters").add(character)
            repository.save()
            return .success(event)
        case .failure(let error):
            return .failure(error)
        }
    }
}
