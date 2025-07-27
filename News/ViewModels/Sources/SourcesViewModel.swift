//
//  SourcesViewModel.swift
//  News
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 27/7/2025.
//

import Foundation

class SourcesViewModel: ObservableObject {
    @Published var viewState: SourcesViewState = .new
    @Published var sourceItems: [SourceItem]

    private let networkClient = NetworkClient()
    private var sharedData: SharedData

    init(sharedData: SharedData) {
        self.sharedData = sharedData
        self.sourceItems = sharedData.sourceItems

        // Subscribe to changes in the SharedData
        sharedData.$sourceItems.assign(to: &$sourceItems)
    }
    
    private func modifySharedData(sourceItems: [SourceItem]) {
        // Push changes back to SharedData
        sharedData.updateSourceItems(sourceItems)
    }
    
    @MainActor
    func fetchSources() async {
        if case .successful = viewState, !self.sourceItems.isEmpty {
            // data is already there, so ignore fetch
            return
        }
        
        self.viewState = .loading

        do {
            let fetchedSources = try await networkClient.request(endpoint: .getSources, as: Sources.self)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.sourceItems = fetchedSources.sources.map { SourceItem(source: $0, isSelected: false) }
                self.modifySharedData(sourceItems: sourceItems)
                self.viewState = .successful
            }
        } catch {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.viewState = .error(.unknown(error))
            }
        }
    }
    
    func updateSelection(shouldSelectAll: Bool) {
        var newSourceItems: [SourceItem] = []
        for var sourceItem in sourceItems {
            sourceItem.isSelected = shouldSelectAll
            newSourceItems.append(sourceItem)
        }
        
        self.modifySharedData(sourceItems: newSourceItems)
    }
    
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

enum SourcesViewState {
    case new
    case loading
    case successful
    case error(SourcesError)
}

struct SourceItem: Hashable, Identifiable {
    let id = UUID()
    let source: Source
    var isSelected: Bool
    
    static func dummySourceItems() -> [SourceItem] {
        Source.dummySourcess().map { SourceItem(source: $0, isSelected: false) }
    }
}
