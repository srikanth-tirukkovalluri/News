//
//  SourceItem.swift
//  News
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 28/7/2025.
//

import Foundation

struct SourceItem: Hashable, Identifiable {
    let id = UUID()
    let source: Source
    var isSelected: Bool
    
    init(source: Source, isSelected: Bool) {
        self.source = source
        
        // Preselect a source if found in saved data
        if SharedData.sharedInstance.selectedSourceIdentifiers.contains(source.identifier) {
            self.isSelected = true
        } else {
            self.isSelected = isSelected
        }
    }
}
