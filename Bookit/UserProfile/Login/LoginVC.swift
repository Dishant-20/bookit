//
//  LoginVC.swift
//  Bookit
//
//  Created by Ranjan on 18/12/21.
//

import UIKit
import Alamofire

// MARK:- LOCATION -
import CoreLocation

class LoginVC: UIViewController,UITextFieldDelegate , CLLocationManagerDelegate {
    
    let paddingFromLeftIs:CGFloat = 40
    
    let locationManager = CLLocationManager()
    
    var myDeviceTokenIs:String!
    
    // MARK:- SAVE LOCATION STRING -
    var strSaveLatitude:String! = "0"
    var strSaveLongitude:String! = "0"
    var strSaveCountryName:String!
    var strSaveLocalAddress:String!
    var strSaveLocality:String!
    var strSaveLocalAddressMini:String!
    var strSaveStateName:String!
    var strSaveZipcodeName:String!
    
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
        // self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        btnSignUp.addTarget(self, action: #selector(btnSignUpTapped), for: .touchUpInside)
        
        btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        btnSignIn.addTarget(self, action: #selector(callBeforeLogin), for: .touchUpInside)
        
        self.get_current_location_permission()
    }
    
    @objc func btnSignUpTapped(){
        
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignUpVC") as? SignUpVC
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnForgotPswdTapped() {
        
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ForgotPasswordVC") as? ForgotPasswordVC
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
    }
    
    @objc func btnSignInMethod() {
        
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
    
    @objc func get_current_location_permission() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            
            let authorizationStatus: CLAuthorizationStatus
            
            if #available(iOS 14, *) {
                authorizationStatus = locationManager.authorizationStatus
            } else {
                authorizationStatus = CLLocationManager.authorizationStatus()
            }
            
            switch authorizationStatus {
            case .notDetermined, .restricted, .denied:
                print("No access")
                self.strSaveLatitude = "0"
                self.strSaveLongitude = "0"
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
                
            @unknown default:
                break
            }
        }
        
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        // let indexPath = IndexPath.init(row: 0, section: 0)
        // let cell = self.tbleView.cellForRow(at: indexPath) as! PDCompleteAddressDetailsTableCell
        
        let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        location.fetchCityAndCountry { city, country, zipcode,localAddress,localAddressMini,locality, error in
            guard let city = city, let country = country,let zipcode = zipcode,let localAddress = localAddress,let localAddressMini = localAddressMini,let locality = locality, error == nil else { return }
            
            self.strSaveCountryName     = country
            self.strSaveStateName       = city
            self.strSaveZipcodeName     = zipcode
            
            self.strSaveLocalAddress     = localAddress
            self.strSaveLocality         = locality
            self.strSaveLocalAddressMini = localAddressMini
            
            self.strSaveLatitude = "\(locValue.latitude)"
            self.strSaveLongitude = "\(locValue.longitude)"
            
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    @objc func loginWB() {
        
        self.view.endEditing(true)
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        let params = CustomerLogin(
            action: "login",
            password: String(self.txtPassword.text!),
            deviceToken: "",
            latitude: String(self.strSaveLatitude),
            longitude:String(self.strSaveLongitude),
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
                    
                    if (dict["role"] as! String) == "Customer" {
                        
                        if "\(dict["emailVerify"]!)" == "0" {
                            
                            let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Please verify your account"), style: .alert)
                            
                            
                            let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                            alert.addButtons([cancel])
                            
                            self.present(alert, animated: true)
                            
                        } else {
                            if (dict["address"] as! String) == "" {
                                
                                let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "customer_complete_profile_id") as? customer_complete_profile
                                
                                settingsVCId!.str_edit_profile = "no"
                                
                                self.navigationController?.pushViewController(settingsVCId!, animated: true)
                                
                            } else {
                                
                            let tab_bar = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "tab_bar_controller_id") as? tab_bar_controller
                            tab_bar?.selectedIndex = 0
                            self.navigationController?.pushViewController(tab_bar!, animated: false)
                                
                            }
                        }
                        
                        
                    } else {
                        
                        if (dict["openTime"] as! String) == "" {
                            
                            let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddressVC") as? AddressVC
                            self.navigationController?.pushViewController(settingsVCId!, animated: true)
                            
                        } else {
                            
                            let tab_bar = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "tav_bar_controller_club_id") as? tav_bar_controller_club
                            tab_bar?.selectedIndex = 0
                            self.navigationController?.pushViewController(tab_bar!, animated: false)
                            
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
                        
                        
                    } else if strSuccess2 == "Email or password is wrong." {
                        
                        let alert = NewYorkAlertController(title: String(strSuccess).uppercased(), message: String(strSuccess2), style: .alert)
                        
                        
                        let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                        alert.addButtons([cancel])
                        
                        self.present(alert, animated: true)
                        
                    } else {
                        
                        
                        let alert = NewYorkAlertController(title: String(strSuccess).uppercased(), message: String(strSuccess2), style: .alert)
                        
                        let yes_logout = NewYorkButton(title: "re-send", style: .destructive) {
                            _ in
                            self.resend_email(str_user_id: "\(JSON["userId"]!)")
                        }
                        
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
    
    @objc func resend_email(str_user_id:String) {
        
        self.view.endEditing(true)
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        let params = resend_email_verification(action: "resend",
                                               userId: String(str_user_id))
        
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
                    strSuccess_2 = JSON["msg"]as Any as? String
                    
                    let alert = NewYorkAlertController(title: String(strSuccess).uppercased(), message: String(strSuccess_2), style: .alert)
                    
                    let cancel = NewYorkButton(title: "dismiss", style: .cancel)
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
