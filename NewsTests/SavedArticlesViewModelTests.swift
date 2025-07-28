//
//  SavedArticlesViewModelTests.swift
//  NewsTests
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 28/7/2025.
//

import XCTest
import Combine
@testable import News

final class SavedArticlesViewModelTests: XCTestCase {
    var viewModel: SavedArticlesViewModel!
    
    override func setUpWithError() throws {
        viewModel = SavedArticlesViewModel(sharedData: SharedData.sharedInstance)
    }
    
    override func tearDownWithError() throws {
        DataManager.deleteData(at: SharedData.savedArticlesKey)
        DataManager.deleteData(at: SharedData.selectedSourceIdentifiersKey)
    }
    
    func testSavedArticles() {
        viewModel.sharedData.savedArticles = Article.dummyArticles()
        XCTAssertTrue(viewModel.sharedData.savedArticles.count == viewModel.articles.count)
    }
    
    func testRemoveFromSavedArticles() {
        viewModel.sharedData.savedArticles = Article.dummyArticles()
        let articlesCountBefore = viewModel.articles.count

        XCTAssertTrue(viewModel.sharedData.savedArticles.count == articlesCountBefore)

        viewModel.deleteSavedArticles(at: IndexSet(integer: 0))
        
        let articlesCountAfter = viewModel.articles.count
        XCTAssertTrue(articlesCountAfter == viewModel.sharedData.savedArticles.count)
        
        XCTAssertTrue(articlesCountBefore - 1 == articlesCountAfter)
    }
}
