//
//  ArticleListItemView.swift
//  News
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 26/7/2025.
//

import SwiftUI

/// ArticleListItemView is custom container view that holds the Article capturing the details in a List
struct ArticleListItemView: View {
    @State var article: Article

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .center, spacing: 16) {
                    AsyncImageView(url: article.urlToImage, contentMode: .fill, width: 120, height: 100)
                        .cornerRadius(10)

                    VStack(alignment: .leading, spacing: 5) {
                        Text(article.sourceName)
                            .font(.caption)
                            .lineLimit(1)
                        Text(article.title)
                            .font(.headline)
                            .lineLimit(2)
                        
                        if let description = article.description, !description.isEmpty {
                            Text(description)
                                .font(.subheadline)
                                .lineLimit(3)
                        }
                    }
                }

                Text("\(article.publishedAt.timeSince())" + "\(article.author != nil ? " • \(article.author!)" : "")")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            Image(systemName: "arrow.up.forward.app")
        }
    }
}

#Preview {
    ArticleListItemView(article: Article.dummyArticle())
}
