//
//  DataManager.swift
//  News
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 28/7/2025.
//

import Foundation

/// DataManager is a convenience object used to save, load and delete data from a file
struct DataManager {
    static private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    // Write data
    static func saveData<T: Codable>(_ data: T, to fileName: String) {
        let jsonEncoder = JSONEncoder()
        if let dataToSave = try? jsonEncoder.encode(data) {
            let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
            
            do {
                try dataToSave.write(to: fileURL)
            } catch {
                print("Error encoding fileName: \(fileName) \(error)")
            }
        }
    }
    
    // Read data
    static func loadData<T: Codable>(from fileName: String, as type: T.Type) -> T? {
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        let jsonDecoder = JSONDecoder()
        
        do {
            return try jsonDecoder.decode(T.self, from: data)
        } catch {
            print("Error decoding fileName: \(fileName) \(error)")
            return nil
        }
    }
    
    // Delete data
    static func deleteData(at fileName: String) {
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            print("Error deleting fileName: \(fileName) \(error)")
        }
    }
}
