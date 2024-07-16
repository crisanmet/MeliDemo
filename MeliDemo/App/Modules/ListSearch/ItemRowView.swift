//
//  ItemRowView.swift
//  MeliDemo
//
//  Created by Cristian Sancricca on 15/07/2024.
//

import SwiftUI
import Kingfisher

struct ItemRowView: View {
    @State private var isFavoriteSelected = false
    let item: ItemModel
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                ZStack {
                    Color.gray.opacity(0.1)
                        .frame(width: 170, height: 170)
                        .cornerRadius(8)
                    
                    KFImage(item.thumbnailURL)
                        .placeholder {
                            ProgressView()
                                .frame(width: 150, height: 150)
                        }
                        .resizable()
                        .frame(width: 150, height: 150)
                        .scaledToFit()
                }
                .overlay(alignment: .topTrailing) {
                    heartOverlay
                        .padding(10)
                }
                
                VStack(alignment: .leading) {
                    if let title = item.title {
                        Text(title)
                            .font(.headline)
                    }
                    
                    if let priceTitle = item.priceTitle {
                        Text(priceTitle)
                            .font(.subheadline)
                    }
                }
                
                Spacer()
            }
            .padding()
            .cornerRadius(8)
            Divider()
        }
    }
    
    private var heartOverlay: some View {
        ZStack {
            Circle()
                .fill(.white.opacity(0.6))
                .frame(width: 36, height: 36)
            
            Button(action: {
                // ToDo Action to save favorites
                isFavoriteSelected.toggle()
            }) {
                Image(systemName: isFavoriteSelected ? "heart.fill" : "heart")
                    .foregroundColor(.blue)
                    .font(.title2)
            }
        }
    }
}

#Preview {
    ItemRowView(item: ItemModel.mock)
}
