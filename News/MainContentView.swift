//
//  MainContentView.swift
//  News
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 26/7/2025.
//

import SwiftUI

struct MainContentView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var headlinesViewModel: HeadlinesViewModel
    @StateObject private var sourcesViewModel: SourcesViewModel
    
    init(appState: AppState) {
        // Initialize the StateObject using the wrappedValue
        // This ensures the object is created only once for the view's lifetime.
        _headlinesViewModel = StateObject(wrappedValue: HeadlinesViewModel(appState: appState))
        _sourcesViewModel = StateObject(wrappedValue: SourcesViewModel(appState: appState))
    }
    
    var body: some View {
        TabView(selection: $appState.selectedTabItem) {
            HeadlinesView(viewModel: headlinesViewModel)
                .tabItem {
                    Label(TabViewItem.topHeadlines.title, systemImage: TabViewItem.topHeadlines.systemImage)
                }
                .tag(TabViewItem.topHeadlines)
            SourcesView(viewModel: sourcesViewModel)
                .tabItem {
                    Label(TabViewItem.sources.title, systemImage: TabViewItem.sources.systemImage)
                }
                .tag(TabViewItem.sources)
            SavedArticlesView(articles: $appState.savedArticles)
                .tabItem {
                    Label(TabViewItem.savedArticles.title, systemImage: TabViewItem.savedArticles.systemImage)
                }
                .tag(TabViewItem.savedArticles)
        }
    }
}

#Preview {
    let appState = AppState()

    MainContentView(appState: appState)
        .environmentObject(appState)
}
