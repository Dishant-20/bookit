//
//  tab_bar_controller.swift
//  Bookit
//
//  Created by Apple on 05/04/22.
//

import UIKit

class tab_bar_controller: UITabBarController {
    
    let selectTabBarBGcolor = UIColor.systemBlue//init(red: 254.0/255.0, green: 247.0/255.0, blue: 214.0/255.0, alpha: 1)
    let tabbarBGcolor = UIColor.init(red: 255.0/255.0, green: 225.0/255.0, blue: 187.0/255.0, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        /*if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
        // print(person as Any)
            
            if (person["role"] as! String) == "Customer" {
                self.tabBarController?.tabBar.items![2].image = UIImage(named: "help_tab")
            } else {
                
            }
            
        }*/
        
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


extension UIImage {
    
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

