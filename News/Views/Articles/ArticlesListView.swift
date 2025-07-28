//
//  ArticlesListView.swift
//  News
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 27/7/2025.
//

import SwiftUI

struct ArticlesListView: View {
    @Environment(\.editMode) private var editMode
    
    @ObservedObject var viewModel: ArticlesViewModel
    
    // State to hold the currently selected article. When this becomes non-nil, the sheet will present.
    @State private var selectedArticle: Article?
    @State private var showArticle: Bool = false
    
    let isShowingSavedArticles: Bool
    
    init(viewModel: ArticlesViewModel) {
        self.viewModel = viewModel
        self.isShowingSavedArticles = viewModel is SavedArticlesViewModel
    }

    var body: some View {
        List {
            ForEach(viewModel.articles) { article in
                ArticleListItemView(article: article)
                    .onTapGesture {
                        // Disable tap when the tableview is in editing mode
                        if editMode?.wrappedValue.isEditing == false {
                            self.selectedArticle = article
                            self.showArticle = true
                        }
                    }
            }
            .onDelete(perform: isShowingSavedArticles ? deleteItem : nil) // <--- This enables swipe-to-delete
        }
        .listStyle(.plain)
        .sheet(item: $selectedArticle) { article in
            let shouldShowSaveOption = (viewModel as? HeadlinesViewModel)?.shouldShowSaveOption(for: article) ?? false
            ArticleWebView(shouldShowSaveOption: shouldShowSaveOption, article: article)
        }
        .toolbar {
            if self.isShowingSavedArticles {
                EditButton() // <--- This adds the Edit/Done button
            }
        }
    }
    
    func deleteItem(at offsets: IndexSet) {
        (viewModel as? SavedArticlesViewModel)?.deleteSavedArticles(at: offsets)
    }
}

#Preview {
    ArticlesListView(viewModel: ArticlesViewModel(sharedData: SharedData.sharedInstance))
        .environmentObject(SharedData.sharedInstance)
}
