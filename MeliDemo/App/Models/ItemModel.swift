//
//  ItemModel.swift
//  MeliDemo
//
//  Created by Cristian Sancricca on 15/07/2024.
//

import Foundation

enum ItemCondition: String, Codable {
    case new = "new"
    case used = "used"
    case refurbished = "refurbished"
    case unknown
    
    var title: String {
        switch self {
        case .new:
            "Nuevo"
        case .used:
            "Usado"
        case .refurbished:
            "Reacondicionado"
        case .unknown:
            "N/N"
        }
    }
}

struct ItemModel: Codable, Identifiable {
    let id: String?
    let title: String?
    let condition: ItemCondition?
    let categoryID: String?
    let thumbnailID: String?
    let currencyID: String?
    let price: Double?
    let originalPrice: Double?
    let salePrice: Double?
    let availableQuantity: Int?
    let pictures: [PictureModel]?
    let seller: SellerModel?
    let attributes: [AttributeModel]?
    let discounts: String?
    let promotions: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id, title, condition, discounts, promotions, pictures, price, seller, attributes
        case categoryID = "category_id"
        case thumbnailID = "thumbnail_id"
        case currencyID = "currency_id"
        case originalPrice = "original_price"
        case salePrice = "sale_price"
        case availableQuantity = "available_quantity"
    }
}

// MARK: Equatable
extension ItemModel: Equatable {
    static func == (lhs: ItemModel, rhs: ItemModel) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: Computed properties
extension ItemModel {
    var thumbnailURL: URL? {
        guard let thumbnailID else { return nil }
        return URL(string: "https://http2.mlstatic.com/D_\(thumbnailID)-O.jpg")
    }
    
    var priceTitle: String? {
        return price?.formattedCurrency()
    }
}

// MARK: Mocks
extension ItemModel {
    
    static var mock: ItemModel = .init(
        id: "1",
        title: "Test Item",
        condition: ItemCondition.new,
        categoryID: "",
        thumbnailID: "839295-MLA74246453969_012024",
        currencyID: "",
        price: 2.000,
        originalPrice: 1.000,
        salePrice: 999,
        availableQuantity: 2,
        pictures: [.mock, .mock, .mock],
        seller: .init(id: 1, nickname: "Cristian"),
        attributes: .init(arrayLiteral: .init(name: "Title", valueName: "Some value")),
        discounts: nil,
        promotions: nil
    )
}

