//
//  HelpVC.swift
//  Bookit
//
//  Created by Ranjan on 20/12/21.
//

import UIKit

class HelpVC: UIViewController {
    
    // ***************************************************************** // nav
                    
        @IBOutlet weak var navigationBar:UIView! {
            didSet {
                navigationBar.backgroundColor = NAVIGATION_COLOR
                navigationBar.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
                navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                navigationBar.layer.shadowOpacity = 1.0
                navigationBar.layer.shadowRadius = 15.0
                navigationBar.layer.masksToBounds = false
            }
        }
            
       @IBOutlet weak var btnBack:UIButton! {
            didSet {
                btnBack.tintColor = NAVIGATION_BACK_COLOR
            }
        }
            
        @IBOutlet weak var lblNavigationTitle:UILabel! {
            didSet {
                lblNavigationTitle.text = "HELP"
                lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
                lblNavigationTitle.backgroundColor = .clear
            }
        }
                    
    // ***************************************************************** // nav
    
    @IBOutlet weak var viw:UIView!{
        didSet{
            viw.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var btnPhone:UIButton!{
        
        didSet{
            //btnPhone.layer.cornerRadius = 27.5
            //btnPhone.clipsToBounds = true
            btnPhone.setTitle("1800-234-5678", for: .normal)
            btnPhone.backgroundColor =  .clear
            btnPhone.tintColor = .white
        }
    }
    
    @IBOutlet weak var btnEmail:UIButton!{
        
        didSet{
            btnEmail.layer.cornerRadius = 27.5
            btnEmail.clipsToBounds = true
            btnEmail.setTitle("support@bookit.com", for: .normal)
            btnEmail.backgroundColor =  .clear
            btnEmail.tintColor = .white
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = APP_BASIC_COLOR
        self.navigationController?.isNavigationBarHidden = true
        self.sideBarMenuClick()
    }
    
    @objc func sideBarMenuClick() {
            
            let defaults = UserDefaults.standard
            defaults.setValue("", forKey: "keyBackOrSlide")
            defaults.setValue(nil, forKey: "keyBackOrSlide")
            
            if revealViewController() != nil {
            btnBack.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
                revealViewController().rearViewRevealWidth = 300
                view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
              }
        }
}
