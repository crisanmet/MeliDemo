//
//  MockService.swift
//  MeliDemoTests
//
//  Created by Cristian Sancricca on 17/07/2024.
//

import Foundation
@testable import MeliDemo

final class MockService: APIManager {
    var mockData: SearchResponse?
    var hasInternet: Bool
    
    init(mockData: SearchResponse?, hasInternet: Bool = true) {
        self.mockData = mockData
        self.hasInternet = hasInternet
    }
    
    func performGetRequest<T: Decodable>(endpoint: MeliDemo.APIEndpoint) async throws -> T {
        guard hasInternet else {
            throw APIError.noInternetConnection
        }
        
        if let mockData = mockData as? T {
            return mockData
        } else {
            throw APIError.noData
        }
    }
}
