//
//  NPClubDetailVC.swift
//  Bookit
//
//  Created by Ranjan on 22/12/21.
//

import UIKit
import SDWebImage
import MapKit
import Alamofire

// MARK:- LOCATION -
import CoreLocation

class NPClubDetailVC: UIViewController, CLLocationManagerDelegate {
    
    var dict_get_club_details:NSDictionary!
    
    var myDeviceTokenIs:String!
    
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
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.tintColor = NAVIGATION_BACK_COLOR
            
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
                
                if (person["role"] as! String) == "Customer" {
                    
                    btnBack.isHidden = false
                    lblNavigationTitle.text = (self.dict_get_club_details!["fullName"] as! String)
                    lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
                    lblNavigationTitle.backgroundColor = .clear
                    
                } else if (person["role"] as! String) == "Club" {
                    
                    btnBack.isHidden = true
                    lblNavigationTitle.text = (person["fullName"] as! String)
                    lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
                    lblNavigationTitle.backgroundColor = .clear
                    
                } else {
                    // return 0
                }
                
            }
            
        }
        
        
        
        
    }
    
    // ***************************************************************** // nav
    
    @IBOutlet weak var tablView:UITableView! {
        didSet {
            
            tablView.backgroundColor = .clear
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = APP_BASIC_COLOR
        self.navigationController?.isNavigationBarHidden = true
        self.tablView.separatorColor = .clear
        
        // // self.sideBarMenuClick()
        
        // self.manage_profile()
        self.btnBack.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        // print(self.getDayNameBy(stringDate: "2022-06-12"))
        
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
             print(person as Any)
            
            if (person["deviceToken"] as! String) == "" {
                
                let defaults = UserDefaults.standard
                if let myString = defaults.string(forKey: "key_my_device_token") {
                    myDeviceTokenIs = myString
                    
                    self.register_token_for_club(str_device_token: self.myDeviceTokenIs)
                }
                else {
                    myDeviceTokenIs = "111111111111111111111"
                }
                
            }
            
            
        }
        
        // // edit_only_lat_long_wb
        
        self.get_current_location_permission()
    }
    
    func getDayNameBy(stringDate: String) -> String {
        
        let df  = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let date = df.date(from: stringDate)!
        df.dateFormat = "EEEE"
        return df.string(from: date)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tablView.delegate = self
        tablView.dataSource = self
        tablView.reloadData()
    }
    
    @objc func manage_profile() {
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
            
            if (person["role"] as! String) == "Club" {
                
                print(person as Any)
                
                self.btnBack.setImage(UIImage(systemName: "list.dash"), for: .normal)
                // self.sideBarMenuClick()
                
            } else {
                
                self.btnBack.setImage(UIImage(systemName: "arrow.left"), for: .normal)
                self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
                
            }
        }
    }
    
    @objc func backClickMethod() {
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
    
    @objc func check_stripe_registration() {
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        // self.arr_mut_dashboard_Data.removeAllObjects()
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            print(person as Any)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params = check_stripe_registraiton(action: "striperegistration",
                                                   userId: String(myString),
                                                   email: (person["email"] as! String))
            
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
                        
                        // self.customer_dashboard_wb()
                        
                        var dict: Dictionary<AnyHashable, Any>
                        dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                        
                        var strSuccess2 : String!
                        strSuccess2 = "\(dict["StripeStatus"]!)"
                        
                        if strSuccess2 == "0" {
                            
                            let alert = NewYorkAlertController(title: "Stripe account", message: String("You did not setup your account in stripe. Please setup your account."), style: .alert)
                            
                            let yes_logout = NewYorkButton(title: "yes, setup", style: .destructive) {
                                _ in
                                
                                if let url = URL(string: "\(dict["url"]!)") {
                                    UIApplication.shared.open(url)
                                }
                                
                            }

                            
                            let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                            alert.addButtons([cancel,yes_logout])
                            
                            self.present(alert, animated: true)
                            
                        }
                        
                        // self.dict_get_club_details = dict as NSDictionary
                        
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
                    print(error.localizedDescription)
                    ERProgressHud.sharedInstance.hide()
                    
                    // Utils.showAlert(alerttitle: SERVER_ISSUE_TITLE, alertmessage: SERVER_ISSUE_MESSAGE, ButtonTitle: "Ok", viewController: self)
                }
            }
        }
    }
    
    @objc func like_this_club() {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! NPClubDetailTableViewCell
        
        
        
        let like_status:String!
        
        print(self.dict_get_club_details as Any)
        
        if (self.dict_get_club_details!["youliked"] as! String) == "No" {
            
            like_status = "1"
            
            cell.btnLike.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            cell.btnLike.tintColor = .systemRed
            
        } else {
            
            like_status = "0"
            
            cell.btnLike.setImage(UIImage(systemName: "heart"), for: .normal)
            cell.btnLike.tintColor = .systemGray
            
        }
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        // self.arr_mut_dashboard_Data.removeAllObjects()
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            print(person as Any)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            // let x_2 : Int =  as! Int
            let myString_2 = "\(self.dict_get_club_details!["userId"]!)"
            
            let params = like_to_club(action: "addlike",
                                      userId: String(myString),
                                      clubId: String(myString_2),
                                      status: String(like_status))
            
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
                        
                        // self.customer_dashboard_wb()
                        
                        var dict: Dictionary<AnyHashable, Any>
                        dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                        
                        self.dict_get_club_details = dict as NSDictionary
                        
                        /*if (dict["youliked"] as! String) == "No" {
                         
                         cell.btnLike.setImage(UIImage(systemName: "heart"), for: .normal)
                         cell.btnLike.tintColor = .systemGray
                         
                         } else {
                         
                         cell.btnLike.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                         cell.btnLike.tintColor = .systemRed
                         
                         }*/
                        
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
        }
    }
    
    
    @objc func share_this_club() {
        // let indexPath = IndexPath.init(row: 0, section: 0)
        // let cell = self.tablView.cellForRow(at: indexPath) as! NPClubDetailTableViewCell
        
        
        
        let firstActivityItem = "Club Name : "+(self.dict_get_club_details!["fullName"] as! String)+"\nClub Address : "+(self.dict_get_club_details!["address"] as! String)
        
        let text = firstActivityItem
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.airDrop,
            UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    
    /*
     // Create UserDefaults
     let defaults = UserDefaults.standard
     if let myString = defaults.string(forKey: "deviceFirebaseToken") {
     myDeviceTokenIs = myString
     }
     else {
     myDeviceTokenIs = "111111111111111111111"
     }
     
     update_token_for_club
     
     */
    @objc func register_token_for_club(str_device_token:String) {
        
        self.view.endEditing(true)
        // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "checking availaibility...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // print(person as Any)
            
            // print((person["role"] as! String))
            
            
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params = update_token_for_club(action: "editprofile",
                                               userId: String(myString),
                                               deviceToken: String(str_device_token))
            
            
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
                        
                        
                    } else {
                        print("no")
                        // ERProgressHud.sharedInstance.hide()
                        
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
            
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
                
                if (person["latitude"] as! String) == "" {
                 
                    self.edit_only_lat_long_wb(str_lat: String(self.strSaveLatitude),
                                               str_long: String(self.strSaveLongitude))
                    
                }
            
            }
        }
    }
    
    @objc func edit_only_lat_long_wb(str_lat:String,str_long:String) {
        
        self.view.endEditing(true)
         ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "please wait...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
           
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params = edit_profile_only_lat_long(action: "editprofile",
                                                    userId: String(myString),
                                                    latitude: String(str_lat),
                                                    longitude: String(str_long))
            
            
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
                        
                        
                    } else {
                        print("no")
                        // ERProgressHud.sharedInstance.hide()
                        
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
extension NPClubDetailVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0 {
            
            let cell:NPClubDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NPClubDetailTableCell") as! NPClubDetailTableViewCell
            
            cell.backgroundColor = APP_BASIC_COLOR
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
                
                // print(person as Any)
                
                // print(self.dict_get_club_details as Any)
                
                if (person["role"] as! String) == "Customer" {
                    
                    cell.imgBG.image = UIImage(named: "bar")
                    
                    cell.btnDistance.setTitle("2 miles", for: .normal)
                    
                    cell.lblName.text = (self.dict_get_club_details!["fullName"] as! String)
                    cell.btnPhone.setTitle((self.dict_get_club_details!["contactNumber"] as! String), for: .normal)
                    cell.btnPhone.isHidden = true
                    
                    
                    cell.btnLocation.setTitle((self.dict_get_club_details!["address"] as! String), for: .normal)
                    
                    cell.imgBG.image = UIImage(named: "bar")
                    
                    cell.imgBG.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
                    cell.imgBG.sd_setImage(with: URL(string: (self.dict_get_club_details!["banner"] as! String)), placeholderImage: UIImage(named: "bar"))
                    
                    if (self.dict_get_club_details!["youliked"] as! String) == "No" {
                        
                        cell.btnLike.setImage(UIImage(systemName: "heart"), for: .normal)
                        cell.btnLike.tintColor = .systemGray
                        
                    } else {
                        
                        cell.btnLike.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                        cell.btnLike.tintColor = .systemRed
                        
                    }
                    
                    cell.btnShare.addTarget(self, action: #selector(share_this_club), for: .touchUpInside)
                    
                    cell.btnLike.addTarget(self, action: #selector(like_this_club), for: .touchUpInside)
                    
                    //  cell.lbl_about.text = (self.dict_get_club_details!["about"] as! String)
                    
                } else if (person["role"] as! String) == "Club" {
                    
                    //cell.imgBG.sd_setImage(with: URL(string: imgStr))
                    cell.lblName.text = (person["fullName"] as! String)
                    cell.btnPhone.setTitle((person["contactNumber"] as! String), for: .normal)
                    cell.btnPhone.isHidden = true
                    cell.btnLocation.setTitle((person["address"] as! String), for: .normal)
                    
                    cell.btnLike.isHidden = true
                    cell.btnShare.isHidden = true
                    
                    cell.imgBG.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
                    cell.imgBG.sd_setImage(with: URL(string: (person["banner"] as! String)), placeholderImage: UIImage(named: "1024"))
                    
                    
                    // cell.lbl_about.text = (person["about"] as! String)
                    
                } else {
                    // return 0
                }
                
            } else {
                
                // guest
                cell.lblName.text = (self.dict_get_club_details!["fullName"] as! String)
                cell.btnPhone.setTitle((self.dict_get_club_details!["contactNumber"] as! String), for: .normal)
                cell.btnPhone.isHidden = true
                
                cell.btnLocation.setTitle((self.dict_get_club_details!["address"] as! String), for: .normal)
                
                // cell.lbl_about.text = (self.dict_get_club_details!["about"] as! String)
                
                cell.btnLike.isHidden = true
                cell.btnShare.isHidden = true
                
                cell.imgBG.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
                cell.imgBG.sd_setImage(with: URL(string: (self.dict_get_club_details!["banner"] as! String)), placeholderImage: UIImage(named: "logo"))
                
            }
            
            
            
            
            return cell
            
        } else if indexPath.row == 2 {
            
            let cell:NPClubDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell_three") as! NPClubDetailTableViewCell
            
            cell.backgroundColor = APP_BASIC_COLOR
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.btnPhotos.addTarget(self, action: #selector(btnPhotosTapped), for: .touchUpInside)
            cell.btnTables.addTarget(self, action: #selector(btnTablesTapped), for: .touchUpInside)
            cell.btnReviews.addTarget(self, action: #selector(btnReviewsTapped), for: .touchUpInside)
            cell.btnDirections.addTarget(self, action: #selector(btnDirectionsTapped), for: .touchUpInside)
            cell.btn_events.addTarget(self, action: #selector(event_click_method), for: .touchUpInside)
            
            return cell
            
        } else {
            
            let cell:NPClubDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell_two") as! NPClubDetailTableViewCell
            
            cell.backgroundColor = APP_BASIC_COLOR
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
                if (person["role"] as! String) == "Club" {
                    
                    cell.lbl_about.text = (person["about"] as! String)
                    
                } else {
                    
                    // print(self.dict_get_club_details as Any)
                    
                    cell.lbl_about.text = (self.dict_get_club_details["about"] as! String)
                    
                }
                
            } else {
                
                // guest
                cell.lbl_about.text = (self.dict_get_club_details!["about"] as! String)
            }
            
            return cell
        }
        
        
    }
    
    @objc func btnPhotosTapped() {
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
            
            if (person["role"] as! String) == "Club" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ClubDetailsPhotos") as? ClubDetailsPhotos
                self.navigationController?.pushViewController(push!, animated: true)
                
                
            } else {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ClubDetailsPhotos") as? ClubDetailsPhotos
                push!.dict_get_table_Details = self.dict_get_club_details
                self.navigationController?.pushViewController(push!, animated: true)
                
                
            }
            
        } else {
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ClubDetailsPhotos") as? ClubDetailsPhotos
            push!.dict_get_table_Details = self.dict_get_club_details
            self.navigationController?.pushViewController(push!, animated: true)
            
        }
        
    }
    
    @objc func btnTablesTapped() {
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
            
            if (person["role"] as! String) == "Club" {
                
                // let x : Int = person["userId"] as! Int
                // let myString = String(x)
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NPClubTableDetailVC") as? NPClubTableDetailVC
                
                // push!.club_Details = myString
                
                let item :NSDictionary = person as NSDictionary
                
                push!.club_Details = item
                
                self.navigationController?.pushViewController(push!, animated: true)
                
            } else {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NPClubTableDetailVC") as? NPClubTableDetailVC
                
                push!.club_Details = self.dict_get_club_details
                
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
        } else {
            
            // table click as a guest
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NPClubTableDetailVC") as? NPClubTableDetailVC
            
            push!.club_Details = self.dict_get_club_details
            
            self.navigationController?.pushViewController(push!, animated: true)
            
        }
        
        
    }
    
    @objc func btnReviewsTapped() {
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
            
            if (person["role"] as! String) == "Club" {
                
                let x : Int = person["userId"] as! Int
                let myString = String(x)
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NPClubReviewVC") as? NPClubReviewVC
                push!.get_club_id = myString
                self.navigationController?.pushViewController(push!, animated: true)
                
            } else {
                
                // let x : Int = dict_get_club_details["userId"] as! Int
                let myString = "\(self.dict_get_club_details["userId"]!)"
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NPClubReviewVC") as? NPClubReviewVC
                push!.get_club_id = myString
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
        } else {
            
            let myString = "\(self.dict_get_club_details["userId"]!)"
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NPClubReviewVC") as? NPClubReviewVC
            push!.get_club_id = myString
            self.navigationController?.pushViewController(push!, animated: true)
            
        }
        
        
        
    }
    
    @objc func btnDirectionsTapped() {
        
        /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NPClubDirectionVC") as? NPClubDirectionVC
         
         push!.dict_get_direction_details = self.dict_get_club_details
         
         self.navigationController?.pushViewController(push!, animated: true)*/
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            if (person["role"] as! String) == "Customer" {
                
                if (self.dict_get_club_details["latitude"] as! String) == "" {
                    
                } else {
                    
                    if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
                        UIApplication.shared.open(NSURL(string:
                                                            "comgooglemaps://?saddr=&daddr=\(self.dict_get_club_details["latitude"] as! String),\(self.dict_get_club_details["longitude"] as! String)&directionsmode=driving")! as URL)
                        
                    } else {
                        
                        NSLog("Can't use comgooglemaps://")
                        
                        let alert = UIAlertController(title: String("Error"), message: String("Either Google Maps is not installed in your Device or your Device does not support Google Maps"), preferredStyle: .alert)
                        
                        
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    
                }
                
            } else {
                
                if (person["latitude"] as! String) == "" {
                    
                } else {
                    
                    print(self.dict_get_club_details as Any)
                    
                    if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
                        UIApplication.shared.open(NSURL(string:
                                                            "comgooglemaps://?saddr=&daddr=\(person["latitude"] as! String),\(person["longitude"] as! String)&directionsmode=driving")! as URL)
                        
                    } else {
                        
                        NSLog("Can't use comgooglemaps://")
                        
                        let alert = UIAlertController(title: String("Error"), message: String("Either Google Maps is not installed in your Device or your Device does not support Google Maps"), preferredStyle: .alert)
                        
                        
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    
                }
                
                
            }
        } else {
            
            // guest
            if (self.dict_get_club_details["latitude"] as! String) == "" {
                
            } else {
                
                if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
                    UIApplication.shared.open(NSURL(string:
                                                        "comgooglemaps://?saddr=&daddr=\(self.dict_get_club_details["latitude"] as! String),\(self.dict_get_club_details["longitude"] as! String)&directionsmode=driving")! as URL)
                    
                } else {
                    
                    NSLog("Can't use comgooglemaps://")
                    
                    let alert = UIAlertController(title: String("Error"), message: String("Either Google Maps is not installed in your Device or your Device does not support Google Maps"), preferredStyle: .alert)
                    
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
            }
            
        }
        
        
        
        
        
    }
    
    @objc func event_click_method() {
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
            
            if (person["role"] as! String) == "Club" {
                
                // club
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BookingVC") as? BookingVC
                push!.str_from_club_for_event = "yes"
                self.navigationController?.pushViewController(push!, animated: true)
                
            } else {
                
                // customer
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "event_list_id") as? event_list
                
                // print(dict_get_club_details as Any)
                push!.str_club_id = "\(self.dict_get_club_details["userId"]!)"
                
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            
        } else {
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "event_list_id") as? event_list
            
            // print(dict_get_club_details as Any)
            push!.str_club_id = "\(self.dict_get_club_details["userId"]!)"
            
            self.navigationController?.pushViewController(push!, animated: true)
            
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 500
        } else if indexPath.row == 2 {
            return 408
        } else {
            
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
                if (person["role"] as! String) == "Club" {
                    
                    if (person["about"] as! String) == "" {
                        return 0
                    } else {
                        return UITableView.automaticDimension
                    }
                    
                } else {
                    
                    if (self.dict_get_club_details!["about"] as! String) == "" {
                        return 0
                    } else {
                        return UITableView.automaticDimension
                    }
                    
                }
            } else {
                
                if (self.dict_get_club_details!["about"] as! String) == "" {
                    return 0
                } else {
                    return UITableView.automaticDimension
                }
                
            }
            
        }
        
    }
    
    
}

extension NPClubDetailVC: UITableViewDelegate {
    
}
