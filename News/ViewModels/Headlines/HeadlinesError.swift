//
//  HeadlinesError.swift
//  News
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 27/7/2025.
//

/// HeadlinesError is used to capture type of error while fetching the headlines
enum HeadlinesError: Equatable {
    case noResultsFound
    case unknown(Error?)
    
    static func == (lhs: HeadlinesError, rhs: HeadlinesError) -> Bool {
        switch (lhs, rhs) {
        case (.noResultsFound, .noResultsFound):
            return true
        case (.unknown, .unknown):
            return true
        default:
            return false
        }
    }
}
