//
//  CharRepository.swift
//  Marvel
//
//  Created by Mark Dalton on 7/4/21.
//

import CoreData

/// Protocol for describing a character repository.
protocol CharRepositoryInterface {
    /// Get a character using predicate
    /// - Parameter predicate: Predicate
    func getCharacters(predicate: NSPredicate?) -> Result<[Character], Error>
    
    /// Creates a character on persistance layer.
    /// - Parameter characterModel: The character being created.
    func create(characterModel: CharacterModel) -> Result<Character, Error>
}

protocol CharDomainModel {
    associatedtype DomainModelType
    func toDomainModel() -> DomainModelType
}

/// Character repository class.
class CharRepository {
    /// The Core Data character repository.
    private let repository: CoreDataRepository<Character>
    
    /// Initializer
    /// - Parameter context: The context for storing and querying Core Data.
    init(context: NSManagedObjectContext) {
        self.repository = CoreDataRepository<Character>(managedObjectContext: context)
    }
}

extension CharRepository: CharRepositoryInterface {
    /// Get characters from prediate
    /// - Parameter predicate: Predicate used.
    /// - Returns: Result of character list or error.
    @discardableResult func getCharacters(predicate: NSPredicate?) -> Result<[Character], Error> {
        let result = repository.get(predicate: predicate, sortDescriptors: nil)
        switch result {
        case .success(let characterList):
            return .success(characterList)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    /// Creates a character on the persitance layer.
    /// - Parameter characterModel: Character to create.
    /// - Returns: Result consiting of a Bool set to true or error.
    @discardableResult func create(characterModel: CharacterModel) -> Result<Character, Error> {
        let result = repository.create()
        switch result {
        case .success(let character):
            character.name = characterModel.name
            character.imageUrl = characterModel.imageUrl
            character.bio = characterModel.bio
            character.id = Int64(characterModel.id)
            repository.save()
            return .success(character)
        case .failure(let error):
            return .failure(error)
        }
    }
}
