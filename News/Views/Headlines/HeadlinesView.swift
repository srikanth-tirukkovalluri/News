//
//  HeadlinesView.swift
//  News
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 26/7/2025.
//

import SwiftUI

/// HeadlinesView shows the fetched Articles in a ListView.
struct HeadlinesView: View {
    @ObservedObject var viewModel: HeadlinesViewModel
    @EnvironmentObject var sharedData: SharedData

    var body: some View {
        NavigationStack {
            VStack {
                switch self.viewModel.viewState {
                case .new, .loading:
                    self.loadingView()
                case .successful:
                    self.articlesView()
                case .error(let error) where error == .noResultsFound:
                    self.noResultsView()
                case .error:
                    self.errorView()
                }
            }
            .navigationBarTitle("Top Headlines")
            .task { // New Swift Concurrency way to fetch on appear
                await viewModel.fetchTopHeadlines()
            }
        }
    }
    
    func loadingView() -> some View {
        VStack {
            ProgressView()
                .frame(width: 20, height: 20)
                .foregroundColor(.gray)
            Text("Loading headlines, please wait")
                .foregroundStyle(.gray)
                .padding(.horizontal, 10)
                .multilineTextAlignment(.center)
                .font(.callout)
        }
    }
    
    func articlesView() -> some View {
        ArticlesListView(viewModel: self.viewModel)
            .listStyle(.plain)
    }
    
    func noResultsView() -> some View {
        VStack {
            Text("There are no headlines available for the selected sources")
                .foregroundStyle(.gray)
                .padding(.horizontal, 10)
                .multilineTextAlignment(.center)
                .font(.callout)
            Button {
                self.sharedData.selectedTabItem = .sources
            } label: {
                HStack {
                    Text("Select more sources")
                    Image(systemName: "plus.circle")
                }
            }
        }
    }
    
    func errorView() -> some View {
        VStack {
            Text("Failed to load top headlines")
                .foregroundStyle(.red)
                .padding(.horizontal, 10)
                .multilineTextAlignment(.center)
                .font(.callout)
            Button {
                Task {
                    await viewModel.fetchTopHeadlines()
                }
            } label: {
                HStack {
                    Text("Reload")
                    Image(systemName: "arrow.clockwise")
                }
            }
            .buttonStyle(.bordered)
            .tint(.red)
        }
    }
}

#Preview {
    HeadlinesView(viewModel: HeadlinesViewModel(sharedData: SharedData.sharedInstance))
        .environmentObject(SharedData.sharedInstance)    
}
