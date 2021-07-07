//
//  WebRepository.swift
//  Marvel
//
//  Created by Mark Dalton on 7/3/21.
//

import UIKit
import CoreData

/// Data repository protocol.
protocol DataRepositoryProtocol {
    func fetchCharactersFromLocal(complete completion: @escaping (Result<[Character], Error>) -> Void)
    func fetchCharactersFromRemote(withOffset offset: Int, complete completion: @escaping (Result<[CharacterModel], Error>) -> Void)
    func save(_ characterModels: [CharacterModel], completion: @escaping ([Character]) -> ())
    func save(_ eventModels: [EventModel], for character: Character, completion: @escaping ([Event]) -> ())
}

/// Data repostiroy for network operations.
class DataRepository {
    
    /// API client for remote calls.
    private let apiClient: APIClient
    
    /// DB Client for local calls.
    private var dbRepo: DBRepository
    
    /// Initializer for data repository.
    /// - Parameters:
    ///   - apiClient: Api client used.
    ///   - context: Context used for local.
    init(apiClient: APIClient = APIClient(), context: NSManagedObjectContext) {
        self.apiClient = apiClient
        self.dbRepo = DBRepository(context: context)
    }
}

extension DataRepository: DataRepositoryProtocol {
    
    /// Save local character.
    /// - Parameters:
    ///   - characterModels: Character model list.
    ///   - completion: Completion of saved character type.
    func save(_ characterModels: [CharacterModel], completion: @escaping ([Character]) -> ()) {
        dbRepo.save(characterModels) { characters in
            completion(characters)
        }
    }
    
    /// Save local event.
    /// - Parameters:
    ///   - eventModels: Event model list.
    ///   - character: Local character associated with event.
    ///   - completion: Completion of saved event type.
    func save(_ eventModels: [EventModel], for character: Character, completion: @escaping ([Event]) -> ()) {
        dbRepo.save(eventModels, for: character) { events in
            completion(events)
        }
    }
    
    /// Fetch characters from local.
    /// - Parameter completion: Completion of saved character type.
    func fetchCharactersFromLocal(complete completion: @escaping (Result<[Character], Error>) -> Void) {
        dbRepo.fetchCharacters(complete: completion)
    }
    
    /// Fetch characters from remote.
    /// - Parameters:
    ///   - offset: Offset used.
    ///   - completion: Completion of character models.
    func fetchCharactersFromRemote(withOffset offset: Int, complete completion: @escaping (Result<[CharacterModel], Error>) -> Void) {
        apiClient.getCharacters(with: offset) { result in
            switch result {
            case .success(let result):
                completion(.success(result.toDomainModel()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Fetch events from local.
    /// - Parameters:
    ///   - character: Character used.
    ///   - completion: Completion of saved events.
    func fetchEventFromLocal(with character: Character, complete completion: @escaping (Result<[Event], Error>) -> Void) {
        dbRepo.fetchEvents(with: character, complete: completion)
    }
    
    /// Fetch events from remote.
    /// - Parameters:
    ///   - character: Character associated with event.
    ///   - completion: Completion of event models.
    func fetchEventsFromRemote(with character: Character, complete completion: @escaping (Result<[EventModel], Error>) -> Void) {
        apiClient.getEvents(from: String(character.id)) { result in
            switch result {
            case .success(let result):
                completion(.success(result.toDomainModel()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}

extension CharacterWelcome {
    private func getImageUrl(_ char: ResultStruct) -> String {
        return "\(char.thumbnail.path.replacingOccurrences(of: "http:", with: "https:")).\(char.thumbnail.thumbnailExtension.rawValue)"
    }
    
    func toDomainModel() -> [CharacterModel] {
        return data.results.map { CharacterModel(name: $0.name, imageUrl: getImageUrl($0), bio: $0.resultDescription, id: $0.id) }
    }
}

extension EventWelcome {
    private func getImageUrl(_ char: EventResult) -> String {
        return "\(char.thumbnail.path.replacingOccurrences(of: "http:", with: "https:")).\(char.thumbnail.thumbnailExtension)"
    }
    
    func toDomainModel() -> [EventModel] {
        return data.results.map { EventModel(name: $0.title, imageUrl: getImageUrl($0), description: $0.resultDescription) }
    }
}
