//
//  Source+Dummy.swift
//  News
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 27/7/2025.
//

/// Convenience menthods to generate dummy Sources for the previews to work.
extension Source {
    static func dummySourcess() -> [Source] {
        do {
            // Attempt to load and decode an array of source objects
            let loadedSources = try JsonLoader.loadJSON(filename: "sources", type: Sources.self)
            return loadedSources.sources
        } catch {
            return [Source.dummySource()]
        }
    }
    
    static func dummySource(identifier: String = "abc-news", name: String = "ABC News") -> Source {
        Source(
            identifier: identifier,
            name: name,
            description: "Your trusted source for breaking news, analysis, exclusive interviews, headlines, and videos at ABCNews.com.",
            urlPath: "https://abcnews.go.com",
            category: "general",
            language: "en",
            country: "us"
        )
    }
}

extension SourceItem {
    static func dummySourceItems() -> [SourceItem] {
        Source.dummySourcess().map { SourceItem(source: $0, isSelected: false) }
    }
}
