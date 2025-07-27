//
//  ArticleWebView.swift
//  News
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 26/7/2025.
//

import SwiftUI

struct ArticleWebView: View {
    var shouldShowSaveOption: Bool
    var article: Article
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState

    // Bindings that will be passed to our WebView via its Coordinator
    @State private var showSavedAlert: Bool = false
    @StateObject var webViewState = WebViewState()

    var body: some View {
        NavigationStack {
            VStack {
                if webViewState.isLoading {
                    self.loadingView()
                }
                
                if webViewState.hasError {
                    self.errorView()
                } else {
                    self.webView()
                }
            }
            .navigationBarTitle(self.article.title) // Title for the navigation bar
            .navigationBarTitleDisplayMode(.inline) // Keep title small at the top
            .toolbar {
                self.toolbarItems()
            }
        }
    }
    
    func webView() -> some View {
        WebView(webViewState : webViewState, url: article.url)
            .edgesIgnoringSafeArea(.bottom) // Extend the web view content to the very bottom
    }
    
    func loadingView() -> some View {
        ProgressView(value: webViewState.estimatedProgress)
            .progressViewStyle(.linear) // A thin line progress bar
            .tint(.accentColor) // Color of the progress bar
    }
    
    func errorView() -> some View {
        Text("Sorry, could not load the article because the URL is invalid or the server is unreachable.")
            .foregroundStyle(.gray)
            .padding(.horizontal, 50)
            .multilineTextAlignment(.center)
            .font(.callout)
    }
    
    @ToolbarContentBuilder
    func toolbarItems() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button("Close Article", systemImage: "xmark") {
                self.dismiss()
            }
        }

        if self.shouldShowSaveOption {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save Article", systemImage: "square.and.arrow.down") {
                    appState.savedArticles.append(self.article)
                    self.showSavedAlert = true
                }
                .alert(isPresented: $showSavedAlert) {
                    Alert(title: Text("Saved!!"), message: Text("This article is now saved to your saved articles list."), dismissButton: .default(Text("OK")))
                }
            }
        }
    }
}

#Preview {
    ArticleWebView(shouldShowSaveOption: false, article: Article.dummyArticle())
        .environmentObject(AppState())
}
