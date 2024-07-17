//
//  AttributeModel.swift
//  MeliDemo
//
//  Created by Cristian Sancricca on 17/07/2024.
//

import Foundation

struct AttributeModel: Codable, Identifiable {
    let id = UUID().uuidString
    let name: String?
    let valueName: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case valueName = "value_name"
    }
}
