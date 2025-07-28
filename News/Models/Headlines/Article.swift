//
//  Article.swift
//  News
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 26/7/2025.
//

import Foundation

/// The response from headlines API is captured in Articles model.
struct Articles: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

struct Article: Codable, Hashable, Identifiable {
    let id = UUID()
    let author: String?
    let title: String
    let description: String?
    let urlPath: String
    let urlPathToImage: String?
    let publishedAt: Date
    let content: String?
    let sourceName: String
    
    init(author: String? = nil,
         title: String,
         description: String? = nil,
         urlPath: String,
         urlPathToImage: String? = nil,
         publishedAt: Date,
         content: String? = nil,
         sourceName: String) {
        self.author = author
        self.title = title
        self.description = description
        self.urlPath = urlPath
        self.urlPathToImage = urlPathToImage
        self.publishedAt = publishedAt
        self.content = content
        self.sourceName = sourceName
    }
    
    var url: URL? {
        URL(string: self.urlPath)
    }
    
    var urlToImage: URL? {
        guard let urlPath = self.urlPathToImage else { return nil }
        return URL(string: urlPath)
    }
    
    /// Used as the dates in the JSON are amongst the following formats. Any unknown format will make the parser fail
    static let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        let dateFormatters = [DateFormatter.isoDateFormatter,
                              DateFormatter.isoWithMilliSecondsDateFormatter,
                              DateFormatter.isoWithColonTimeZoneDateFormatter,
                              DateFormatter.isoWithoutTimeZoneDateFormatter]
        
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            for dateFormatter in dateFormatters {
                if let date = dateFormatter.date(from: dateString) {
                    return date
                } else {
                    continue
                }
            }
            
            throw DecodingError.dataCorruptedError(in: container,
                                                   debugDescription: "Cannot decode date string \(dateString)")
        }
        
        return decoder
    }()
}

extension Article {
    enum CodingKeys: String, CodingKey {
        case author
        case title
        case description
        case urlPath = "url"
        case urlPathToImage = "urlToImage"
        case publishedAt
        case content
        case sourceName = "source" // For nested parsing
    }
    
    enum SourceKeys: String, CodingKey {
        case name
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.author = try container.decodeIfPresent(String.self, forKey: .author)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.urlPath = try container.decode(String.self, forKey: .urlPath)
        self.urlPathToImage = try container.decodeIfPresent(String.self, forKey: .urlPathToImage)
        self.publishedAt = try container.decode(Date.self, forKey: .publishedAt)
        self.content = try container.decodeIfPresent(String.self, forKey: .content)
        
        // Handle nested 'source' object
        let sourceContainer = try container.nestedContainer(keyedBy: SourceKeys.self, forKey: .sourceName)
        
        // Decode properties from the nested container
        self.sourceName = try sourceContainer.decode(String.self, forKey: .name)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(author, forKey: .author)
        try container.encode(title, forKey: .title)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encode(urlPath, forKey: .urlPath)
        try container.encodeIfPresent(urlPathToImage, forKey: .urlPathToImage)
        try container.encode(publishedAt, forKey: .publishedAt)
        try container.encodeIfPresent(content, forKey: .content)
        
        // Create and encode into a nested container for sourceName
        var sourceContainer = container.nestedContainer(keyedBy: SourceKeys.self, forKey: .sourceName)
        try sourceContainer.encode(sourceName, forKey: .name)
    }
}
