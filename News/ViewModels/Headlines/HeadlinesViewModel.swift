//
//  HeadlinesViewModel.swift
//  News
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 27/7/2025.
//

import Foundation

class HeadlinesViewModel: ObservableObject {
    @Published var headlines: [Article] = []
    @Published var savedArticles: [Article] = []
    @Published var viewState: HeadlinesViewState = .new
    @Published var sourceItems: [SourceItem]

    private var appState: AppState
    private let networkClient = NetworkClient(jsonDecoder: Article.jsonDecoder)
    
    func shouldShowSaveOption(for article: Article) -> Bool {
        !savedArticles.contains(article)
    }
    
    init(appState: AppState) {
        self.appState = appState
        self.sourceItems = appState.sourceItems
        self.savedArticles = appState.savedArticles

        // Subscribe to changes in the AppState
        appState.$sourceItems.assign(to: &$sourceItems)
        appState.$savedArticles.assign(to: &$savedArticles)
    }
    
    private func modifySharedSourceItems(_ sourceItems: [SourceItem]) {
        // Push changes back to AppState
        appState.updateSourceItems(sourceItems)
    }
    
    private func modifySharedSavedArticles(_ savedArticles: [Article]) {
        // Push changes back to AppState
        appState.updateSavedArticles(savedArticles)
    }

    @MainActor // ??
    func fetchTopHeadlines() async {
        self.viewState = .loading
        
        let selectedSources = self.sourceItems.compactMap { $0.isSelected ? $0 : nil }
        guard !selectedSources.isEmpty else {
            self.viewState = .error(.noSourcesSelected)
            return
        }
        
        do {
            let fetchedHeadlines = try await networkClient.request(endpoint: .getHeadlines(sources: selectedSources.compactMap { $0.source.identifier} ), as: Articles.self)
            self.headlines = fetchedHeadlines.articles

            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                guard !self.headlines.isEmpty else {
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

extension HeadlinesViewModel {
    func deleteSavedArticles(at offsets: IndexSet) {
        savedArticles.remove(atOffsets: offsets)
        modifySharedSavedArticles(savedArticles)
    }
}

enum HeadlinesViewState {
    case new
    case loading
    case successful
    case error(HeadlinesError)
}
