//
//  LoginVC.swift
//  Bookit
//
//  Created by Ranjan on 18/12/21.
//

import UIKit
import Alamofire

class LoginVC: UIViewController,UITextFieldDelegate {
    
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
            lblNavigationTitle.text = "LOGIN"
            lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
            lblNavigationTitle.backgroundColor = .clear
        }
    }
    
    // ***************************************************************** // nav
    
    @IBOutlet weak var txtEmailAddress:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txtEmailAddress,
                              tfName: txtEmailAddress.text!,
                              tfCornerRadius: 27.5,
                              tfpadding: paddingFromLeftIs,
                              tfBorderWidth: 0.8,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Email Address")
        }
    }
    
    
    @IBOutlet weak var txtPassword:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txtPassword,
                              tfName: txtPassword.text!,
                              tfCornerRadius: 27.5,
                              tfpadding: paddingFromLeftIs,
                              tfBorderWidth: 0.8,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Password")
            txtPassword.isSecureTextEntry = true
        }
        
        
    }
    
    
    @IBOutlet weak var btnSignIn:UIButton!{
        
        didSet{
            btnSignIn.layer.cornerRadius = 27.5
            btnSignIn.clipsToBounds = true
            btnSignIn.setTitle("SIGN IN", for: .normal)
            btnSignIn.backgroundColor =  BUTTON_DARK_APP_COLOR
        }
    }
    @IBOutlet weak var btnForgotPassword:UIButton!{
        didSet{
            btnForgotPassword.setTitle("Forgot Password?", for: .normal)
            btnForgotPassword.addTarget(self, action: #selector(btnForgotPswdTapped), for: .touchUpInside)
        }
    }
    @IBOutlet weak var btnSignUp:UIButton!{
        didSet{
            let myAttribute = [ NSAttributedString.Key.font: UIFont(name: "Avenir Heavy", size: 20.0)!]
            
            let myString = NSMutableAttributedString(string: "Don't have an account - Sign Up", attributes: myAttribute )
            
            var myRange1 = NSRange(location: 0, length: 24)
            
            myString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range:myRange1 )
            
            btnSignUp.setAttributedTitle(myString, for: .normal)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = APP_BASIC_COLOR
        self.navigationController?.isNavigationBarHidden = true
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        btnSignUp.addTarget(self, action: #selector(btnSignUpTapped), for: .touchUpInside)
        
        btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        btnSignIn.addTarget(self, action: #selector(callBeforeLogin), for: .touchUpInside)
        
        
    }
    
    @objc func btnSignUpTapped(){
        
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignUpVC") as? SignUpVC
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnForgotPswdTapped(){
        
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ForgotPasswordVC") as? ForgotPasswordVC
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
    }
    
    @objc func btnSignInMethod(){
        
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NPHomeVC") as? NPHomeVC
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
    }
    
    // MARK:- VALIDATION BEFORE LOGIN -
    @objc func callBeforeLogin() {
        
        if String(txtEmailAddress.text!) == "" {
            self.fieldShoulNotBeEmptyPopup(strTitle: "Email Address")
        } else if String(txtPassword.text!) == "" {
            self.fieldShoulNotBeEmptyPopup(strTitle: "Password")
        } else {
            self.loginWB()
        }
        
    }
    
    @objc func fieldShoulNotBeEmptyPopup(strTitle:String) {
        
        let alert = UIAlertController(title: "Alert", message: String(strTitle)+" Field should not be empty", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true)
        
    }
    
    @objc func loginWB() {
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        let params = CustomerLogin(
            action: "login",
            password: String(self.txtPassword.text!),
            deviceToken: "",
            latitude: "",
            longitude: "",
            email: String(self.txtEmailAddress.text!))
        print(params as Any)
        
        AF.request(APPLICATION_BASE_URL,
                   method: .post,
                   parameters: params,
                   encoder: JSONParameterEncoder.default).responseJSON { response in
            // debugPrint(response.result)
            
            switch response.result {
            case let .success(value):
                
                let JSON = value as! NSDictionary
                print(JSON as Any)
                
                var strSuccess : String!
                strSuccess = (JSON["status"]as Any as? String)?.lowercased()
                print(strSuccess as Any)
                
                if strSuccess == String("success") {
                    print("yes")
                    
                    ERProgressHud.sharedInstance.hide()
                    
                    var dict: Dictionary<AnyHashable, Any>
                    dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                    
                    let defaults = UserDefaults.standard
                    defaults.setValue(dict, forKey: "keyLoginFullData")
                    //
                    //
                    if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
                        
                        print(person as Any)
                        
                        if (person["role"] as! String) == "Customer" {
                            
                            let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NPHomeVC") as? NPHomeVC
                            self.navigationController?.pushViewController(settingsVCId!, animated: true)
                            
                        }
                        
                        else if (person["role"] as! String) == "Club" {
                            
                            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NPClubDetailVC")
                            self.navigationController?.pushViewController(push, animated: true)
                            
                        }
                        
                        else {
                            
                            //                                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NPHomeVC")
                            //                                    self.navigationController?.pushViewController(push, animated: true)
                        }
                        
                    }
                    
                    
                } else {
                    print("no")
                    ERProgressHud.sharedInstance.hide()
                    
                    var strSuccess2 : String!
                    strSuccess2 = JSON["msg"]as Any as? String
                    
                    if strSuccess2 == "Your Account is Inactive. Please contact admin.!!" ||
                        strSuccess2 == "Your Account is Inactive. Please contact admin.!" ||
                        strSuccess2 == "Your Account is Inactive. Please contact admin." {
                        
                        
                    } else {
                        
                        let alert = UIAlertController(title: String(strSuccess).uppercased(), message: String(strSuccess2), preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        
                        self.present(alert, animated: true)
                        
                    }
                }
                
            case let .failure(error):
                print(error)
                ERProgressHud.sharedInstance.hide()
                
                // Utils.showAlert(alerttitle: SERVER_ISSUE_TITLE, alertmessage: SERVER_ISSUE_MESSAGE, ButtonTitle: "Ok", viewController: self)
            }
        }
        // }
    }
    
}
