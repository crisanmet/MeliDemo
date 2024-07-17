//
//  PictureModel.swift
//  MeliDemo
//
//  Created by Cristian Sancricca on 17/07/2024.
//

import Foundation

struct PictureModel: Codable, Identifiable {
    let id: String?
    let url: String?
}

extension PictureModel {
    var imageUrl: URL? {
        guard let url else { return nil }
        return URL(string: url)
    }
}

// MARK: Mocks
extension PictureModel {
    static var mock: PictureModel = .init(id: "1", url: "https://http2.mlstatic.com/D_793201-MLU74074058468_012024-O.jpg")
}
