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
    let onItemTapped: () -> Void
    let isHorizontal: Bool
    
    var body: some View {
        Group {
            if isHorizontal {
                VStack(alignment: .center) {
                    itemImage
                    Divider()
                        .padding()
                    itemDetails
                   
                }
                .background(.white)
                .shadow(radius: 1)
                .frame(width: 160)
                
            } else {
                HStack(alignment: .top) {
                    itemImage
                    itemDetails
                }
                Divider()
            }
        }
        .padding()
        .cornerRadius(8)
        .contentShape(Rectangle())
        .onTapGesture {
            onItemTapped()
        }
    }
    
    private var itemImage: some View {
        ZStack {
            Color.gray.opacity(0.1)
                .frame(width: 150, height: 170)
                .cornerRadius(8)
            
            KFImage(item.thumbnailURL)
                .placeholder {
                    ProgressView()
                        .frame(width: 150, height: 100)
                }
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 160)
                .clipped()
                .overlay(alignment: .topTrailing) {
                    heartOverlay
                        .padding(4)
                }
        }
    }
    
    private var itemDetails: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let title = item.title {
                Text(title)
                    .font(.subheadline)
            }
            
            if let priceTitle = item.priceTitle {
                Text(priceTitle)
                    .font(.headline)
            }
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
    ItemRowView(item: ItemModel.mock, onItemTapped: { }, isHorizontal: true)
}
