//
//  AttributesDetailView.swift
//  MeliDemo
//
//  Created by Cristian Sancricca on 18/07/2024.
//

import SwiftUI

struct AttributesDetailView: View {
    @Environment(\.dismiss) private var dismiss
    var attributes: [AttributeModel]
    
    var body: some View {
        ScrollView {
            AttributeListView(attributes: attributes)
                .padding(.horizontal, 12)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                }
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitle("Características del producto", displayMode: .inline)
    }
}
