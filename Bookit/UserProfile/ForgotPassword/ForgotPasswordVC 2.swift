//
//  ForgotPasswordVC.swift
//  Bookit
//
//  Created by Ranjan on 20/12/21.
//

import UIKit

class ForgotPasswordVC: UIViewController {
    
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
                lblNavigationTitle.text = "FORGOT PAASWORD"
                lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
                lblNavigationTitle.backgroundColor = .clear
            }
        }
                    
    // ***************************************************************** // nav
    
    @IBOutlet weak var txtEmail:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txtEmail,
                              tfName: txtEmail.text!,
                              tfCornerRadius: 27.5,
                              tfpadding: paddingFromLeftIs,
                              tfBorderWidth: 0.8,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Enter Email Address")
        }
    }
    
    @IBOutlet weak var btnResetPaasword:UIButton!{
        
        didSet{
            btnResetPaasword.layer.cornerRadius = 27.5
            btnResetPaasword.clipsToBounds = true
            btnResetPaasword.setTitle("RESET PAASWORD", for: .normal)
            btnResetPaasword.backgroundColor =  BUTTON_DARK_APP_COLOR
            btnResetPaasword.tintColor = .white
        }
    }
    
    @IBOutlet weak var viw:UIView!{
        didSet{
            viw.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var lblDetails:UILabel!{
        didSet{
            lblDetails.text =
            """
            Please enter your email address.
            You will receive a link to create a new
            password via email.
            """
            lblDetails.textColor = .white
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = APP_BASIC_COLOR
        self.navigationController?.isNavigationBarHidden = true
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    


}
