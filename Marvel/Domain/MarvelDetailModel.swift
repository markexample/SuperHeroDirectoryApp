//
//  MarvelDetailModel.swift
//  Marvel
//
//  Created by Mark Dalton on 7/6/21.
//

import UIKit

/// Marvel detail domain model.
class MarvelDetailModel: NSObject {
    
    /// Reloading table view closure.
    var reloadTableViewClosure: (()->())?
    
    /// Character associated with detail page.
    var character: Character!
    
    /// Events for detail page.
    var events = [Event]() {
        didSet {
            
            // Reload table view.
            reloadTableViewClosure?()
        }
    }
    
    /// Initializer for marvel detail domain model.
    /// - Parameter character: Character associated with detail page.
    init(character: Character) {
        self.character = character
    }
}
