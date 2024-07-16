//
//  Bundle.swift
//  MeliDemo
//
//  Created by Cristian Sancricca on 15/07/2024.
//

import Foundation

extension Bundle {
    public func config(forKey key: String) -> String {
        let config = Bundle.main.object(forInfoDictionaryKey: "App Config") as? [String: String]
        return config?[key] ?? ""
    }
}
