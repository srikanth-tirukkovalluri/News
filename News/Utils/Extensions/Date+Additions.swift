//
//  Date+Additions.swift
//  News
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 26/7/2025.
//

import Foundation

extension Date {
    /**
     Calculates the time difference from this date to another date (defaults to now)
     and returns a human-readable string in the largest relevant unit (days, hours, minutes, or seconds).

     - Parameters:
       - otherDate: The date to compare against. Defaults to the current date and time.
       - style: The style for the unit names (e.g., "full" for "seconds", "short" for "sec").
                Defaults to .full.
     - Returns: A string representing the time difference, e.g., "5 days ago", "2 hours ago", "in 3 minutes", "Just now".
     */
    func timeSince(relativeTo otherDate: Date = Date(), style: DateComponentsFormatter.UnitsStyle = .full) -> String {
        let interval = otherDate.timeIntervalSince(self) // Positive if self is in the past, negative if in the future
        let absoluteInterval = abs(interval)

        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = style
        formatter.maximumUnitCount = 1 // Crucial: Only display the largest relevant unit
        formatter.allowedUnits = [.day, .hour, .minute, .second] // Allow all relevant units
        formatter.zeroFormattingBehavior = .dropAll // Don't show "0 seconds", "0 minutes" etc. if larger units are present

        // Handle very small intervals or exact match
        if absoluteInterval < 1.0 { // Less than 1 second difference
            return "Just now"
        }

        guard let formattedString = formatter.string(from: absoluteInterval) else {
            // Fallback for unexpected cases, though highly unlikely with the above setup
            return "Just now"
        }

        if interval > 0 { // self is in the past
            return "\(formattedString) ago"
        } else { // self is in the future
            return "in \(formattedString)"
        }
    }
}
