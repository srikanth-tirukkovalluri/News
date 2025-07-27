//
//  ArticlesView.swift
//  News
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 26/7/2025.
//

import SwiftUI

struct SavedArticlesView: View {
    @Binding var articles: [Article]
    
    var body: some View {
        NavigationStack {
            VStack {
                if articles.isEmpty {
                    self.noSavedArticlesView()
                } else {
                    self.articlesView()
                }
            }
            .listStyle(.plain)
            .navigationBarTitle("Saved")
        }
    }
    
    func noSavedArticlesView() -> some View {
        Text("Saved articles appear here.\nTap on \(Image(systemName: "square.and.arrow.down")) icon while reading an article to save.")
            .foregroundStyle(.gray)
            .padding(.horizontal, 50)
            .multilineTextAlignment(.center)
            .font(.callout)
    }
    
    func articlesView() -> some View {
        ArticlesListView(articles: $articles, shouldShowDeleteOption: .constant(!articles.isEmpty))
    }
}

#Preview {
    SavedArticlesView(articles: .constant([Article.dummyArticle()]))
}
