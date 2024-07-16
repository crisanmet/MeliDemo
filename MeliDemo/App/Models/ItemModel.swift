//
//  ItemModel.swift
//  MeliDemo
//
//  Created by Cristian Sancricca on 15/07/2024.
//

import Foundation

struct ItemModel: Codable, Identifiable {
    let id: String?
    let title: String?
    let condition: String?
    let categoryID: String?
    let thumbnail: String?
    let currencyID: String?
    let price: Double?
    let originalPrice: Double?
    let salePrice: Double?
    let availableQuantity: Int?
    let seller: SellerModel?
    let attributes: [AttributeModel]?
    let discounts: String?
    let promotions: [String]?

    
    enum CodingKeys: String, CodingKey {
        case id, title, condition
        case categoryID = "category_id"
        case thumbnail
        case currencyID = "currency_id"
        case price
        case originalPrice = "original_price"
        case salePrice = "sale_price"
        case availableQuantity = "available_quantity"
        case seller, attributes
        case discounts, promotions
    }
}

extension ItemModel {
    
    static var mock: ItemModel = .init(
        id: "1",
        title: "Test Item",
        condition: "",
        categoryID: "",
        thumbnail: "http://http2.mlstatic.com/D_839295-MLA74246453969_012024-I.jpg",
        currencyID: "",
        price: 2.000,
        originalPrice: 1.000,
        salePrice: 999,
        availableQuantity: 2,
        seller: nil,
        attributes: nil,
        discounts: nil,
        promotions: nil
    )
    
    var thumbnailURL: URL? {
        guard let thumbnail else { return nil }
        return URL(string: thumbnail)
    }
    
    var priceTitle: String? {
        return price?.formattedCurrency()
    }
}

extension ItemModel: Equatable {
    static func == (lhs: ItemModel, rhs: ItemModel) -> Bool {
        return lhs.id == rhs.id
    }
}

struct SellerModel: Codable {
    let id: Int
    let nickname: String?
}

struct AttributeModel: Codable {
    let id: String
    let name: String
    let valueName: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case valueName = "value_name"
    }
}
