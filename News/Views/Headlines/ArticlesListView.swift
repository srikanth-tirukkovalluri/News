//
//  ArticlesListView.swift
//  News
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 27/7/2025.
//

import SwiftUI

struct ArticlesListView: View {
    @Environment(\.editMode) private var editMode
    
    @ObservedObject var viewModel: HeadlinesViewModel
    
    // State to hold the currently selected article. When this becomes non-nil, the sheet will present.
    @State private var selectedArticle: Article?
    @State private var showArticle: Bool = false
    
    let isShowingSavedArticles: Bool
    
    init(viewModel: HeadlinesViewModel, isShowingSavedArticles: Bool) {
        self.viewModel = viewModel
        self.isShowingSavedArticles = isShowingSavedArticles
    }

    var body: some View {
        List {
            ForEach(isShowingSavedArticles ? viewModel.savedArticles : viewModel.headlines) { article in
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
            ArticleWebView(shouldShowSaveOption: viewModel.shouldShowSaveOption(for: article), article: article)
        }
        .toolbar {
            if self.isShowingSavedArticles {
                EditButton() // <--- This adds the Edit/Done button
            }
        }
    }
    
    func deleteItem(at offsets: IndexSet) {
        viewModel.deleteSavedArticles(at: offsets)
    }
}

#Preview {
    ArticlesListView(viewModel: HeadlinesViewModel(sharedData: SharedData.sharedInstance), isShowingSavedArticles: false)
        .environmentObject(SharedData.sharedInstance)
}
