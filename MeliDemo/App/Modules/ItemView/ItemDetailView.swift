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
        GeometryReader { geo in
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    AsyncContentView(source: viewModel) {
                        if let condition = viewModel.item.condition?.title {
                            customText(condition, font: .caption)
                        }
                        
                        if let title = viewModel.item.title, !title.isEmpty {
                            customText(title, font: .subheadline)
                        }
                        
                        if let pictures = viewModel.item.pictures, !pictures.isEmpty {
                            tabViewPicture(pictures: pictures)
                        }
                        
                        if let priceTitle = viewModel.item.priceTitle {
                            customText(priceTitle, font: .headline)
                        }
                        
                        buttonsView
                        
                        if let sellerNick = viewModel.seller?.nickname, !sellerNick.isEmpty {
                            sellerNickView(nick: sellerNick)
                        }
                        
                        if let attributes = viewModel.item.attributes, !attributes.isEmpty {
                            Divider()
                            customText("Caracteristicas del Producto", font: .title2)
                            AttributeListView(attributes: Array(attributes.prefix(6)))
                            
                            if attributes.count > 6 {
                                showMoreAttributesButton
                            }
                        }
                        
                        if let itemDescription = viewModel.itemDescription?.plainText, !itemDescription.isEmpty {
                            Divider()
                            customText("Description", font: .title2)
                            customText(itemDescription, font: .callout)
                        }
                        
                        if let sellerRelatedItems = viewModel.sellerRelatedItems, !sellerRelatedItems.isEmpty {
                            Divider()
                            customText("Otros productos del vendedor", font: .title2)
                                .padding(.top, 10)
                            self.sellerRelatedItems(items: sellerRelatedItems)
                        }
                    }
                    Spacer()
                }
                .frame(minHeight: geo.size.height)
            }
            .scrollIndicators(.hidden)
            .padding(.bottom, 20)
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
}

// MARK: TextView
private func customText(_ text: String, font: Font) -> some View {
    Text(text)
        .font(font)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
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
        .padding([.top, .bottom], 10)
        .padding(.horizontal, 16)
    }
    
    private var showMoreAttributesButton: some View {
        VStack {
            HStack {
                Text("Ver todas las características")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.blue)
            }
            .contentShape(Rectangle())
            .padding(16)
            .background(RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.6), lineWidth: 0.5))
            .onTapGesture {
                NavigationManager.shared.showAttributesView(attributes: viewModel.item.attributes ?? [])
            }
        }
        .padding(.horizontal)
    }
    
    private func sellerRelatedItems(items: [ItemModel]) -> some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 0) {
                ForEach(items) { item in
                    ItemRowView(item: item, onItemTapped: {
                        NavigationManager.shared.showDetailItemView(item: item)
                    }, isHorizontal: true)
                    .padding()
                }
            }
        }
        .scrollIndicators(.hidden)
        .padding(.top, 10)
    }
}

#Preview {
    ItemDetailView(viewModel: ItemDetailViewModel(item: .mock))
}
