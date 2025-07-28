//
//  SharedData.swift
//  News
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 28/7/2025.
//

import SwiftUI

class SharedData: ObservableObject {
    static let savedArticlesKey: String = "SavedArticles"
    static let selectedSourceIdentifiersKey: String = "SelectedSourceIdentifiers"

    @Published var sourceItems = [SourceItem]()
    @Published var savedArticles = [Article]()
    @Published var selectedTabItem: TabViewItem = .topHeadlines

    static let sharedInstance = SharedData()
    var selectedSourceIdentifiers = [String]()

    private init() {
        // Read saved articles when the instance is created
        self.readArticles()
        self.readSaveSelectedSourceIdentifiers()
    }
    
    func updateSourceItems(_ newSourceItems: [SourceItem]) {
        sourceItems = newSourceItems
    }
    
    func updateSavedArticles(_ newSavedArticles: [Article]) {
        savedArticles = newSavedArticles
    }
}

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
