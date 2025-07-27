//
//  Source.swift
//  News
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 26/7/2025.
//

import Foundation

struct Sources: Codable {
    let status: String
    let sources: [Source]
}

struct Source: Codable, Hashable, Identifiable {
    let id = UUID()
    let identifier: String
    let name: String
    let description: String
    let urlPath: String
    let category: String
    let language: String
    let country: String
    
    var url: URL? {
        URL(string: self.urlPath)
    }
    
    init(identifier: String,
         name: String,
         description: String,
         urlPath: String,
         category: String,
         language: String,
         country: String) {
        self.identifier = identifier
        self.name = name
        self.description = description
        self.urlPath = urlPath
        self.category = category
        self.language = language
        self.country = country
    }
}

extension Source {
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case description
        case urlPath = "url"
        case category
        case language
        case country
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.identifier = try container.decode(String.self, forKey: .identifier)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decode(String.self, forKey: .description)
        self.urlPath = try container.decode(String.self, forKey: .urlPath)
        self.category = try container.decode(String.self, forKey: .category)
        self.language = try container.decode(String.self, forKey: .language)
        self.country = try container.decode(String.self, forKey: .country)
    }
}
