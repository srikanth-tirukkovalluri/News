//
//  DateFormatter+Additions.swift
//  News
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 27/7/2025.
//

import Foundation

/// The below date formtters are used to decode headlines json response
extension DateFormatter {
    static let isoDateFormatter: DateFormatter = {
        var dateFormatter = DateFormatter()
        // 2025-07-26T06:00:00Z
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter
    }()
    
    static let isoWithMilliSecondsDateFormatter: DateFormatter = {
        var dateFormatter = DateFormatter()
        // 2025-07-26T05:22:15.6667963Z
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter
    }()
    
    static let isoWithColonTimeZoneDateFormatter: DateFormatter = {
        var dateFormatter = DateFormatter()
        // 2025-07-26T05:25:21+00:00
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return dateFormatter
    }()
    
    static let isoWithoutTimeZoneDateFormatter: DateFormatter = {
        var dateFormatter = DateFormatter()
        // 2025-07-26T05:36:47
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter
    }()
}
