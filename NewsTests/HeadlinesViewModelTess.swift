//
//  HeadlinesViewModelTess.swift
//  NewsTests
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 28/7/2025.
//

import XCTest
import Combine
@testable import News

final class HeadlinesViewModelTess: XCTestCase {
    
    var viewModel: HeadlinesViewModel!
    var cancellable: Cancellable?
    
    override func setUpWithError() throws {
        viewModel = HeadlinesViewModel(sharedData: SharedData.sharedInstance, networkClient: MockNetworkClient(filename: "top-headlines", jsonDecoder: Article.jsonDecoder))
    }
    
    override func tearDownWithError() throws {
        cancellable?.cancel()
        self.cancellable = nil
        DataManager.deleteData(at: SharedData.savedArticlesKey)
        DataManager.deleteData(at: SharedData.selectedSourceIdentifiersKey)
    }
    
    func testFetchHeadlinesNoResultsError() async {
        viewModel = HeadlinesViewModel(sharedData: SharedData.sharedInstance, networkClient: MockNetworkClient(filename: "top-headlines-empty", jsonDecoder: Article.jsonDecoder))
        viewModel.sourceItems = [SourceItem(source: Source.dummySource(), isSelected: true)]

        let noResultsFoundErrorExpectation = XCTestExpectation(description: "State changed to Error noResultsFound")

        await viewModel.fetchTopHeadlines()
        
        cancellable = viewModel.$viewState.sink { newState in
            switch newState {
            case .error(let actualError) where actualError == .noResultsFound:
                noResultsFoundErrorExpectation.fulfill()
            default:
                break
            }
        }
        
        await fulfillment(of: [noResultsFoundErrorExpectation], timeout: 5.0)
    }
    
    func testFetchHeadlinesUnknownError() async {
        viewModel = HeadlinesViewModel(sharedData: SharedData.sharedInstance, networkClient: MockNetworkClient(filename: "top-headlines-unknown-error", jsonDecoder: Article.jsonDecoder))
        viewModel.sourceItems = [SourceItem(source: Source.dummySource(), isSelected: true)]

        let unknownErrorExpectation = XCTestExpectation(description: "State changed to Error unknown")

        await viewModel.fetchTopHeadlines()
        
        cancellable = viewModel.$viewState.sink { newState in
            switch newState {
            case .error(let actualError) where actualError == .unknown(nil):
                unknownErrorExpectation.fulfill()
            default:
                break
            }
        }
        
        await fulfillment(of: [unknownErrorExpectation], timeout: 5.0)
    }
    
    func testFetchHeadlinesIncorrectDateError() async {
        // Incorrect: "25-07-2025T05:25:00Z"
        // Considered date formates as per json so far are
        // 2025-07-26T06:00:00Z, 2025-07-26T05:22:15.6667963Z, 2025-07-26T05:25:21+00:00, 2025-07-26T05:36:47
        viewModel = HeadlinesViewModel(sharedData: SharedData.sharedInstance, networkClient: MockNetworkClient(filename: "top-headlines-incorrect-date", jsonDecoder: Article.jsonDecoder))
        viewModel.sourceItems = [SourceItem(source: Source.dummySource(), isSelected: true)]

        let unknownErrorExpectation = XCTestExpectation(description: "State changed to Error unknown")

        await viewModel.fetchTopHeadlines()
        
        cancellable = viewModel.$viewState.sink { newState in
            switch newState {
            case .error(let actualError) where actualError == .unknown(nil):
                unknownErrorExpectation.fulfill()
            default:
                break
            }
        }
        
        await fulfillment(of: [unknownErrorExpectation], timeout: 5.0)
    }
    
    func testFetchHeadlinesSuccessfulResponse() async {
        viewModel.sourceItems = [SourceItem(source: Source.dummySource(), isSelected: true)]
        let successfulExpectation = XCTestExpectation(description: "State changed to successful")
        
        await viewModel.fetchTopHeadlines()
        
        cancellable = viewModel.$viewState.sink { newState in
            switch newState {
            case .successful:
                successfulExpectation.fulfill()
            default:
                break
            }
        }
        
        await fulfillment(of: [successfulExpectation], timeout: 5.0)
    }
    
    func testHeadlinesShouldShowSaveOptionTrue() {
        viewModel.sharedData.savedArticles = []
        let article = Article.dummyArticle()
        let shouldShowSaveOption = viewModel.shouldShowSaveOption(for: article)
        XCTAssertTrue(shouldShowSaveOption)
    }
    
    func testHeadlinesShouldShowSaveOptionFalse() {
        let article = Article.dummyArticle()
        viewModel.sharedData.savedArticles = [article]
        let shouldShowSaveOption = viewModel.shouldShowSaveOption(for: article)
        XCTAssertFalse(shouldShowSaveOption)
    }
}
