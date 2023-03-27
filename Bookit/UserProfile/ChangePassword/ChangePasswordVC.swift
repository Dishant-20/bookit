//
//  ChangePasswordVC.swift
//  Bookit
//
//  Created by Ranjan on 20/12/21.
//

import UIKit
import Alamofire

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
                btnBack.setImage(UIImage(systemName: "arrow.left"), for: .normal)
            }
        }
            
        @IBOutlet weak var lblNavigationTitle:UILabel! {
            didSet {
                lblNavigationTitle.text = "Change password"
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
            btnUpdatePaasword.setTitle("Update", for: .normal)
            btnUpdatePaasword.backgroundColor =  BUTTON_DARK_APP_COLOR
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = APP_BASIC_COLOR
        self.navigationController?.isNavigationBarHidden = true
        self.hideKeyboardWhenTappedAround()
        
        /*NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)*/
        
        // self.sideBarMenuClick()
        
        self.btnBack.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        
        self.btnUpdatePaasword.addTarget(self, action: #selector(validation_before_change_password), for: .touchUpInside)
        
    }
    
    @objc func back_click_method() {
        self.navigationController?.popViewController(animated: true)
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

    
    
    
    @objc func validation_before_change_password() {
        
        if String(self.txtCurrentPassword.text!) == "" {
            
            self.promt_value(str_message: "Old Password")
            
        } else if String(self.txtNewPassword.text!) == "" {
            
            self.promt_value(str_message: "New Password")
            
        } else if String(self.txtNewPassword.text!) != String(self.txtConfirmPassword.text!) {
            
            let alert = NewYorkAlertController(title: String("Alert"), message: "Password not matched. Please enter correct password.", style: .alert)
            
            alert.addImage(UIImage.gif(name: "gif_alert"))
            
            let cancel = NewYorkButton(title: "Ok", style: .cancel)
            alert.addButtons([cancel])
            
            self.present(alert, animated: true)
            
        } else {
            
            self.change_password_wb()
        }
        
    }
    
    @objc func promt_value(str_message:String) {
        
        let alert = NewYorkAlertController(title: String("Alert"), message: String(str_message)+String(" should not be empty"), style: .alert)
        
        alert.addImage(UIImage.gif(name: "gif_alert"))
        
        let cancel = NewYorkButton(title: "Ok", style: .cancel)
        alert.addButtons([cancel])
        
        self.present(alert, animated: true)
        
    }
    
    @objc func change_password_wb() {
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // print(person as Any)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            self.view.endEditing(true)
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
            
            let params = change_my_password(action: "changePassword",
                                                    userId: String(myString),
                                                    oldPassword: String(txtCurrentPassword.text!),
                                                    newPassword: String(txtNewPassword.text!))
            
            
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
                        
                        var strSuccess2 : String!
                        strSuccess2 = JSON["msg"]as Any as? String
                        
                        let alert = NewYorkAlertController(title: "Success", message: String(strSuccess2), style: .alert)
                        
                        alert.addImage(UIImage.gif(name: "success3"))
                        
                        let cancel = NewYorkButton(title: "Ok", style: .cancel) {
                            _ in
                            
                            self.txtCurrentPassword.text = ""
                            self.txtNewPassword.text = ""
                            self.txtConfirmPassword.text = ""
                            
                        }
                        alert.addButtons([cancel])
                        
                        self.present(alert, animated: true)
                         
                    } else {
                        print("no")
                        ERProgressHud.sharedInstance.hide()
                        
                        var strSuccess2 : String!
                        strSuccess2 = JSON["msg"]as Any as? String
                        
                        if strSuccess2 == "Your Account is Inactive. Please contact admin.!!" ||
                            strSuccess2 == "Your Account is Inactive. Please contact admin.!" ||
                            strSuccess2 == "Your Account is Inactive. Please contact admin." {
                            
                            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "adminApprovalVC")
                            self.navigationController?.pushViewController(push, animated: true)
                            
                        } else {
                            
                            let alert = NewYorkAlertController(title: String(strSuccess).uppercased(), message: String(strSuccess2), style: .alert)
                            
                            alert.addImage(UIImage.gif(name: "gif_alert"))
                            
                            let cancel = NewYorkButton(title: "Ok", style: .cancel)
                            
                            alert.addButtons([cancel])
                            
                            self.present(alert, animated: true)
                            
                        }
                        
                    }
                    
                case let .failure(error):
                    print(error)
                    ERProgressHud.sharedInstance.hide()
                    
                    // Utils.showAlert(alerttitle: SERVER_ISSUE_TITLE, alertmessage: SERVER_ISSUE_MESSAGE, ButtonTitle: "Ok", viewController: self)
                }
            }
        }
    }
    
    
    
    
}
