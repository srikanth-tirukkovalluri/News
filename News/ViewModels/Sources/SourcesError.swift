//
//  SourcesError.swift
//  News
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 27/7/2025.
//

/// SourcesError is used to capture type of error while fetching the sources
enum SourcesError: Equatable {
    case noResultsFound
    case unknown(Error?)
    
    static func == (lhs: SourcesError, rhs: SourcesError) -> Bool {
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
