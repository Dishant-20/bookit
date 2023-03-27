//
//  tav_bar_controller_club.swift
//  Bookit
//
//  Created by Apple on 05/04/22.
//

import UIKit

class tav_bar_controller_club: UITabBarController {

    let selectTabBarBGcolor = UIColor.systemBlue//init(red: 254.0/255.0, green: 247.0/255.0, blue: 214.0/255.0, alpha: 1)
    let tabbarBGcolor = UIColor.init(red: 255.0/255.0, green: 225.0/255.0, blue: 187.0/255.0, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // unselect icons tint color
        tabBar.unselectedItemTintColor = .white
        
        // tabbar background color
        tabBar.backgroundColor = .systemBlue
        
        // tabbar selected color
        UITabBar.appearance().tintColor = .systemOrange
        // tabBar.tintColor = .white
        
        // remove default border
        tabBar.frame.size.width = self.view.frame.width //  + 4
        tabBar.frame.origin.x = self.view.frame.height
        
    }

}
