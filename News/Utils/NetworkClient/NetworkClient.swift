//
//  NetworkClient.swift
//  News
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 27/7/2025.
//

import Foundation

protocol NetworkClientProvider {
    func request<T: Decodable>(endpoint: EndpointConfiguration, as type: T.Type) async throws -> T
}

class NetworkClient: NetworkClientProvider {
    private let session: URLSession
    private let jsonDecoder: JSONDecoder

    init(session: URLSession = .shared, jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.jsonDecoder = jsonDecoder
    }

    /// Fetches data from a given API endpoint and decodes it into a Codable type.
    /// - Parameters:
    ///   - endpoint: The API endpoint to request.
    ///   - type: The Codable type to decode the response into.
    /// - Returns: An instance of the specified Codable type.
    /// - Throws: `APIError` if the request fails or decoding fails.
    func request<T: Decodable>(endpoint: EndpointConfiguration, as type: T.Type) async throws -> T {
        guard let urlRequest = endpoint.urlRequest else {
            throw NetworkError.invalidURL
        }
        
        print("NetworkClient: URL: \(urlRequest.url?.absoluteString ?? "N/A")")

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: urlRequest)
        } catch {
            throw NetworkError.genericError
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.genericError
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.genericError
        }

        do {
            return try jsonDecoder.decode(type, from: data)
        } catch {
            print("Decoding Error: \(error)") // For debugging
            throw NetworkError.decodingError(error)
        }
    }
}
