//
//  DateFormatterTests.swift
//  NewsTests
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 28/7/2025.
//

import XCTest
@testable import News

final class DateFormatterTests: XCTestCase {
    func testDateSince() {
        // 1hr
        var date1 = DateFormatter.dateFormatter1.date(from: "2025-07-28T18:30:00Z")!
        var date2 = DateFormatter.dateFormatter1.date(from: "2025-07-28T17:30:00Z")!
        XCTAssertTrue(date1.timeSince(relativeTo: date2) == "in 1 hour")
        
        // 2hrs
        date1 = DateFormatter.dateFormatter1.date(from: "2025-07-28T18:30:00Z")!
        date2 = DateFormatter.dateFormatter1.date(from: "2025-07-28T16:30:00Z")!
        XCTAssertTrue(date1.timeSince(relativeTo: date2) == "in 2 hours")
        
        // 3hrs 30mins
        date1 = DateFormatter.dateFormatter1.date(from: "2025-07-28T18:30:00Z")!
        date2 = DateFormatter.dateFormatter1.date(from: "2025-07-28T15:00:00Z")!
        XCTAssertTrue(date1.timeSince(relativeTo: date2) == "in 4 hours")
        
        // 30mins
        date1 = DateFormatter.dateFormatter1.date(from: "2025-07-28T18:30:00Z")!
        date2 = DateFormatter.dateFormatter1.date(from: "2025-07-28T18:00:00Z")!
        XCTAssertTrue(date1.timeSince(relativeTo: date2) == "in 30 minutes")
        
        // 1 day ago
        date1 = DateFormatter.dateFormatter1.date(from: "2025-07-27T18:30:00Z")!
        date2 = DateFormatter.dateFormatter1.date(from: "2025-07-28T18:30:00Z")!
        XCTAssertTrue(date1.timeSince(relativeTo: date2) == "1 day ago")
        
        // 20secs
        date1 = DateFormatter.dateFormatter1.date(from: "2025-07-27T18:30:00Z")!
        date2 = DateFormatter.dateFormatter1.date(from: "2025-07-27T18:30:20Z")!
        XCTAssertTrue(date1.timeSince(relativeTo: date2) == "20 seconds ago")
        
        // Just now
        date1 = DateFormatter.dateFormatter1.date(from: "2025-07-27T18:30:00Z")!
        date2 = DateFormatter.dateFormatter1.date(from: "2025-07-27T18:30:00Z")!
        XCTAssertTrue(date1.timeSince(relativeTo: date2) == "Just now")
    }
    
    func testDateFormatters() {
        XCTAssertNotNil(DateFormatter.dateFormatter1.date(from: "2025-07-28T18:30:00Z"))
        XCTAssertNotNil(DateFormatter.dateFormatter2.date(from: "2025-07-28T18:30:00.6667963Z"))
        XCTAssertNotNil(DateFormatter.dateFormatter3.date(from: "2025-07-26T05:25:21+00:00"))
        XCTAssertNotNil(DateFormatter.dateFormatter4.date(from: "2025-07-26T05:25:21"))
    }
}
