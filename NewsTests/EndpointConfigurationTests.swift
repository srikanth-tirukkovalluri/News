//
//  EndpointConfigurationTests.swift
//  NewsTests
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 28/7/2025.
//

import XCTest
@testable import News

final class EndpointConfigurationTests: XCTestCase {
    func testGetHeadlinesEndpointConfiguration() {
        let config = EndpointConfiguration.getHeadlines(sources: ["test1", "test2"])
        XCTAssertTrue(config.baseURL.absoluteString == "https://newsapi.org/v2")
        XCTAssertTrue(config.path == "/top-headlines")
        
        let absoluteString = URLComponents(string: config.url!.absoluteString)
        XCTAssertTrue(absoluteString!.queryItems!.first(where: { $0.name == "sources" })!.value == "test1,test2")
        XCTAssertTrue(absoluteString!.queryItems!.first(where: { $0.name == "language" })!.value == "en")
    }
    
    func testGetSourcesEndpointConfiguration() {
        let config = EndpointConfiguration.getSources
        XCTAssertTrue(config.baseURL.absoluteString == "https://newsapi.org/v2")
        XCTAssertTrue(config.path == "/top-headlines/sources")
        
        let absoluteString = URLComponents(string: config.url!.absoluteString)
        XCTAssertTrue(absoluteString!.queryItems!.first(where: { $0.name == "language" })!.value == "en")
    }
}
