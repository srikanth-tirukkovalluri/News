//
//  HeadlinesViewModel.swift
//  News
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 27/7/2025.
//

import Foundation

/// HeadlinesViewModel is used show headlines for the selected Sources. This also hosts the ability to fetch and save headlines
class HeadlinesViewModel: ArticlesViewModel {
    // Publish changes
    @Published var viewState: HeadlinesViewState = .new
    @Published var sourceItems: [SourceItem]

    private let networkClient: NetworkClientProvider
    
    /// This function determines whether to show Save option while reading an Article. If the article is already saved the it returns false
    func shouldShowSaveOption(for article: Article) -> Bool {
        !self.sharedData.savedArticles.map({ $0.urlPath }).contains(article.urlPath)
    }
    
    init(sharedData: SharedData, networkClient: NetworkClientProvider = NetworkClient(jsonDecoder: Article.jsonDecoder)) {
        self.sourceItems = sharedData.sourceItems
        self.networkClient = networkClient
        super.init(sharedData: sharedData)

        // Subscribe to changes in the SharedData
        sharedData.$sourceItems.assign(to: &$sourceItems)
    }
}

extension HeadlinesViewModel {
    @MainActor // Always run on main thread
    func fetchTopHeadlines() async {
        self.viewState = .loading
        
        var selectedSourceIdentifiers = self.sourceItems.compactMap { $0.isSelected ? $0.source.identifier : nil }
        
        // If user has just launched the app and since sources are empty,
        // use saved selected source identifiers to fetch top headlines instead of showing blank screen
        if selectedSourceIdentifiers.isEmpty {
            selectedSourceIdentifiers = SharedData.sharedInstance.selectedSourceIdentifiers
        }
        
        // If the sources are not selected then prompt to select sources
        guard !selectedSourceIdentifiers.isEmpty else {
            self.viewState = .error(.noSourcesSelected)
            return
        }
        
        do {
            let fetchedHeadlines = try await networkClient.request(endpoint: .getHeadlines(sources: selectedSourceIdentifiers ), as: Articles.self)
            self.articles = fetchedHeadlines.articles

            // If the articles are not found for the selected sources then show no results and prompt to select more sources
            guard !self.articles.isEmpty else {
                self.viewState = .error(.noResultsFound)
                return
            }
            
            self.viewState = .successful
        } catch {
            self.viewState = .error(.unknown(error))
        }
    }
}
