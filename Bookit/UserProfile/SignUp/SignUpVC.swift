//
//  SignUpVC.swift
//  Bookit
//
//  Created by Ranjan on 18/12/21.
//

import UIKit
import Alamofire

// MARK:- LOCATION -
import CoreLocation

class SignUpVC: UIViewController , CLLocationManagerDelegate {
    
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
            lblNavigationTitle.text = "Register"
            lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
            lblNavigationTitle.backgroundColor = .clear
        }
    }
    
    // ***************************************************************** // nav
    
    @IBOutlet weak var tablView:UITableView!{
        didSet {
            tablView.delegate = self
            tablView.dataSource = self
            tablView.backgroundColor =  APP_BASIC_COLOR
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = APP_BASIC_COLOR
        self.navigationController?.isNavigationBarHidden = true
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        self.get_current_location_permission()
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
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
    
    // MARK:- GET CUSTOMER LOCATION -
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
    
    @objc func callBeforeRegister() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! SignUpTableViewCell
        
        
        if String(cell.txtName.text!) == "" {
            self.fieldShoulNotBeEmptyPopup(strTitle: "Name")
        } else if String(cell.txtEmailAddress.text!) == "" {
            self.fieldShoulNotBeEmptyPopup(strTitle: "Email")
        } else if String(cell.txtPassword.text!) == "" {
            self.fieldShoulNotBeEmptyPopup(strTitle: "Password")
        } else {
            self.registerCustomerWB()
        }
        
        
        
    }
    
    @objc func fieldShoulNotBeEmptyPopup(strTitle:String) {
        
        let alert = UIAlertController(title: "Alert", message: String(strTitle)+" Field should not be empty", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true)
        
    }
    
    @objc func registerCustomerWB() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! SignUpTableViewCell
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        
        if let i_am_role = UserDefaults.standard.string(forKey: "key_user_select_profile") {
            
            // let x : Int = person["userId"] as! Int
            // let myString = String(x)
            
            let defaults = UserDefaults.standard
            if let myString = defaults.string(forKey: "key_my_device_token") {
                myDeviceTokenIs = myString
                
            }
            else {
                myDeviceTokenIs = "111111111111111111111"
            }
            
            let params = CustomerRegister(action: "registration",
                                          banner:"",
                                          fullName: String(cell.txtName.text!),
                                          email: String(cell.txtEmailAddress.text!),
                                          password: String(cell.txtPassword.text!),
                                          contactNumber: String(cell.txtPhone.text!),
                                          address:"",
                                          device: "iOS",
                                          role: "\(i_am_role)",
                                          latitude: String(self.strSaveLatitude),
                                          longitude:String(self.strSaveLongitude),
                                          deviceToken:String(self.myDeviceTokenIs),
                                          countryId:"",
                                          image: "",
                                          state: "",
                                          openTime: "",
                                          closeTime: ""
            )
            
            
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
                        
                        var dict: Dictionary<AnyHashable, Any>
                        dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                        
                        let defaults = UserDefaults.standard
                        defaults.setValue(dict, forKey: "keyLoginFullData")
                        
                        if (dict["role"] as! String) == "Club" {
                            
                            if "\(dict["emailVerify"]!)" == "0" {
                                
                                print("xxxx ===> email verify <=== xxxx")
                                
                                var strSuccess2 : String!
                                strSuccess2 = JSON["msg"]as Any as? String
                                
                                let alert = NewYorkAlertController(title: "Success", message: String(strSuccess2), style: .alert)
                                
                                let cancel = NewYorkButton(title: "Ok", style: .cancel) {
                                    _ in
                                    self.backClickMethod()
                                }
                                alert.addButtons([cancel])
                                
                                self.present(alert, animated: true)
                                
                            } else {
                                
                                let alert = NewYorkAlertController(title: "Alert", message: String("Your account has been created successfully. Please complete your profile to access all features."), style: .alert)
                                
                                
                                let cancel = NewYorkButton(title: "ok", style: .cancel) {
                                    _ in
                                    
                                    let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddressVC") as? AddressVC
                                    self.navigationController?.pushViewController(settingsVCId!, animated: true)
                                    
                                }
                                
                                alert.addButtons([cancel])
                                
                                self.present(alert, animated: true)
                            }
                            
                        } else {
                            
                            // var strSuccess2 : String!
                            // strSuccess2 = JSON["msg"] as Any as? String
                            
                            if "\(dict["emailVerify"]!)" == "0" {
                                
                                print("xxxx ===> email verify <=== xxxx")
                                
                                var strSuccess2 : String!
                                strSuccess2 = JSON["msg"]as Any as? String
                                
                                let alert = NewYorkAlertController(title: "Success", message: String(strSuccess2), style: .alert)
                                
                                let cancel = NewYorkButton(title: "Ok", style: .cancel) {
                                    _ in
                                    self.backClickMethod()
                                }
                                alert.addButtons([cancel])
                                
                                self.present(alert, animated: true)
                                
                            } else {
                                
                                let alert = NewYorkAlertController(title: "Success", message: String(strSuccess2), style: .alert)
                                
                                alert.addImage(UIImage.gif(name: "success3"))
                                
                                let cancel = NewYorkButton(title: "Ok", style: .cancel) {
                                    _ in
                                    // self.backClickMethod()
                                    
                                    let tab_bar = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "tab_bar_controller_id") as? tab_bar_controller
                                    tab_bar?.selectedIndex = 0
                                    self.navigationController?.pushViewController(tab_bar!, animated: false)
                                    
                                }
                                alert.addButtons([cancel])
                                
                                self.present(alert, animated: true)
                                
                            }
                            
                            
                            
                        }
                        
                        
                        
                        /*var strSuccess2 : String!
                         strSuccess2 = JSON["msg"]as Any as? String
                         
                         let alert = UIAlertController(title: String(strSuccess).uppercased(), message: String(strSuccess2), preferredStyle: .alert)
                         
                         alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                         self.backClickMethod()
                         }))
                         
                         self.present(alert, animated: true)*/
                        
                    } else {
                        print("no")
                        ERProgressHud.sharedInstance.hide()
                        
                        var strSuccess2 : String!
                        strSuccess2 = JSON["msg"]as Any as? String
                        
                        let alert = UIAlertController(title: String(strSuccess).uppercased(), message: String(strSuccess2), preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        
                        self.present(alert, animated: true)
                        
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

//MARK:- TABLE VIEW -
extension SignUpVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SignUpTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SignUpTableCell") as! SignUpTableViewCell
        
        cell.backgroundColor = APP_BASIC_COLOR
      
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.btnSignUp.addTarget(self, action: #selector(callBeforeRegister), for: .touchUpInside)
        cell.btnDontHavAcount.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        return cell
    }

    
    @objc func btnSignUpTapped(){
        
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NPHomeVC") as? NPHomeVC
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1000
    }
    
    
}

extension SignUpVC: UITableViewDelegate {
    
}
