//
//  UIApplicationDelegateAdaptor.swift
//  News
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 28/7/2025.
//

import SwiftUI
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func applicationWillTerminate(_ application: UIApplication) {
        // Save simple data
        print(">>> Saving data...")
        SharedData.sharedInstance.saveArticles()
        SharedData.sharedInstance.saveSelectedSourceIdentifiers()
    }
}
