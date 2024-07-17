//
//  ListSearchViewModel.swift
//  MeliDemo
//
//  Created by Cristian Sancricca on 12/07/2024.
//

import SwiftUI
import Factory

final class ListSearchViewModel: Loadable {
    @Injected(\.apiManager) private var apiManager

    @Published var state: LoadingState = .loaded
    @Published var searchText: String = ""
    @Published var recentSearches: [String] = []
    @Published var items: [ItemModel] = []
    @Published var isEditing: Bool = false
    
    // Paging
    private var totalItemsAvailable = 0
    private var currentOffset: Int = 0
    private let limit: Int = 50

    init() {
        loadRecentSearches()
    }
    
    private func loadRecentSearches() {
        guard let savedSearches = UserDefaults.standard.array(forKey: Constants.UserDefault.recentSearches) as? [String] else { return }
        
        recentSearches = savedSearches
    }
    
    private func saveRecentSearches() {
        UserDefaults.standard.set(recentSearches, forKey: Constants.UserDefault.recentSearches)
    }
    
    private func addRecentSearch(_ text: String) {
        if let index = recentSearches.firstIndex(of: text) {
            recentSearches.remove(at: index)
        }
        recentSearches.insert(text, at: 0)
        saveRecentSearches()
    }
    
    func loadData() async {
        guard !searchText.isEmpty else { return }
        addRecentSearch(searchText)
        currentOffset = 0
        items.removeAll()

        state = .loading
        do {
            try await loadItems()
            state = .loaded
        } catch APIError.noInternetConnection {
            state = .failed(errorTitle: "¡Parece que no hay conexión a internet")
        } catch {
            state = .failed(errorTitle: "Algo salio mal!")
        }
    }
    
    func loadMoreItems() {
        guard items.count < totalItemsAvailable else { return }

        Task {
            try? await loadItems()
        }
    }
    
    private func loadItems() async throws {
        
        do {
            let searchResponse: SearchResponse = try await apiManager.performGetRequest(endpoint: .search(query: searchText, offset: currentOffset, limit: limit))
            totalItemsAvailable = searchResponse.paging.total
            items.append(contentsOf: searchResponse.items)
            currentOffset += searchResponse.items.count
        } catch {
            throw error
        }
    }
    
    func deleteRecentSearch(at offsets: IndexSet) {
        recentSearches.remove(atOffsets: offsets)
        saveRecentSearches()
    }
}
