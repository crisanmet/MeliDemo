//
//  NavigationManager.swift
//  MeliDemo
//
//  Created by Cristian Sancricca on 16/07/2024.
//

import UIKit
import Factory

extension Container {
    var navigationManager: Factory<NavigationManager> {
        self { DefaultNavigationManager() }.scope(.singleton)
    }
}

protocol NavigationManager {
    var navigationController: UINavigationController? { get set }
    
    func push(vc: UIViewController)
}

final class DefaultNavigationManager: NavigationManager {
    
    var navigationController: UINavigationController?
    
    func push(vc: UIViewController) {
        vc.navigationItem.hidesBackButton = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
