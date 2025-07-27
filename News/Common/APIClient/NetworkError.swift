//
//  NetworkError.swift
//  News
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 27/7/2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case decodingError(Error)
    case genericError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL provided was invalid."
        case .decodingError(let error):
            return "Failed to decode the response: \(error.localizedDescription)"
        case .genericError:
            return "Generic error"
        }
    }
}
