//
//  Helpers+Extras.swift
//  MeliDemoTests
//
//  Created by Cristian Sancricca on 17/07/2024.
//

import Foundation

private class TestHelper { } // TO get correct bundle.

func loadJSONFromBundle<T: Decodable>(_ filename: String, as type: T.Type) -> T {
    let data: Data
    let bundle = Bundle(for: TestHelper.self)
    
    guard let filePath = bundle.path(forResource: filename, ofType: "json") else {
        fatalError("Couldnt find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: URL(fileURLWithPath: filePath))
    } catch {
        fatalError("Couldnt load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        return try JSONDecoder().decode(T.self, from: data)
    } catch {
        fatalError("Couldtt parse \(filename) as \(T.self):\n\(error)")
    }
}
