//
//  MarvelListViewModel.swift
//  Marvel
//
//  Created by Mark Dalton on 7/3/21.
//

import UIKit
import CoreData

/// Marvel list view model, contains business logic.
final class MarvelListViewModel {
    
    /// Data repository for network operations.
    private var dataRepo: DataRepository
    
    /// Reload table view closure.
    var reloadTableViewClosure: (()->())?
    
    /// Character list used for original data source without filtering.
    var characterList = [Character]() {
        
        // When set, have the filtered main data source set to it.
        didSet {
            filteredList = characterList
            
            // Reload table view.
            reloadTableViewClosure?()
        }
    }
    
    // Filtered list for main data source and filtering.
    var filteredList = [Character]()
    
    // Batch list used when reading multiple concurrent API calls.
    private var batchList = [Character]()
    
    // Initializer for view model passing injecting the data repository.
    init(dataRepo: DataRepository) {
        self.dataRepo = dataRepo
    }
    
    
    // Fetch characters for list.
    func fetchCharacters() {
        
        // Fetch characters from data repository from local data source.
        dataRepo.fetchCharactersFromLocal { [weak self] result in
            
            // Result of fetch.
            switch result {
            
            // Fetch was successful.
            case .success(let characters):
                
                // If local data source has results.
                if characters.count > Int.zero {
                    
                    // Set the character list to the results.
                    self?.characterList = characters
                } else {
                    
                    // Else fetch characters from remote data source.
                    self?.fetchCharactersFromRemote(completion: { characterModels in
                        
                        // Save character model results to local.
                        self?.dataRepo.save(characterModels) { characters in
                            
                            // Set character list to saved result.
                            self?.characterList = characters
                        }
                    })
                }
                
            // Fetch failed.
            case .failure(let error):
                
                // Print error.
                print(error.localizedDescription)
            }
        }
    }
    
    /// Fetch characters from remote.
    /// - Parameter completion: Completion handler after fetch completes.
    private func fetchCharactersFromRemote(completion: @escaping (([CharacterModel]) -> ())) {
        
        // Create DispatchGroup.
        let group = DispatchGroup()
        
        // Create list of character models.
        var characterModels = [CharacterModel]()
        
        // Loop through number of calls.
        for i in Int.zero ..< EndpointUtil.calls {
            
            // Enter group.
            group.enter()
            
            // Fetch characters from data repository from remote with offsetting the call limits.
            dataRepo.fetchCharactersFromRemote(withOffset: i * EndpointUtil.limit, complete: { result in
                
                // Result of fetch.
                switch result {
                
                // Fetch was successful.
                case .success(let characterResults):
                    characterModels.append(contentsOf: characterResults)
                    
                // Fetch failed.
                case .failure(let error):
                    
                    // Print error.
                    print(error.localizedDescription)
                }
                
                // Leave group.
                group.leave()
            })
        }
        
        // When all the calls have finished.
        group.notify(queue: .main) {
            
            // Sort the list alphabetically by name.
            characterModels = characterModels.sorted { $0.name < $1.name }
            
            // Completion handler called passing final resulting character models list.
            completion(characterModels)
        }
    }
}

#if DEBUG
// Used for testing private method.
extension MarvelListViewModel {
    public func testFetchCharactersFromRemote(completion: @escaping ([CharacterModel]) -> ()) {
        fetchCharactersFromRemote { characterModels in
            completion(characterModels)
        }
    }
}
#endif
