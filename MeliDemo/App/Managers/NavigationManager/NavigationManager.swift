//
//  NavigationManager.swift
//  MeliDemo
//
//  Created by Cristian Sancricca on 16/07/2024.
//

import UIKit
import SwiftUI

final class NavigationManager {
    
    static let shared = NavigationManager()
    
    var navigationController: UINavigationController?
    
    func showDetailItemView(item: ItemModel) {
        let vc = UIHostingController(rootView: ItemDetailView(viewModel: .init(item: item)))
        vc.navigationItem.hidesBackButton = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
