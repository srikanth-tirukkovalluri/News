//
//  SourcesViewModelTests.swift
//  NewsTests
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 28/7/2025.
//

import XCTest
import Combine
@testable import News

final class SourcesViewModelTests: XCTestCase {
    var viewModel: SourcesViewModel!
    var cancellable: Cancellable?
    
    override func setUpWithError() throws {
        viewModel = SourcesViewModel(sharedData: SharedData.sharedInstance, networkClient: MockNetworkClient(filename: "sources"))
    }
    
    override func tearDownWithError() throws {
        cancellable?.cancel()
        self.cancellable = nil
        DataManager.deleteData(at: SharedData.savedArticlesKey)
        DataManager.deleteData(at: SharedData.selectedSourceIdentifiersKey)
    }

    func testFetchSourcesNoSourcesSelectedError() async {
        viewModel = SourcesViewModel(sharedData: SharedData.sharedInstance, networkClient: MockNetworkClient(filename: "sources-empty"))

        let noResultsFoundErrorExpectation = XCTestExpectation(description: "State changed to Error noResultsFound")
        
        await viewModel.fetchSources()
        
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
    
    func testFetchSourcesUnknownError() async {
        viewModel = SourcesViewModel(sharedData: SharedData.sharedInstance, networkClient: MockNetworkClient(filename: "sources-unknown"))
        viewModel.sourceItems = [SourceItem(source: Source.dummySource(), isSelected: true)]

        let unknownErrorExpectation = XCTestExpectation(description: "State changed to Error unknown")

        await viewModel.fetchSources()
        
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
    
    func testFetchSourcesSuccessful() async {
        let successfulExpectation = XCTestExpectation(description: "State changed to successful")
        
        await viewModel.fetchSources()
        
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
    
    func testUpdateSelection() async {
        viewModel.sourceItems = SourceItem.dummySourceItems()
        
        // Test Select All
        for sourceItem in viewModel.sourceItems {
            XCTAssertFalse(sourceItem.isSelected)
        }
        
        viewModel.updateSelection(shouldSelectAll: true)
        
        for sourceItem in viewModel.sourceItems {
            XCTAssertTrue(sourceItem.isSelected)
        }
        
        for sourceItem in viewModel.sharedData.sourceItems {
            XCTAssertTrue(sourceItem.isSelected)
        }
        
        // Test Select None
        viewModel.updateSelection(shouldSelectAll: false)
        
        for sourceItem in viewModel.sourceItems {
            XCTAssertFalse(sourceItem.isSelected)
        }
        
        for sourceItem in viewModel.sharedData.sourceItems {
            XCTAssertFalse(sourceItem.isSelected)
        }
    }
    
    func testUpdateSelectionOneSource() async {
        let sourceItem = SourceItem(source: Source.dummySource(), isSelected: false)
        viewModel.sourceItems = [sourceItem]
        
        // Test Select True
        viewModel.updateSelection(shouldSelect: true, for: sourceItem)
        XCTAssertTrue(viewModel.sourceItems.first?.isSelected == .some(true))
        XCTAssertTrue(viewModel.sharedData.sourceItems.first?.isSelected == .some(true))
        
        // Test Select False
        viewModel.updateSelection(shouldSelect: false, for: sourceItem)
        XCTAssertTrue(viewModel.sourceItems.first?.isSelected == .some(false))
        XCTAssertTrue(viewModel.sharedData.sourceItems.first?.isSelected == .some(false))
    }
}
