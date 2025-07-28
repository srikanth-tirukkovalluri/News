//
//  ArticlesViewModel.swift
//  News
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 28/7/2025.
//

import Foundation

class ArticlesViewModel: ObservableObject {
    @Published var articles = [Article]()

    var sharedData: SharedData
    
    init(sharedData: SharedData) {
        self.sharedData = sharedData
    }
}
