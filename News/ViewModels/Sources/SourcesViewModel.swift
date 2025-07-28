//
//  SourcesViewModel.swift
//  News
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 27/7/2025.
//

import Foundation

/// SourcesViewModel is used show sources using which Headlines are shown. This also hosts the ability to fetch and save sources
class SourcesViewModel: ObservableObject {
    // Publish changes
    @Published var viewState: SourcesViewState = .new
    @Published var sourceItems: [SourceItem]

    var sharedData: SharedData
    private let networkClient: NetworkClientProvider

    init(sharedData: SharedData, networkClient: NetworkClientProvider = NetworkClient()) {
        self.sharedData = sharedData
        self.sourceItems = sharedData.sourceItems
        self.networkClient = networkClient

        // Subscribe to changes in the SharedData
        sharedData.$sourceItems.assign(to: &$sourceItems)
    }
    
    private func modifySharedData(sourceItems: [SourceItem]) {
        // Push changes back to SharedData
        sharedData.updateSourceItems(sourceItems)
    }
}

extension SourcesViewModel {
    @MainActor // Always run on main thread
    func fetchSources() async {
        if case .successful = viewState, !self.sourceItems.isEmpty {
            // data is already there, so ignore fetch
            return
        }
        
        self.viewState = .loading

        do {
            let fetchedSources = try await networkClient.request(endpoint: .getSources, as: Sources.self)

            self.sourceItems = fetchedSources.sources.map { SourceItem(source: $0, isSelected: false) }
            self.modifySharedData(sourceItems: sourceItems)
            
            if self.sourceItems.isEmpty {
                self.viewState = .error(.noResultsFound)
            } else {
                self.viewState = .successful
            }
        } catch {
            self.viewState = .error(.unknown(error))
        }
    }
    
    /// This function is used to mark all the sources in one go. The modified changes are propogated back to the SharedData object
    func updateSelection(shouldSelectAll: Bool) {
        var newSourceItems: [SourceItem] = []
        for var sourceItem in sourceItems {
            sourceItem.isSelected = shouldSelectAll
            newSourceItems.append(sourceItem)
        }
        
        self.modifySharedData(sourceItems: newSourceItems)
    }
    
    /// This function is used to mark a single the source. The modified changes are propogated back to the SharedData object
    func updateSelection(shouldSelect: Bool, for selectedSourceItem: SourceItem) {
        var newSourceItems: [SourceItem] = []

        for var sourceItem in sourceItems {
            if sourceItem.id == selectedSourceItem.id {
                sourceItem.isSelected = shouldSelect
            }
            
            newSourceItems.append(sourceItem)
        }
        
        self.modifySharedData(sourceItems: newSourceItems)
    }
}
