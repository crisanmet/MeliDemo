//
//  AsyncContentView.swift
//  MeliDemo
//
//  Created by Cristian Sancricca on 16/07/2024.
//

import SwiftUI
import SwiftfulLoadingIndicators

public enum LoadingState: Equatable {
    case loading
    case failed(errorTitle: String)
    case loaded
}

public protocol Loadable: ObservableObject {
    var state: LoadingState { get }
    func loadData() async
}

public struct AsyncContentView<Source: Loadable, Content: View>: View {
    @ObservedObject var source: Source
    let content: () -> Content
    
    public init(source: Source, @ViewBuilder content: @escaping () -> Content) {
        self.source = source
        self.content = content
    }
    
    public var body: some View {
        VStack {
            Group {
                switch source.state {
                case .loading:
                    LoadingIndicator(animation: .circleRunner, color: .blue, size: .medium)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .failed(let title):
                    ErrorView(errorTitle: title, onReloadAction: {
                        Task {
                            await source.loadData()
                        }
                    })
                    .frame(maxWidth: .infinity)
                case .loaded:
                    content()
                }
            }
        }
    }
}
