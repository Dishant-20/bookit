//
//  ForgotPasswordVC.swift
//  Bookit
//
//  Created by Ranjan on 20/12/21.
//

import UIKit
import Alamofire

class ForgotPasswordVC: UIViewController {
    
    let paddingFromLeftIs:CGFloat = 40
    
    var str_OTP:String!
    var str_new_password:String!
    
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
            lblNavigationTitle.text = "Forgot password"
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
            btnResetPaasword.setTitle("Reset password", for: .normal)
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
            "Please enter your email address and you will receive an OTP on your registered email ID to reset new password."
            lblDetails.textColor = .white
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = APP_BASIC_COLOR
        self.navigationController?.isNavigationBarHidden = true
        self.hideKeyboardWhenTappedAround()
        
        self.btnBack.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.btnResetPaasword.addTarget(self, action: #selector(forgot_password), for: .touchUpInside)
    }
    
    @objc func back_click_method() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func forgot_password() {
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        let params = forgot_password_webservice(action: "forgotpassword",
                                                email: String(self.txtEmail.text!))
        
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
                    
                    var strSuccess_2 : String!
                    strSuccess_2 = (JSON["msg"] as! String)
                    
                    let alert = NewYorkAlertController(title: "Alert", message: String(strSuccess_2), style: .alert)
                    
                    let reset_now = NewYorkButton(title: "reset, now", style: .destructive) {
                        _ in
                        self.show_and_reset_OTP(str_email: String(self.txtEmail.text!))
                    }
                    
                    let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                    alert.addButtons([cancel,reset_now])
                    
                    self.present(alert, animated: true)
                    
                } else {
                    print("no")
                    ERProgressHud.sharedInstance.hide()
                    
                    var strSuccess2 : String!
                    strSuccess2 = JSON["msg"]as Any as? String
                    
                    if strSuccess2 == "Your Account is Inactive. Please contact admin.!!" ||
                        strSuccess2 == "Your Account is Inactive. Please contact admin.!" ||
                        strSuccess2 == "Your Account is Inactive. Please contact admin." {
                        
                        
                    } else {
                        
                        var strSuccess_2 : String!
                        strSuccess_2 = (JSON["msg"] as! String)
                        
                        let alert = NewYorkAlertController(title: "Alert", message: String(strSuccess_2), style: .alert)

                        
                        
                        let cancel = NewYorkButton(title: "dismiss", style: .cancel)
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
    
    @objc func show_and_reset_OTP(str_email:String) {

        let alert = NewYorkAlertController.init(title: "Reset password", message: "Please enter the OTP you have received in your registered email ID "+String(self.txtEmail.text!)+" to reset new password.", style: .alert)
        
        alert.addTextField { tf in
            tf.placeholder = "otp..."
            tf.tag = 1
        }
        
        alert.addTextField { tf in
            tf.placeholder = "new password..."
            tf.tag = 2
        }
        
        let ok = NewYorkButton(title: "OK", style: .default) { [unowned alert] _ in
            alert.textFields.forEach { tf in
                let text = tf.text ?? ""
                switch tf.tag {
                case 1:
                    print("otp: \(text)")
                    self.str_OTP = "\(text)"
                case 2:
                    print("new password: \(text)")
                    self.str_new_password = "\(text)"
                    
                    self.forgot_password_WBB(str_email_parse: String(str_email), str_OTP_parse: self.str_OTP, str_password_parse: self.str_new_password)
                default:
                    break
                }
            }
        }
        let cancel = NewYorkButton(title: "Cancel", style: .cancel)
        alert.addButtons([ok, cancel])
        
        alert.isTapDismissalEnabled = false
        
        present(alert, animated: true)
    }
        
    
    @objc func forgot_password_WBB(str_email_parse:String , str_OTP_parse:String , str_password_parse:String) {
        
        self.view.endEditing(true)
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        let params = forgot_password_WB(action: "resetpassword",
                                        email: String(str_email_parse),
                                        OTP: String(str_OTP_parse),
                                        password: String(str_password_parse))
        
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
                    
                    let alert = NewYorkAlertController(title: String(strSuccess).uppercased(), message: String(strSuccess2), style: .alert)
                    
                    let cancel = NewYorkButton(title: "dismiss", style: .cancel) {
                        _ in
                        self.back_click_method()
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
                        
                        
                    } else {
                        
                        let alert = NewYorkAlertController(title: String(strSuccess).uppercased(), message: String(strSuccess2), style: .alert)
                        
                        let yes_logout = NewYorkButton(title: "re-send", style: .destructive)
                        
                        let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                        alert.addButtons([cancel,yes_logout])
                        
                        self.present(alert, animated: true)
                        
                        /*let alert = UIAlertController(title: String(strSuccess).uppercased(), message: String(strSuccess2), preferredStyle: .alert)
                         
                         alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                         
                         self.present(alert, animated: true)*/
                        
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

