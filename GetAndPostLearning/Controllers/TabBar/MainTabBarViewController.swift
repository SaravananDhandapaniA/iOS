//
//  MainTabBarViewController.swift
//  GetAndPostLearning
//
//  Created by Tringapps on 14/06/23.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    var userData: Register?

    override func viewDidLoad() {
        super.viewDidLoad()
        PrepareTabItems()
    }
    
    init(userData: Register) {
        self.userData = userData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func PrepareTabItems() {
        
        let vc1 = UINavigationController(rootViewController: setupHomeVC())
        let vc2 = UINavigationController(rootViewController: UpComingViewController())
        let vc3 = UINavigationController(rootViewController: SearchViewController())
        let vc4 = UINavigationController(rootViewController: DownloadsViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "play.circle")
        vc3.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc4.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        
        vc1.title = "Home"
        vc2.title = "Coming Soon"
        vc3.title = "Top Search"
        vc4.title = "Downloads"
        
        tabBar.barTintColor = .gray
        tabBar.backgroundColor = .black
        tabBar.backgroundImage = UIImage.imageWithColor(color: .black, size: self.tabBar.frame.size)
        
        setViewControllers([vc1,vc2,vc3,vc4], animated: true)
    }
 
    
    func setupHomeVC() -> UIViewController {
        let storyBoard = UIStoryboard(name: "HomeViewController", bundle: nil)
        let homeVC = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        homeVC.loginUser = userData
        return homeVC
    }
}
