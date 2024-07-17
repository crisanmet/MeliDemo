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
        setupAppearance()
        setupTabs()
    }
    
    private func setupTabs() {
        let listSearchVC = UINavigationController(rootViewController: UIHostingController(rootView: ListSearchView()))
        let favoriteVC = UINavigationController(rootViewController: UIHostingController(rootView: ListSearchView()))
        
        listSearchVC.tabBarItem.image = UIImage(systemName: "house")
        favoriteVC.tabBarItem.image = UIImage(systemName: "heart")
        
        listSearchVC.title = "Inicio"
        favoriteVC.title = "Favoritos"
        
        setViewControllers([listSearchVC, favoriteVC], animated: true)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupAppearance() {
        view.backgroundColor = .white
        tabBar.tintColor = .blue
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .main
        navBarAppearance.shadowColor = .clear
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UIPageControl.appearance().currentPageIndicatorTintColor = .blue
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
    }
}
