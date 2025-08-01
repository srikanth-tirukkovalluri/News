//
//  NewsApp.swift
//  News
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 26/7/2025.
//

import SwiftUI

@main
struct NewsApp: App {
    @StateObject var sharedData = SharedData.sharedInstance
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            MainContentView(sharedData: sharedData)
                .environmentObject(sharedData)
        }
    }
}
