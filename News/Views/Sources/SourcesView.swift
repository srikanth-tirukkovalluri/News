//
//  SourcesView.swift
//  News
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 26/7/2025.
//

import SwiftUI

/// SourcesView shows the fetched Sources in a ListView.
struct SourcesView: View {
    @ObservedObject var viewModel: SourcesViewModel
    @EnvironmentObject var sharedData: SharedData

    @State private var shouldSelectAll: Bool = false

    var body: some View {
        NavigationStack {
            // Use '$sources' to get a Binding to the entire array,
            // and '$source' within the block to get a Binding to each individual source.
            VStack {
                switch self.viewModel.viewState {
                case .new, .loading:
                    self.loadingView()
                case .successful:
                    self.sourcesView()
                case .error(let error) where error == .noResultsFound:
                    self.noResultsView()
                case .error:
                    self.errorView()
                }
            }
            .listStyle(.plain)
            .navigationBarTitle("Sources")
            .toolbar {
                self.toolbarItems()
            }
            .task { // New Swift Concurrency way to fetch on appear
                await self.viewModel.fetchSources()
            }
        }
    }
    
    @ToolbarContentBuilder
    func toolbarItems() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button("Done") {
                sharedData.selectedTabItem = .topHeadlines
            }
        }

        ToolbarItem(placement: .topBarTrailing) {
            HStack {
                Image(systemName: shouldSelectAll ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(shouldSelectAll ? .accentColor : .gray)
            }
            .onTapGesture {
                shouldSelectAll.toggle()

                self.viewModel.updateSelection(shouldSelectAll: shouldSelectAll)
            }
        }
    }
    
    func loadingView() -> some View {
        VStack {
            ProgressView()
                .frame(width: 20, height: 20)
                .foregroundColor(.gray)
            Text("Loading sources, please wait")
                .foregroundStyle(.gray)
                .padding(.horizontal, 10)
                .multilineTextAlignment(.center)
                .font(.callout)
        }
    }
    
    func noResultsView() -> some View {
        VStack {
            Text("There are no sources available. Please try after sometime.")
                .foregroundStyle(.gray)
                .padding(.horizontal, 10)
                .multilineTextAlignment(.center)
                .font(.callout)
            Button {
                Task {
                    await self.viewModel.fetchSources()
                }
            } label: {
                HStack {
                    Text("Retry")
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
    }
    
    func errorView() -> some View {
        VStack {
            Text("Failed to load sources")
                .foregroundStyle(.red)
                .padding(.horizontal, 10)
                .multilineTextAlignment(.center)
                .font(.callout)
            Button {
                Task {
                    await self.viewModel.fetchSources()
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
    
    func sourcesView() -> some View {
        List {
            // Use '$sourcesItems' to get a Binding to the entire array,
            // and '$sourceItem' within the block to get a Binding to each individual source.
            ForEach($viewModel.sourceItems) { $sourceItem in
                HStack {
                    // Checkmark: Show/hide based on isSelected
                    Text(sourceItem.source.name)
                        .font(.body)
                    Spacer() // Pushes content to the left, and checkmark to the right
                    Image(systemName: sourceItem.isSelected ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(sourceItem.isSelected ? .accentColor : .gray)
                }
                
                .contentShape(Rectangle()) // Makes the entire HStack tappable
                .animation(.easeInOut(duration: 0.2), value: sourceItem.isSelected)
                .onTapGesture {
                    sourceItem.isSelected.toggle()
                    self.viewModel.updateSelection(shouldSelect: sourceItem.isSelected, for: sourceItem)
                }
            }
        }
    }
}

#Preview {
    SourcesView(viewModel: SourcesViewModel(sharedData: SharedData.sharedInstance))
        .environmentObject(SharedData.sharedInstance)
}
