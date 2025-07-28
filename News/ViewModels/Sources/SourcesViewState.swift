//
//  SourcesViewState.swift
//  News
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 28/7/2025.
//

/// SourcesViewState is used to capture the current view state based on which the UI updates accordingly
enum SourcesViewState {
    case new
    case loading
    case successful
    case error(SourcesError)
}
