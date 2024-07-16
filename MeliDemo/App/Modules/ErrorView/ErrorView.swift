//
//  ErrorView.swift
//  MeliDemo
//
//  Created by Cristian Sancricca on 16/07/2024.
//

import SwiftUI

struct ErrorView: View {
    
    @Environment(\.dismiss) var dismiss
    let errorTitle: String
    let onReloadAction: (() -> Void)
    
    var body: some View {
        Text(errorTitle)
            .padding()
            .multilineTextAlignment(.center)
        
        Button(action: {
            onReloadAction()
        }, label: {
            Text("Reintentar")
        })
        .padding(.horizontal, 12)
    }
}

#Preview {
    ErrorView(errorTitle: "Something went wrong", onReloadAction: { })
}
