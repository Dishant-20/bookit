//
//  GetStartedNowVC.swift
//  Bookit
//
//  Created by Ranjan on 18/12/21.
//

import UIKit

class GetStartedNowVC: UIViewController {
    
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
                lblNavigationTitle.text = "Get Started Now"
                lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
                lblNavigationTitle.backgroundColor = .clear
            }
        }
                    
    // ***************************************************************** // nav
    
    @IBOutlet weak var btnSignIn:UIButton!{
        didSet{
            btnSignIn.backgroundColor = NAVIGATION_COLOR
            btnSignIn.setTitle("Sign in", for: .normal)
            btnSignIn.layer.cornerRadius = 27.5
            btnSignIn.clipsToBounds = true
            
            btnSignIn.addTarget(self, action: #selector(btnSignInTapped), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var btnNightClubs:UIButton!{
        didSet{
            btnNightClubs.backgroundColor = BUTTON_DARK_APP_COLOR
            btnNightClubs.setTitle("Create an account", for: .normal)
            btnNightClubs.layer.cornerRadius = 27.5
            btnNightClubs.clipsToBounds = true
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = APP_BASIC_COLOR
        self.navigationController?.isNavigationBarHidden = true
        btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        btnNightClubs.addTarget(self, action: #selector(create_an_account), for: .touchUpInside)
        
    }
    
    
    
    @objc func btnSignInTapped(){
        
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
    }

    @objc func create_an_account() {
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignUpVC") as? SignUpVC
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
    }
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
