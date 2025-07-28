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
    
    func testFetchHeadlinesNoSourcesSelectedError() async {
        let noSourcesSelectedErrorExpectation = XCTestExpectation(description: "State changed to Error noSourcesSelected")
        
        await viewModel.fetchTopHeadlines()
        
        cancellable = viewModel.$viewState.sink { newState in
            switch newState {
            case .error(let actualError) where actualError == .noSourcesSelected:
                noSourcesSelectedErrorExpectation.fulfill()
            default:
                break
            }
        }
        
        await fulfillment(of: [noSourcesSelectedErrorExpectation], timeout: 5.0)
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

        let loadingExpectation = XCTestExpectation(description: "State changed to loading")
        let unknownErrorExpectation = XCTestExpectation(description: "State changed to Error unknown")

        await viewModel.fetchTopHeadlines()
        
        cancellable = viewModel.$viewState.sink { newState in
            switch newState {
            case .loading:
                loadingExpectation.fulfill()
            case .error(let actualError) where actualError == .unknown(nil):
                unknownErrorExpectation.fulfill()
            default:
                break
            }
        }
        
        await fulfillment(of: [loadingExpectation, unknownErrorExpectation], timeout: 5.0)
    }
    
    func testFetchHeadlinesSuccessfulResponse() async {
        viewModel.sourceItems = [SourceItem(source: Source.dummySource(), isSelected: true)]
        let loadingExpectation = XCTestExpectation(description: "State changed to loading")
        let successfulExpectation = XCTestExpectation(description: "State changed to successful")
        
        await viewModel.fetchTopHeadlines()
        
        cancellable = viewModel.$viewState.sink { newState in
            switch newState {
            case .loading:
                loadingExpectation.fulfill()
            case .successful:
                successfulExpectation.fulfill()
            default:
                break
            }
        }
        
        await fulfillment(of: [loadingExpectation, successfulExpectation], timeout: 5.0)
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
