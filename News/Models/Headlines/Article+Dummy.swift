//
//  Article+Dummy.swift
//  News
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 27/7/2025.
//

import Foundation

/// Convenience menthods to generate dummy Articles for the previews to work.
extension Article {
    static func dummyArticles(filteredBy sources: [Source]? = nil) -> [Article] {
        do {
            // Attempt to load and decode an array of Article objects
            let loadedArticles = try JsonLoader.loadJSON(filename: "top-headlines", type: Articles.self, jsonDecoder: Article.jsonDecoder)
            
            if let sources = sources {
                let sourceNames = sources.map { $0.name }
                return loadedArticles.articles.filter { sourceNames.contains($0.sourceName) }
            } else {
                return loadedArticles.articles
            }
        } catch {
            return []
        }
    }

    static func dummyArticle() -> Article {
        Article(
            author: "Anthony D'Alessandro",
            title: "‘Fantastic Four: First Steps’ Fires Up Thursday Night With Around $23M In Previews – Box Office - Deadline",
            description: "'Fantastic Four: First Steps' is posting $23M in previews, another robust start for superhero movies at the box office.",
            urlPath: "http://deadline.com/2025/07/box-office-fantastic-four-first-steps-1236468412/",
            urlPathToImage: "https://deadline.com/wp-content/uploads/2025/07/MCDFAFO_WD046.jpg?w=1024",
            publishedAt: Date(timeInterval: -6*60*60, since: Date()),
            content: "EXCLUSIVE: No, silly, superhero movies aren’t dead. The second comic-book movie in the last two weeks, Disney/Marvel Studios‘ The Fantastic Four: First Steps is conquering around $23 million in previ",
            sourceName: "Deadline"
        )
    }
}
