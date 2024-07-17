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
    var nickName: String? // Hardcode for now
    
    init(item: ItemModel) {
        self.item = item
        self.nickName = item.seller?.nickname
    }
    
    func loadData() async {
        guard let id = item.id else {
            state = .failed(errorTitle: "Algo salio mal!")
            return
        }
        do {
            item = try await apiManager.performGetRequest(endpoint: .itemDetail(itemId: id))
            state = .loaded
        } catch APIError.noInternetConnection {
            state = .failed(errorTitle: "¡Parece que no hay conexión a internet")
        } catch {
            state = .failed(errorTitle: "Algo salio mal!")
        }
    }
}
