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
    
    func updateSourceItems(_ newSourceItems: [SourceItem]) {
        sourceItems = newSourceItems
    }
    
    func updateSavedArticles(_ newSavedArticles: [Article]) {
        savedArticles = newSavedArticles
    }
}
