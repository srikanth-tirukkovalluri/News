//
//  TabViewItem.swift
//  News
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 26/7/2025.
//

import Foundation

enum TabViewItem: Int {
    case topHeadlines
    case sources
    case savedArticles
    
    var title: String {
        switch self {
        case .topHeadlines: return "Top Headlines"
        case .sources: return "Sources"
        case .savedArticles: return "Saved Articles"
        }
    }
    
    var systemImage: String {
        switch self {
        case .topHeadlines: return "newspaper"
        case .sources: return "rectangle.and.pencil.and.ellipsis"
        case .savedArticles: return "square.and.arrow.down.fill"
        }
    }
}
