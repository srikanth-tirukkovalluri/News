//
//  ArticlesView.swift
//  News
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 26/7/2025.
//

import SwiftUI

/// SavedArticlesView shows the saved Articles in a ListView.
struct SavedArticlesView: View {
    @ObservedObject var viewModel: ArticlesViewModel

    var body: some View {
        NavigationStack {
            VStack {
                if self.viewModel.articles.isEmpty {
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
        ArticlesListView(viewModel: viewModel)
    }
}

#Preview {
    SavedArticlesView(viewModel: HeadlinesViewModel(sharedData: SharedData.sharedInstance))
        .environmentObject(SharedData.sharedInstance)
}
