//
//  JsonLoader.swift
//  News
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 27/7/2025.
//

import Foundation

/// A convenience object used to decode a codable object from JSON
struct JsonLoader {
    static func loadJSON<T: Decodable>(filename: String, type: T.Type, jsonDecoder: JSONDecoder = JSONDecoder()) throws -> T {
        // 1. Find the URL for the resource in the main bundle
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            throw JsonLoaderError.fileNotFound
        }

        // 2. Load the data from the URL
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw JsonLoaderError.dataCorrupted(error)
        }

        do {
            let decodedObject = try jsonDecoder.decode(type, from: data)
            return decodedObject
        } catch {
            throw JsonLoaderError.decodingFailed(error)
        }
    }
}

enum JsonLoaderError: Error {
    case fileNotFound
    case dataCorrupted(Error)
    case decodingFailed(Error)
}
