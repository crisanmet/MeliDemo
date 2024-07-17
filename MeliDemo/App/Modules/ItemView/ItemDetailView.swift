//
//  ItemDetailView.swift
//  MeliDemo
//
//  Created by Cristian Sancricca on 16/07/2024.
//

import SwiftUI
import Kingfisher

struct ItemDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: ItemDetailViewModel
    @State private var currentTabIndex: Int = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                AsyncContentView(source: viewModel) {
                    if let condition = viewModel.item.condition?.title {
                        customText(condition, font: .caption)
                    }
                    
                    if let title = viewModel.item.title {
                        customText(title, font: .subheadline)
                    }
                    
                    if let pictures = viewModel.item.pictures {
                        tabViewPicture(pictures: pictures)
                    }
                    
                    if let priceTitle = viewModel.item.priceTitle {
                        customText(priceTitle, font: .headline)
                    }
                    
                    buttonsView
                    
                    if let sellerNick = viewModel.nickName {
                        sellerNickView(nick: sellerNick)
                    }
                    
                    if let attributes = viewModel.item.attributes {
                        attributesView(attributes: attributes)
                    }
                }
            }
            
        }
        .onAppear {
            Task {
                await viewModel.loadData()
            }
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
    }
}

// MARK: TextView
private func customText(_ text: String, font: Font) -> some View {
    Text(text)
        .font(font)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 12)
        .padding(.top, 6)
}

// MARK: Views
extension ItemDetailView {
    private func tabViewPicture(pictures: [PictureModel]) -> some View {
        VStack {
            TabView(selection: $currentTabIndex) {
                ForEach(pictures.indices, id: \.self) { index in
                    KFImage(pictures[index].imageUrl)
                        .resizable()
                        .scaledToFit()
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 300)
            
            HStack(spacing: 5) {
                // For now only showing up 5 dots.
                ForEach(0..<min(pictures.count, 5), id: \.self) { index in
                    Circle()
                        .fill(index == currentTabIndex ? .blue : .gray.opacity(0.6))
                        .frame(width: 8, height: 8)
                        .onTapGesture {
                            currentTabIndex = index
                        }
                }
            }
            .padding(.top, 5)
        }
    }
    
    private var buttonsView: some View {
        VStack(spacing: 8) {
            Button(action: {
                // TODO
            }) {
                Text("Comprar Ahora")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding([.leading, .trailing], 12)
            }
            
            Button(action: {
                // TODO
            }) {
                Text("Agregar al carrito")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.blue.opacity(0.2))
                    .foregroundColor(.blue)
                    .cornerRadius(8)
                    .padding([.leading, .trailing], 12)
            }
        }
    }
    
    private func sellerNickView(nick: String) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            Text("Vendido por ")
                .font(.caption)
                .foregroundColor(.gray)
            
            Text(nick)
                .font(.caption)
                .foregroundColor(.blue)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 6)
        .padding(.horizontal, 12)
    }
    
    private func attributesView(attributes: [AttributeModel]) -> some View {
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
                .stroke(.gray.opacity(0.6), lineWidth: 0.5)
        )
        .padding()
    }
}

#Preview {
    ItemDetailView(viewModel: ItemDetailViewModel(item: .mock))
}
