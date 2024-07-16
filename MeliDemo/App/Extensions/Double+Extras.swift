//
//  Double+Extras.swift
//  MeliDemo
//
//  Created by Cristian Sancricca on 15/07/2024.
//

import Foundation

extension Double {
    func formattedCurrency(for locale: Locale = .current) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
