//
//  Event.swift
//  Marvel
//
//  Created by Mark Dalton on 7/6/21.
//

import Foundation

/// Event domain model.
struct EventModel {
    let name: String
    let imageUrl: String
    let description: String
}

// MARK: - EventWelcome
struct EventWelcome: Codable {
    let code: Int
    let status, copyright, attributionText, attributionHTML: String
    let etag: String
    let data: EventData
}

// MARK: - EventData
struct EventData: Codable {
    let offset, limit, total, count: Int
    let results: [EventResult]
}

// MARK: - EventResult
struct EventResult: Codable {
    let id: Int
    let title, resultDescription: String
    let resourceURI: String
    let urls: [EventURL]
    let modified: String
    let start, end: String?
    let thumbnail: EventThumbnail
    let creators: EventCreators
    let characters: EventCharacters
    let stories: EventStories
    let comics, series: EventCharacters
    let next, previous: EventNext?

    enum CodingKeys: String, CodingKey {
        case id, title
        case resultDescription = "description"
        case resourceURI, urls, modified, start, end, thumbnail, creators, characters, stories, comics, series, next, previous
    }
}

// MARK: - EventCharacters
struct EventCharacters: Codable {
    let available: Int
    let collectionURI: String
    let items: [EventNext]
    let returned: Int
}

// MARK: - EventNext
struct EventNext: Codable {
    let resourceURI: String
    let name: String
}

// MARK: - EventCreators
struct EventCreators: Codable {
    let available: Int
    let collectionURI: String
    let items: [EventCreatorsItem]
    let returned: Int
}

// MARK: - EventCreatorsItem
struct EventCreatorsItem: Codable {
    let resourceURI: String
    let name, role: String
}

// MARK: - EventStories
struct EventStories: Codable {
    let available: Int
    let collectionURI: String
    let items: [EventStoriesItem]
    let returned: Int
}

// MARK: - EventStoriesItem
struct EventStoriesItem: Codable {
    let resourceURI: String
    let name: String
    //let type: EventType
}

enum EventType: String, Codable {
    case cover = "cover"
    case interiorStory = "interiorStory"
}

// MARK: - EventThumbnail
struct EventThumbnail: Codable {
    let path: String
    let thumbnailExtension: String

    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}

// MARK: - EventURL
struct EventURL: Codable {
    let type: String
    let url: String
}
