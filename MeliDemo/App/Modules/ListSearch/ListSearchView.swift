//
//  ListSearchView.swift
//  MeliDemo
//
//  Created by Cristian Sancricca on 12/07/2024.
//

import SwiftUI

struct ListSearchView: View {
    @StateObject private var viewModel = ListSearchViewModel()
    
    var body: some View {
        VStack {
            if viewModel.isEditing {
                recentsView
            } else {
                GeometryReader { geo in
                    ScrollView {
                        AsyncContentView(source: viewModel) {
                            itemsView
                        }
                        .frame(minHeight: viewModel.state == .loaded ? 0 : geo.size.height)
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                SearchBarView(text: $viewModel.searchText, isEditing: $viewModel.isEditing, onSearch: {
                    await viewModel.loadData()
                })
            }
        }
        .toolbarBackground(.main, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}


// MARK: Views
extension ListSearchView {
    private var recentsView: some View {
        List {
            ForEach(viewModel.recentSearches, id: \.self) { search in
                Button(action: {
                    Task {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        viewModel.isEditing = false
                        viewModel.searchText = search
                        await viewModel.loadData()
                    }
                }) {
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.gray)
                        Text(search)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal)
                }
                .listRowSeparator(.hidden)
            }
            .onDelete(perform: viewModel.deleteRecentSearch)
        }
        .listStyle(PlainListStyle())
    }
    
    private var itemsView: some View {
        LazyVStack(alignment: .leading) {
            ForEach(viewModel.items) { item in
                ItemRowView(item: item)
                    .onAppear {
                        if item == viewModel.items.last {
                            viewModel.loadMoreItems()
                        }
                    }
            }
        }
    }
}

#Preview {
    ListSearchView()
}
