//
//  Endpoint.swift
//  Marvel
//
//  Created by Mark Dalton on 7/3/21.
//

import UIKit
import CryptoSwift

/// Endpoint protocol.
protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
}

/// Endpoint util.
class EndpointUtil {
    static let limit = 100
    static let calls = 15
}

extension Endpoint {
    
    /// Url components used in request.
    var urlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queryItems
        return components
    }
}

/// Request type used.
enum RequestType {
    case listCharacters(offset: Int)
    case listEvents(charId: String)
}

extension RequestType: Endpoint {
    
    /// Scheme.
    var scheme: String {
        return "https"
    }
    
    /// Host.
    var host: String {
        return "gateway.marvel.com"
    }
    
    /// Path.
    var path: String {
        switch self {
        case .listCharacters: return "/v1/public/characters"
        case .listEvents(let charId): return "/v1/public/characters/\(charId)/events"
        }
    }
    
    /// Query items.
    var queryItems: [URLQueryItem] {
        
        /// Create query items.
        var items = [URLQueryItem]()
        
        // Check request type and add necessary items.
        switch self {
        case .listCharacters(let offset): items.append(URLQueryItem(name: "offset", value: String(offset)))
        case .listEvents: break
        }
        
        // Set timestamp.
        let ts = String(describing: Date().timeIntervalSince1970)
        
        // Set keys.
        let publicKey = "e1f340b61dfea7f0a3330faec41d0942"
        let privateKey = "132dfd20a61bc284dfa1ac468840f74241b806de"
        
        // Set hash.
        let hash = (ts + privateKey + publicKey).md5()
        
        // Set items.
        items.append(URLQueryItem(name: "apikey", value: publicKey))
        items.append(URLQueryItem(name: "ts", value: ts))
        items.append(URLQueryItem(name: "hash", value: hash))
        items.append(URLQueryItem(name: "limit", value: "100"))
        
        // Return items.
        return items
    }
}
