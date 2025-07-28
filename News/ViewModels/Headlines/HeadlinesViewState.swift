//
//  HeadlinesViewState.swift
//  News
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 28/7/2025.
//

enum HeadlinesViewState: Equatable {
    case new
    case loading
    case successful
    case error(HeadlinesError)
    
    static func == (lhs: HeadlinesViewState, rhs: HeadlinesViewState) -> Bool {
        switch (lhs, rhs) {
        case (.new, .new):
            return true
        case (.loading, .loading):
            return true
        case (.successful, .successful):
            return true
        case (.error(let actualError1), .error(let actualError2)):
            return true
        default:
            return false
        }
    }
}
