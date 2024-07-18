//
//  SearchBarView.swift
//  MeliDemo
//
//  Created by Cristian Sancricca on 12/07/2024.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var text: String
    @Binding var isEditing: Bool
    var onSearch: () async -> Void

    var body: some View {
        HStack {
            TextField("Buscar en Mercado Libre", text: $text, onEditingChanged: { isEditing in
                self.isEditing = isEditing
            })
                .padding(8)
                .padding(.horizontal, 24)
                .font(.system(size: 14))
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .font(.system(size: 12))
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if !text.isEmpty {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                }
                .padding(.horizontal, 10)
                .onSubmit {
                    Task { @MainActor in
                        await onSearch()
                        isEditing = false
                    }
                }
            
            if isEditing {
                Button("Cancelar") {
                    isEditing = false
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                .padding(.trailing, 10)
                .foregroundColor(.black)
                .transition(.move(edge: .trailing))
            }
        }
    }
}

#Preview {
    @State var searchText = ""
    @State var isEditing = true
    return SearchBarView(text: $searchText, isEditing: $isEditing, onSearch: {})
}
