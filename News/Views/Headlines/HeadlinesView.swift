//
//  HeadlinesView.swift
//  News
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 26/7/2025.
//

import SwiftUI

struct HeadlinesView: View {
    @ObservedObject var viewModel: HeadlinesViewModel
    @EnvironmentObject var sharedData: SharedData

    @State var shouldShowSaveOption: Bool = true
        
    private let networkClient = NetworkClient(jsonDecoder: Article.jsonDecoder)

    var body: some View {
        NavigationStack {
            VStack {
                switch self.viewModel.viewState {
                case .new, .loading:
                    self.loadingView()
                case .successful:
                    self.articlesView()
                case .error(let error) where error == .noSourcesSelected:
                    self.noSourcesSelectedView()
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
        ArticlesListView(viewModel: self.viewModel, isShowingSavedArticles: false)
            .listStyle(.plain)
    }

    func noSourcesSelectedView() -> some View {
        VStack {
            Text("Please select some sources to see headlines")
                .foregroundStyle(.gray)
                .padding(.horizontal, 10)
                .multilineTextAlignment(.center)
                .font(.callout)
            Button {
                self.sharedData.selectedTabItem = .sources
            } label: {
                HStack {
                    Text("Select sources")
                    Image(systemName: "plus.circle")
                }
            }
        }
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
    let sharedData = SharedData()
    HeadlinesView(viewModel: HeadlinesViewModel(sharedData: sharedData))
        .environmentObject(sharedData)    
}
