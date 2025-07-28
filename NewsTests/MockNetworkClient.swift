//
//  MockNetworkClient.swift
//  News
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 28/7/2025.
//

import Foundation
@testable import News

class MockNetworkClient: NetworkClientProvider {
    private let filename: String
    private let jsonDecoder: JSONDecoder

    init(filename: String, jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.filename = filename
        self.jsonDecoder = jsonDecoder
    }

    /// Fetches data from a given stubFile for the given endpoint and decodes it into a Codable type.
    /// - Parameters:
    ///   - endpoint: The API endpoint to request.
    ///   - type: The Codable type to decode the response into.
    /// - Returns: An instance of the specified Codable type.
    /// - Throws: `APIError` if the request fails or decoding fails.
    func request<T: Decodable>(endpoint: EndpointConfiguration, as type: T.Type) async throws -> T {
        guard let urlRequest = endpoint.urlRequest else {
            throw NetworkError.invalidURL
        }
        
        try await Task.sleep(nanoseconds: 1_000_000_000) // Simulate 1 second delay

        print("MockNetworkClient: URL: \(urlRequest.url?.absoluteString ?? "N/A")")

        do {
            return try JsonLoader.loadJSON(filename: filename, type: type, jsonDecoder: jsonDecoder)
        } catch {
            print("Decoding Error: \(error)") // For debugging
            throw NetworkError.decodingError(error)
        }
    }
}
