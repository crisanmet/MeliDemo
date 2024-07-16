//
//  TabBarViewController.swift
//  MeliDemo
//
//  Created by Cristian Sancricca on 12/07/2024.
//

import UIKit
import SwiftUI

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        let listSearchVC = UINavigationController(rootViewController: UIHostingController(rootView: ListSearchView()))
        let favoriteVC = UINavigationController(rootViewController: UIHostingController(rootView: ListSearchView()))
        
        listSearchVC.tabBarItem.image = UIImage(systemName: "house")
        favoriteVC.tabBarItem.image = UIImage(systemName: "heart")
        
        listSearchVC.title = "Inicio"
        favoriteVC.title = "Favoritos"
        
        tabBar.tintColor = .blue
        setViewControllers([listSearchVC, favoriteVC], animated: true)
        
    }
}
