//
//  AttributeListView.swift
//  MeliDemo
//
//  Created by Cristian Sancricca on 18/07/2024.
//

import SwiftUI

struct AttributeListView: View {
    var attributes: [AttributeModel]
    
    var body: some View {
        // TODO map per id value. e.g. "DISPLAY_PIXELS_PER_INCH", "DISPLAY_ASPECT_RATIO"
        VStack(alignment: .leading, spacing: 8) {
            ForEach(Array(attributes.enumerated()), id: \.element.id) { index, attribute in
                if let attributeTitle = attribute.name,
                   let attributeValue = attribute.valueName {
                    HStack {
                        Text(attributeTitle)
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(attributeValue)
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(10)
                    .background(index % 2 == 0 ? .white : .gray.opacity(0.1))
                }
            }
        }
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.gray.opacity(0.3), lineWidth: 0.5)
        )
        .padding()
    }
}
