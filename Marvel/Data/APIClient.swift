//
//  APIClient.swift
//  Marvel
//
//  Created by Mark Dalton on 7/3/21.
//
import Foundation

/// API client conforming to ACI client protocol.
class APIClient: APIClientProtocol {
    
    /// Get characters from api.
    /// - Parameters:
    ///   - offset: Offset for list of characters.
    ///   - completion: Completion passing character codable result.
    func getCharacters(with offset: Int, completion: @escaping (Result<CharacterWelcome, APIError>) -> Void) {
        fetchInfo(.listCharacters(offset: offset), decode: {
            json -> CharacterWelcome? in
            guard let result = json as? CharacterWelcome else { return  nil }
            return result
        }, complete: completion)
    }
    
    /// Get events from api.
    /// - Parameters:
    ///   - charId: Character id used.
    ///   - completion: Completion passing event codable result.
    func getEvents(from charId: String, completion: @escaping (Result<EventWelcome, APIError>) -> Void) {
        fetchInfo(.listEvents(charId: charId), decode: {
            json -> EventWelcome? in
            guard let result = json as? EventWelcome else { return  nil }
            return result
        }, complete: completion)
    }
}
