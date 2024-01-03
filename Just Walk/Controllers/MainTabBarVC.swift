//
//  ViewController.swift
//  Just Walk
//
//  Created by user on 31/12/23.
//

import UIKit

class MainTabBarVC: UITabBarController {
    
//    let databaseService = DatabaseService()
    // databaseService: databaseService
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = UINavigationController(rootViewController: HomeVC())
        let vc2 = UINavigationController(rootViewController: SavedPlacesVC())
        
        vc1.tabBarItem.image = UIImage(systemName: "house.fill")
        vc2.tabBarItem.image = UIImage(systemName: "heart.fill")
        
        vc1.title = "Home"
        vc2.title = "Saved"
        
        setViewControllers([vc1,vc2], animated: true)
        tabBar.tintColor = .label
        
    }
}

