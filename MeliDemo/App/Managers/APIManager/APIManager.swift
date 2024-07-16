//
//  APIManager.swift
//  MeliDemo
//
//  Created by Cristian Sancricca on 13/07/2024.
//

import Foundation
import Factory
import Network
import OSLog

extension Container {
    var apiManager: Factory<APIManager> {
        self { DefaultAPIManager() }.scope(.singleton)
    }
}

protocol APIManager {
    func performGetRequest<T: Decodable>(endpoint: APIEndpoint) async throws -> T
    var hasInternet: Bool { get }
}

enum APIError: Error {
    case invalidURL
    case noData
    case noInternetConnection
    case decodingError(Error)
}

enum APIEndpoint {
    case search(query: String, offset: Int, limit: Int)
    case itemDetail(itemId: String)
    case itemDescription(itemId: String)
    case sellerSearch(sellerId: String)
    
    var path: String {
        switch self {
        case .search(let query, let offset, let limit):
            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return "/search?q=\(encodedQuery)&offset=\(offset)&limit=\(limit)"
        case .itemDetail(let itemId):
            return "/items/\(itemId)"
        case .itemDescription(let itemId):
            return "/items/\(itemId)/description"
        case .sellerSearch(let sellerId):
            return "/search?seller_id=\(sellerId)"
        }
    }
    
    var url: URL? {
        switch self {
        case .search, .sellerSearch:
            return URL(string: "\(Constants.Config.apiUrl)/sites/MLA\(path)")
        default:
            return URL(string: "\(Constants.Config.apiUrl)\(path)")
        }
    }
}

public final class DefaultAPIManager: APIManager {
    
    private let logger = Logger(subsystem: "meliDemo", category: "API")
    private var monitor: NWPathMonitor
    var hasInternet: Bool = true

    init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = {  path in
            self.hasInternet = path.status == .satisfied
        }
        
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
    deinit {
        monitor.cancel()
    }
        
    func performGetRequest<T: Decodable>(endpoint: APIEndpoint) async throws -> T {
        guard hasInternet else {
            logger.error("No internet connection")
            throw APIError.noInternetConnection
        }
        
        guard let url = endpoint.url else {
            logger.error("Invalid URL: \(String(describing: endpoint.url))")
            throw APIError.invalidURL
        }
        
        logger.info("Performing GET request to URL: \(url.absoluteString)")

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            logger.error("Received non-200 response: \(String(describing: response))")
            throw APIError.noData
        }
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            logger.info("Successfully decoded data")
            return decodedData
        } catch {
            logger.error("Decoding error: \(error.localizedDescription)")
            throw APIError.decodingError(error)
        }
    }
}
