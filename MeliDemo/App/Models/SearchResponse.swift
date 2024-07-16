//
//  SearchResponse.swift
//  MeliDemo
//
//  Created by Cristian Sancricca on 15/07/2024.
//

import Foundation

struct SearchResponse: Codable {
    let paging: PagingModel
    let items: [ItemModel]
    
    enum CodingKeys: String, CodingKey {
        case paging
        case items = "results"
    }
}

struct PagingModel: Codable {
    let total: Int
    let primaryResults: Int
    let offset: Int
    let limit: Int
    
    enum CodingKeys: String, CodingKey {
        case total
        case primaryResults = "primary_results"
        case offset
        case limit
    }
}
