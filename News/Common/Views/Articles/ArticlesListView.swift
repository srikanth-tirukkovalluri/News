//
//  ArticlesListView.swift
//  News
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 27/7/2025.
//

import SwiftUI

struct ArticlesListView: View {
    @Binding var articles: [Article]
    @EnvironmentObject var appState: AppState
    @Environment(\.editMode) private var editMode

    // State to hold the currently selected article. When this becomes non-nil, the sheet will present.
    @State private var selectedArticle: Article?
    @State private var showArticle: Bool = false
    @Binding var shouldShowDeleteOption: Bool

    var body: some View {
        List {
            ForEach(articles) { article in
                ArticleListItemView(article: article)
                    .onTapGesture {
                        // Disable tap when the tableview is in editing mode
                        if editMode?.wrappedValue.isEditing == false {
                            self.selectedArticle = article
                            self.showArticle = true
                        }
                    }
            }
            .onDelete(perform: shouldShowDeleteOption ? deleteItem : nil) // <--- This enables swipe-to-delete
        }
        .listStyle(.plain)
        .sheet(item: $selectedArticle) { article in
            ArticleWebView(shouldShowSaveOption: !appState.savedArticles.contains(article), article: article)
        }
        .toolbar {
            if self.shouldShowDeleteOption {
                EditButton() // <--- This adds the Edit/Done button
            }
        }
    }
    
    func deleteItem(at offsets: IndexSet) {
        articles.remove(atOffsets: offsets)
    }
}

#Preview {
    ArticlesListView(articles: .constant(Article.dummyArticles()), shouldShowDeleteOption: .constant(false))
}
