//
//  ItemDetailViewModel.swift
//  MeliDemo
//
//  Created by Cristian Sancricca on 16/07/2024.
//

import Foundation
import Factory

final class ItemDetailViewModel: Loadable {
    
    @Injected(\.apiManager) private var apiManager
    @Published var state: LoadingState = .loading
    @Published var item: ItemModel
    @Published var itemDescription: ItemModelDescription?
    @Published var sellerRelatedItems: [ItemModel]?
    
    var seller: SellerModel? // Hardcode for now
    
    init(item: ItemModel) {
        self.item = item
        self.seller = item.seller
    }
    
    @MainActor
    func loadData() async {
        guard let id = item.id else {
            state = .failed(errorTitle: "Algo salio mal!")
            return
        }
        do {
            item = try await apiManager.performGetRequest(endpoint: .itemDetail(itemId: id))
            await getItemDescription(for: id)
            await getSellerRelatedItems()
            state = .loaded
        } catch APIError.noInternetConnection {
            state = .failed(errorTitle: "¡Parece que no hay conexión a internet")
        } catch {
            state = .failed(errorTitle: "Algo salio mal!")
        }
    }
    
    @MainActor
    private func getItemDescription(for id: String) async {
        // No need to throw error if itemDescription fails.
        itemDescription = try? await apiManager.performGetRequest(endpoint: .itemDescription(itemId: id))
    }
    
    @MainActor
    private func getSellerRelatedItems() async {
        // No need to throw error if related items fails.
        guard let sellerId = seller?.id else { return }
        
        let searchResponse: SearchResponse? = try? await apiManager.performGetRequest(endpoint: .sellerSearch(sellerId: sellerId))
        sellerRelatedItems = searchResponse?.items
    }
}
