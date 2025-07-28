//
//  SharedData.swift
//  News
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 28/7/2025.
//

import SwiftUI

/// SharedData is a container object which holds shared data which is used to display headlines based on the selected sources and persist saved articles and selected sources
class SharedData: ObservableObject {
    static let sharedInstance = SharedData()
    static let savedArticlesKey: String = "SavedArticles"
    static let selectedSourceIdentifiersKey: String = "SelectedSourceIdentifiers"

    // Publish changes
    @Published var sourceItems = [SourceItem]()
    @Published var savedArticles = [Article]()
    @Published var selectedTabItem: TabViewItem = .topHeadlines

    var selectedSourceIdentifiers = [String]()

    private init() {
        // Read saved articles when the shared instance is created(basically at launch time)
        self.readArticles()
        self.readSaveSelectedSourceIdentifiers()
    }
    
    // updateSourceItems is used to push back the changes into SharedData when the sources API call finishes
    func updateSourceItems(_ newSourceItems: [SourceItem]) {
        sourceItems = newSourceItems
    }
    
    // updateSavedArticles is used to push back the changes into SharedData when the articles are deleted from the saved list
    func updateSavedArticles(_ newSavedArticles: [Article]) {
        savedArticles = newSavedArticles
    }
}

// These are convenience methods to save and read data from persistent storage(filesystem)
extension SharedData {
    func saveArticles() {
        DataManager.saveData(savedArticles, to: Self.savedArticlesKey)
    }
    
    private func readArticles() {
        self.savedArticles = DataManager.loadData(from: Self.savedArticlesKey, as: [Article].self) ?? [Article]()
    }
    
    func saveSelectedSourceIdentifiers() {
        let selectedSourceIdentifiers = self.sourceItems.compactMap { $0.isSelected ? $0.source.identifier : nil }
        DataManager.saveData(selectedSourceIdentifiers, to: Self.selectedSourceIdentifiersKey)
    }
    
    private func readSaveSelectedSourceIdentifiers() {
        self.selectedSourceIdentifiers = DataManager.loadData(from: Self.selectedSourceIdentifiersKey, as: [String].self) ?? [String]()
    }
}
