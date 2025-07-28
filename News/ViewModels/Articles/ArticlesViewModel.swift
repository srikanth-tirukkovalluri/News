//
//  ArticlesViewModel.swift
//  News
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 28/7/2025.
//

import Foundation

/// ArticlesViewModel is a base ViewModel used to hold Articles
class ArticlesViewModel: ObservableObject {
    @Published var articles = [Article]()

    var sharedData: SharedData
    
    init(sharedData: SharedData) {
        self.sharedData = sharedData
    }
}
