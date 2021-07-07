//
//  MarvelDetailViewModel.swift
//  Marvel
//
//  Created by Mark Dalton on 7/6/21.
//

import UIKit
import CoreData

/// Marvel detail view model.
class MarvelDetailViewModel {
    
    /// Reload table view closure.
    var reloadTableViewClosure: (()->())?
    
    /// Data repository.
    private var dataRepo: DataRepository
    
    /// Model.
    private var model: MarvelDetailModel
    
    /// Types of items.
    let stories = "Stories", events = "Events", comics = "Comics"
    
    /// Section headers.
    var sectionHeaders: [String] {
        return [
            //stories,
            events,
            //comics,
        ]
    }
    
    /// Number of events.
    var numberOfEvents: Int {
        return model.events.count
    }
    
    /// Stories.
    var storiesList: [String] {
        return []
    }
    
    /// Events.
    var eventList: [Event] {
        return model.events
    }
    
    /// Comics.
    var comicsList: [String] {
        return []
    }
    
    /// Character associated with page.
    var character: Character {
        return model.character
    }
    
    /// Initializer for detail view model.
    /// - Parameters:
    ///   - dataRepo: Data repository.
    ///   - model: Model.
    init(dataRepo: DataRepository, model: MarvelDetailModel) {
        self.dataRepo = dataRepo
        self.model = model
        
        // Set closure from model to view.
        model.reloadTableViewClosure = { [weak self] in
            self?.reloadTableViewClosure?()
        }
    }
    
    /// Fetch events for page.
    func fetchEvents() {
        
        // Fetch events from local.
        dataRepo.fetchEventFromLocal(with: character) { [weak self] result in
            
            // Fetch result.
            switch result {
            
            // Fetch was successful.
            case .success(let events):
                
                // If local results exists.
                if events.count > Int.zero {
                    
                    // Set to events.
                    self?.model.events = events
                    
                } else if let character = self?.character {
                    
                    // If internet if offline.
                    if !NetworkMonitor.shared.isReachable {
                        
                        // Create fake offline event to display.
                        self?.model.events = [OfflineEvent()]
                        return
                    }
                    
                    // Otherwise fetch from remote.
                    self?.dataRepo.fetchEventsFromRemote(with: character, complete: { result in
                        
                        // Fetch result.
                        switch result {
                        
                        // Fetch was successful.
                        case .success(var eventModels):
                            if eventModels.isEmpty {
                                eventModels.append(EventModel(name: "No Events Found", imageUrl: "", description: "No Events for \(character.name ?? "")."))
                            }
                            
                            // Save to local.
                            self?.dataRepo.save(eventModels, for: character, completion: { events in
                                
                                // Set to events.
                                self?.model.events = events
                            })
                            
                        // Remote fetch failed.
                        case .failure(let error):
                            
                            // Print error.
                            print(error.localizedDescription)
                        }
                    })
                }
                
            // Local fetch failed.
            case .failure(let error):
                
                // Print error.
                print(error.localizedDescription)
            }
        }
    }

}

// Fake offline event used when no internet.
class OfflineEvent: Event {}
