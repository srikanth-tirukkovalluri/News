//
//  MainContentView.swift
//  News
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 26/7/2025.
//

import SwiftUI

/// MainContentView is the main view that the app starts off with that hosts the Tabbar showing Headlines, Sources and Saved Articles.
struct MainContentView: View {
    @StateObject private var headlinesViewModel: HeadlinesViewModel
    @StateObject private var sourcesViewModel: SourcesViewModel
    @StateObject private var savedArticlesViewModel: SavedArticlesViewModel
    @StateObject var sharedData: SharedData

    init(sharedData: SharedData) {
        // Initialize the StateObject using the wrappedValue
        // This ensures the object is created only once for the view's lifetime.
        _sharedData = StateObject(wrappedValue: sharedData)
        _headlinesViewModel = StateObject(wrappedValue: HeadlinesViewModel(sharedData: sharedData))
        _sourcesViewModel = StateObject(wrappedValue: SourcesViewModel(sharedData: sharedData))
        _savedArticlesViewModel = StateObject(wrappedValue: SavedArticlesViewModel(sharedData: sharedData))
    }
    
    var body: some View {
        TabView(selection: $sharedData.selectedTabItem) {
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
            SavedArticlesView(viewModel: savedArticlesViewModel)
                .tabItem {
                    Label(TabViewItem.savedArticles.title, systemImage: TabViewItem.savedArticles.systemImage)
                }
                .tag(TabViewItem.savedArticles)
        }
    }
}

#Preview {
    MainContentView(sharedData: SharedData.sharedInstance)
}
