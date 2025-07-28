//
//  EndpointConfiguration.swift
//  News
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 27/7/2025.
//

import Foundation

/// EndpointConfiguration enum is used to define the URL configuration, like the url, path etc
enum EndpointConfiguration {
    static let apiKeyValue = "7a35900a3fa3479fac0c6d6ca5b3928e"
    static let baseURLString = "https://newsapi.org/v2"
    static let language = "en"
    static let languageKey = "language"
    static let apiKey = "apiKey"
    static let sourcesKey = "sources"

    case getHeadlines(sources: [String])
    case getSources

    var baseURL: URL {
        // Replace with your actual base URL
        guard let url = URL(string: Self.baseURLString) else {
            fatalError("Base URL is not valid!")
        }
        return url
    }
    
    var url: URL? {
        let queryItems: [URLQueryItem]

        switch self {
        case .getHeadlines(let sources):
            let params = [Self.apiKey: Self.apiKeyValue, Self.languageKey: Self.language, Self.sourcesKey: sources.joined(separator: ",")]
            queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
            
        case .getSources:
            let params: [String: String] = [Self.apiKey: Self.apiKeyValue, Self.languageKey: Self.language]
            queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        var components = URLComponents(string: Self.baseURLString.appending(path))
        components?.queryItems = queryItems
        return components?.url
    }

    var path: String {
        switch self {
        case .getHeadlines:
            return "/top-headlines"
        case .getSources:
            return "/top-headlines/sources"
        }
    }

    var urlRequest: URLRequest? {
        guard let url = self.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}
