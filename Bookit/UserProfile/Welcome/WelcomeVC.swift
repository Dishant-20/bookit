//
//  WelcomeVC.swift
//  Bookit
//
//  Created by Ranjan on 18/12/21.
//

import UIKit

// MARK:- LOCATION -
import CoreLocation

import Alamofire

var selectedProfile:String = ""

class WelcomeVC: UIViewController , CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
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
            
       /* @IBOutlet weak var btnBack:UIButton! {
            didSet {
                btnBack.tintColor = NAVIGATION_BACK_COLOR
            }
        }*/
            
        @IBOutlet weak var lblNavigationTitle:UILabel! {
            didSet {
                lblNavigationTitle.text = "Welcome"
                lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
                lblNavigationTitle.backgroundColor = .clear
            }
        }
                    
    // ***************************************************************** // nav
    
    @IBOutlet weak var btnCustomer:UIButton!{
        didSet{
            btnCustomer.backgroundColor = NAVIGATION_COLOR
            btnCustomer.setTitle("Customer", for: .normal)
            btnCustomer.layer.cornerRadius = 27.5
            btnCustomer.clipsToBounds = true
            
            btnCustomer.addTarget(self, action: #selector(btnCustomerTapped), for: .touchUpInside)
        }
        
    }
    
    @IBOutlet weak var btnNightClubs:UIButton!{
        didSet{
            btnNightClubs.backgroundColor = BUTTON_DARK_APP_COLOR
            btnNightClubs.setTitle("Dayclub / Nightclub", for: .normal)
            btnNightClubs.layer.cornerRadius = 27.5
            btnNightClubs.clipsToBounds = true
            btnNightClubs.addTarget(self, action: #selector(btnNightClubsTapped), for: .touchUpInside)
        }
    }

    @IBOutlet weak var btn_login_as_a_guest:UIButton! {
        didSet {
            btn_login_as_a_guest.backgroundColor = .clear
            btn_login_as_a_guest.setTitle("Login as a guest", for: .normal)
            btn_login_as_a_guest.layer.cornerRadius = 8
            btn_login_as_a_guest.clipsToBounds = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = APP_BASIC_COLOR
        /*let defaults = UserDefaults.standard
        defaults.setValue(nil, forKey: "keyLoginFullData")
        defaults.setValue("", forKey: "keyLoginFullData")
        
        defaults.setValue(nil, forKey: "key_is_user_remembered")
        defaults.setValue("", forKey: "key_is_user_remembered")*/
        
        
        
        
        
        
        /*let token = "cm2fkAEOe064rH1Cjt79-S:APA91bGLrzFUZzEWv97_kxbndkDlAL83pPftV4Bxz6mpjQwffv-j60nq8fCJbP0wBGGyIU6hcRf0EEgRXKMEKF9hqkZ4_KOu7__Eg-wKpHf8Vw0huk8Sb60GctELvfVcQD3jK2SBbDca"
        
        let title = "dishant rajput"
        let body = "i am a boy"
        
        let sender = PushNotificationSender()
        sender.sendPushNotification(to: token, title: title, body: body)*/
        
        
        
        
        
        
        
        self.btn_login_as_a_guest.addTarget(self , action: #selector(login_as_a_guest_click_metho), for: .touchUpInside)
        
        self.get_current_location_permission()
        
        self.rememberMe()
        
    }
    
    @objc func rememberMe() {
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {

            print(person as Any)

            if (person["role"] as! String) == "Customer" {

                if "\(person["emailVerify"]!)" != "0" {
                 
                    if (person["address"] as! String) == "" {
                        
                        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "customer_complete_profile_id") as? customer_complete_profile
                        
                        settingsVCId!.str_edit_profile = "no"
                        
                        self.navigationController?.pushViewController(settingsVCId!, animated: true)
                        
                    } else {
                        let tab_bar = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "tab_bar_controller_id") as? tab_bar_controller
                        tab_bar?.selectedIndex = 0
                        self.navigationController?.pushViewController(tab_bar!, animated: false)
                    }
                    
                    
                } else {
                    
                    // account not verified
                    // push to login screen
                    
                    let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Your account is not verified. please verify your account."), style: .alert)
                    
                    let cancel = NewYorkButton(title: "dismiss", style: .cancel) {
                        _ in
                    }
                    alert.addButtons([cancel])
                    
                    self.present(alert, animated: true)
                    
                    let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
                    self.navigationController?.pushViewController(settingsVCId!, animated: true)
                    
                }
                
            }
            
            else if (person["role"] as! String) == "Club" {

                if "\(person["emailVerify"]!)" != "0" {
                    
                    if (person["openTime"] as! String) == "" {
                        
                        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddressVC") as? AddressVC
                        self.navigationController?.pushViewController(settingsVCId!, animated: true)
                        
                    } else {
                        
                        let tab_bar = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "tav_bar_controller_club_id") as? tav_bar_controller_club
                        tab_bar?.selectedIndex = 0
                        self.navigationController?.pushViewController(tab_bar!, animated: false)
                        
                    }
                    
                    
                } else {
                    
                    
                    // account not verified
                    // push to login screen
                    let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Your account is not verified. please verify your account."), style: .alert)
                    
                    let cancel = NewYorkButton(title: "dismiss", style: .cancel) {
                        _ in
                    }
                    alert.addButtons([cancel])
                    
                    self.present(alert, animated: true)
                    
                    let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
                    self.navigationController?.pushViewController(settingsVCId!, animated: true)
                    
                }
            
            }
            
            else {

//                                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NPHomeVC")
//                                    self.navigationController?.pushViewController(push, animated: true)

            }
        }
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
                
                /*let alertController = UIAlertController (title: "Location", message: "Your location is disable. To enable please click on Settings.", preferredStyle: .alert)
                
                let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                    
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    }
                }
                alertController.addAction(settingsAction)
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                alertController.addAction(cancelAction)
                
                present(alertController, animated: true, completion: nil)*/
                
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
    
    @objc func btnCustomerTapped() {
        
        let defaults = UserDefaults.standard
        defaults.set("Customer", forKey: "key_user_select_profile")
        
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "GetStartedNowVC") as? GetStartedNowVC
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
        selectedProfile = "customer"
    }
    
    @objc func btnNightClubsTapped() {
        
        let defaults = UserDefaults.standard
        defaults.set("Club", forKey: "key_user_select_profile")
        
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "GetStartedNowVC") as? GetStartedNowVC
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
        
        /*let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddressVC") as? AddressVC
        self.navigationController?.pushViewController(settingsVCId!, animated: false)*/
        
        selectedProfile = "nightclub"
        
    }
    
    @objc func login_as_a_guest_click_metho() {
        
        let defaults = UserDefaults.standard
        defaults.set("login_as_a_guest", forKey: "key_guest_login_as_a_guest")
        
        UserDefaults.standard.set("", forKey: "keyLoginFullData")
        UserDefaults.standard.set(nil, forKey: "keyLoginFullData")
        
        UserDefaults.standard.set("", forKey: "keySetToBackOrMenu")
        UserDefaults.standard.set(nil, forKey: "keySetToBackOrMenu")
        
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NPHomeVC") as? NPHomeVC
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
        
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
