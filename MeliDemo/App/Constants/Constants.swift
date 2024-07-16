//
//  Constants.swift
//  MeliDemo
//
//  Created by Cristian Sancricca on 15/07/2024.
//

import Foundation

struct Constants {
    
    struct Config {
        static let apiUrl = Bundle.main.config(forKey: "API_URL")
    }
    
    struct UserDefault {
        static let recentSearches = "recentSearches"
    }
}
