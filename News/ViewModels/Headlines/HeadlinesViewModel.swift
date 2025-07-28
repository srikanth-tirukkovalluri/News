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

    private var sharedData: SharedData
    private let networkClient = NetworkClient(jsonDecoder: Article.jsonDecoder)
    
    func shouldShowSaveOption(for article: Article) -> Bool {
        !savedArticles.contains(article)
    }
    
    init(sharedData: SharedData) {
        self.sharedData = sharedData
        self.sourceItems = sharedData.sourceItems
        self.savedArticles = sharedData.savedArticles

        // Subscribe to changes in the SharedData
        sharedData.$sourceItems.assign(to: &$sourceItems)
        sharedData.$savedArticles.assign(to: &$savedArticles)
    }
    
    private func modifySharedSourceItems(_ sourceItems: [SourceItem]) {
        // Push changes back to SharedData
        sharedData.updateSourceItems(sourceItems)
    }
    
    private func modifySharedSavedArticles(_ savedArticles: [Article]) {
        // Push changes back to SharedData
        sharedData.updateSavedArticles(savedArticles)
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

    func deleteSavedArticles(at offsets: IndexSet) {
        savedArticles.remove(atOffsets: offsets)
        modifySharedSavedArticles(savedArticles)
    }
}
