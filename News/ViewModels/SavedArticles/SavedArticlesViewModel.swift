//
//  SavedArticlesViewModel.swift
//  News
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 28/7/2025.
//

import Foundation

/// SavedArticlesViewModel is used show saved articles. This also hosts the ability to delete the saved articles
class SavedArticlesViewModel: ArticlesViewModel {
    override init(sharedData: SharedData) {
        super.init(sharedData: sharedData)
        self.articles = sharedData.savedArticles

        // Subscribe to changes in the SharedData
        sharedData.$savedArticles.assign(to: &$articles)
    }
    
    private func modifySharedSavedArticles(_ savedArticles: [Article]) {
        // Push changes back to SharedData
        sharedData.updateSavedArticles(savedArticles)
    }
}

extension SavedArticlesViewModel {
    func deleteSavedArticles(at offsets: IndexSet) {
        articles.remove(atOffsets: offsets)
        modifySharedSavedArticles(articles)
    }
}

