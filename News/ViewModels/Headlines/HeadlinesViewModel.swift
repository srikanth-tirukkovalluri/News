//
//  HeadlinesViewModel.swift
//  News
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 27/7/2025.
//

import Foundation

class HeadlinesViewModel: ArticlesViewModel {
    @Published var viewState: HeadlinesViewState = .new
    @Published var sourceItems: [SourceItem]

    private let networkClient: NetworkClientProvider
    
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
    @MainActor // ??
    func fetchTopHeadlines() async {
        self.viewState = .loading
        
        var selectedSourceIdentifiers = self.sourceItems.compactMap { $0.isSelected ? $0.source.identifier : nil }
        
        // If user has just launched the app and since sources are empty,
        // use saved selected source identifiers to fetch top headlines instead of showing blank screen
        if selectedSourceIdentifiers.isEmpty {
            selectedSourceIdentifiers = SharedData.sharedInstance.selectedSourceIdentifiers
        }
        
        guard !selectedSourceIdentifiers.isEmpty else {
            self.viewState = .error(.noSourcesSelected)
            return
        }
        
        do {
            let fetchedHeadlines = try await networkClient.request(endpoint: .getHeadlines(sources: selectedSourceIdentifiers ), as: Articles.self)
            self.articles = fetchedHeadlines.articles

            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                guard !self.articles.isEmpty else {
                    self.viewState = .error(.noResultsFound)
                    return
                }
                
                self.viewState = .successful
            }
        } catch {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.viewState = .error(.unknown(error))
            }
        }
    }
}
