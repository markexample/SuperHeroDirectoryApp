//
//  DBRepo.swift
//  Marvel
//
//  Created by Mark Dalton on 7/6/21.
//

import UIKit
import CoreData

/// DB Repository to contain each local repostiroy.
class DBRepository {
    
    /// Character repository.
    var charRepo: CharRepository!
    
    /// Event repository.
    var eventRepo: EventRepository!
    
    /// Initializer
    /// - Parameter context: Context used for local.
    init(context: NSManagedObjectContext) {
        self.charRepo = CharRepository(context: context)
        self.eventRepo = EventRepository(context: context)
    }
    
    /// Save characters locally.
    /// - Parameters:
    ///   - charactersModels: Character models.
    ///   - completion: Completion of saved characters.
    func save(_ charactersModels: [CharacterModel], completion: @escaping ([Character]) -> ()) {
        var characters = [Character]()
        charactersModels.forEach { charactersModel in
            let characterResult = charRepo?.create(characterModel: charactersModel)
            switch characterResult {
            case .success(let character):
                characters.append(character)
            case .failure(let error):
                print(error.localizedDescription)
            default: break
            }
        }
        completion(characters)
    }
    
    /// Save events locally.
    /// - Parameters:
    ///   - eventModels: Event models.
    ///   - character: Character associated with event.
    ///   - completion: Completion of saved events.
    func save(_ eventModels: [EventModel], for character: Character, completion: @escaping ([Event]) -> ()) {
        var events = [Event]()
        eventModels.forEach { event in
            let eventResult = eventRepo?.create(eventModel: event, for: character)
            switch eventResult {
            case .success(let event):
                events.append(event)
            case .failure(let error):
                print(error.localizedDescription)
            default: break
            }
        }
        completion(events)
    }
    
    /// Fetch characters from local.
    /// - Parameter completion: Completion of saved characters.
    func fetchCharacters(complete completion: @escaping (Result<[Character], Error>) -> Void) {
        if let result = charRepo?.getCharacters(predicate: NSPredicate(value: true)) {
            completion(result)
        }
    }
    
    /// Fetch events from local.
    /// - Parameters:
    ///   - character: Character associated with event.
    ///   - completion: Completion of saved events.
    func fetchEvents(with character: Character, complete completion: @escaping (Result<[Event], Error>) -> Void) {
        if let result = eventRepo?.getEvents(character: character, predicate: NSPredicate(format: "(ANY characters.id == %lld)", character.id)) {
            completion(result)
        }
    }
}
