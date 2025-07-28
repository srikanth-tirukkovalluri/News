//
//  SharedData.swift
//  News
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 28/7/2025.
//

import SwiftUI

class SharedData: ObservableObject {
    @Published var topHeadlines = [Article]()
    @Published var sourceItems = [SourceItem]()
    @Published var savedArticles = [Article]()
    @Published var selectedTabItem: TabViewItem = .topHeadlines

    static let sharedInstance = SharedData()
    private let defaults = UserDefaults.standard
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
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(savedArticles)
            defaults.set(encodedData, forKey: "SavedArticles")
        } catch {
            print("Error encoding SavedArticles: \(error)")
        }
    }
    
    private func readArticles() {
        guard let savedData = UserDefaults.standard.data(forKey: "SavedArticles") else {
            return
        }
        do {
            let decodedObjects = try JSONDecoder().decode([Article].self, from: savedData)
            self.savedArticles = decodedObjects
        } catch {
            print("Error decoding SavedArticles: \(error)")
        }
    }
    
    func saveSelectedSourceIdentifiers() {
        do {
            let selectedSourceIdentifiers = self.sourceItems.compactMap { $0.isSelected ? $0.source.identifier : nil }
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(selectedSourceIdentifiers)
            defaults.set(encodedData, forKey: "SelectedSourceIdentifiers")
        } catch {
            print("Error encoding SelectedSourceIdentifiers: \(error)")
        }
    }
    
    private func readSaveSelectedSourceIdentifiers() {
        guard let savedData = UserDefaults.standard.data(forKey: "SelectedSourceIdentifiers") else {
            return
        }
        do {
            let decodedObjects = try JSONDecoder().decode([String].self, from: savedData)
            self.selectedSourceIdentifiers = decodedObjects
        } catch {
            print("Error decoding SavedArticles: \(error)")
        }
    }
}
