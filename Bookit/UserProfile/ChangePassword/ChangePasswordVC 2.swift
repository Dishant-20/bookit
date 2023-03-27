//
//  ChangePasswordVC.swift
//  Bookit
//
//  Created by Ranjan on 20/12/21.
//

import UIKit

class ChangePasswordVC: UIViewController {
    
    let paddingFromLeftIs:CGFloat = 40
    
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
                lblNavigationTitle.text = "CHANGE PASSWORD"
                lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
                lblNavigationTitle.backgroundColor = .clear
            }
        }
                    
    // ***************************************************************** // nav
    
    @IBOutlet weak var txtCurrentPassword:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txtCurrentPassword,
                              tfName: txtCurrentPassword.text!,
                              tfCornerRadius: 27.5,
                              tfpadding: paddingFromLeftIs,
                              tfBorderWidth: 0.8,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Current Password")
        }
    }
    
    @IBOutlet weak var txtNewPassword:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txtNewPassword,
                              tfName: txtNewPassword.text!,
                              tfCornerRadius: 27.5,
                              tfpadding: paddingFromLeftIs,
                              tfBorderWidth: 0.8,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "New Password")
        }
    }
    
    @IBOutlet weak var txtConfirmPassword:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txtConfirmPassword,
                              tfName: txtConfirmPassword.text!,
                              tfCornerRadius: 27.5,
                              tfpadding: paddingFromLeftIs,
                              tfBorderWidth: 0.8,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Confirm Password")
        }
    }
    
  
    
    @IBOutlet weak var btnUpdatePaasword:UIButton!{
        
        didSet{
            btnUpdatePaasword.layer.cornerRadius = 27.5
            btnUpdatePaasword.clipsToBounds = true
            btnUpdatePaasword.setTitle("UPDATE PAASWORD", for: .normal)
            btnUpdatePaasword.backgroundColor =  BUTTON_DARK_APP_COLOR
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = APP_BASIC_COLOR
        self.navigationController?.isNavigationBarHidden = true
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
