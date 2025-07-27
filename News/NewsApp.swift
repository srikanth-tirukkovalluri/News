//
//  NewsApp.swift
//  News
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 26/7/2025.
//

import SwiftUI

@main
struct NewsApp: App {
    @StateObject var appState = AppState()

    var body: some Scene {
        WindowGroup {
            MainContentView(appState: appState)
                .environmentObject(appState)
        }
    }
}
