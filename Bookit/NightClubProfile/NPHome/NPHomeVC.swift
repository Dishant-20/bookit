//
//  NPHomeVC.swift
//  Bookit
//
//  Created by Ranjan on 22/12/21.
//

import UIKit
import Alamofire
import SDWebImage
import SPConfetti
import MapKit

// MARK:- LOCATION -
import CoreLocation
import PassKit

class NPHomeVC: UIViewController , CLLocationManagerDelegate , UITextFieldDelegate {
     
    @IBOutlet weak var shoePickerView: UIPickerView!
        @IBOutlet weak var priceLabel: UILabel!
    
    let locationManager = CLLocationManager()
    
    var arr_mut_dashboard_Data:NSMutableArray! = []
    
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var stateListArray:NSMutableArray = []
    var countryListArray:NSMutableArray = []
    
    // MARK:- SAVE LOCATION STRING -
    var strSaveLatitude:String! = ""
    var strSaveLongitude:String! = ""
    
    var strSaveCountryName:String!
    var strSaveLocalAddress:String!
    var strSaveLocality:String!
    var strSaveLocalAddressMini:String!
    var strSaveStateName:String!
    var strSaveZipcodeName:String!
    
    // ***************************************************************** // nav
    
    var strSaveSelectedCountryId:String! = "0"
    
    let regularFont = UIFont.systemFont(ofSize: 16)
    let boldFont = UIFont.boldSystemFont(ofSize: 16)
    
    var str_roll:String! = "0"
    
    var refresh_time:String! = "0"
    
    var myStr = ""
    var myStr2 = ""
    var countryId = ""
    
    var stateId = ""
    
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
            btnBack.isHidden = true
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "Home"
            lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
            lblNavigationTitle.backgroundColor = .clear
        }
    }
    
    // ***************************************************************** // nav
    
    @IBOutlet weak var lbl_pw:UILabel! {
        didSet {
            lbl_pw.textColor = .white
        }
    }
    
    @IBOutlet weak var viwTop:UIView!{
        didSet {
            viwTop.backgroundColor = NAVIGATION_COLOR
        }
    }
    
    @IBOutlet weak var searchBar:UISearchBar!{
        didSet {
            
            searchBar.layer.cornerRadius = 8.0
            searchBar.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var tablView:UITableView!{
        didSet {
            // tablView.delegate = self
            // tablView.dataSource = self
            tablView.backgroundColor =  .clear//APP_BASIC_COLOR
            tablView.isHidden = true
        }
    }
    
    @IBOutlet weak var txt_Search:UITextField! {
        didSet {
            txt_Search.backgroundColor = .white
            txt_Search.placeholder = "club , city , country , state name..."
        }
    }
    
    
    
    
    @IBOutlet weak var btn_search:UIButton! {
        didSet {
            btn_search.tintColor = .white
        }
    }
    
    @IBOutlet weak var btn_reset:UIButton! {
        didSet {
            btn_reset.tintColor = .white
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lbl_pw.isHidden = false
        
        self.txt_Search.delegate = self
        
        
        self.btn_search.addTarget(self, action: #selector(search_click_method), for: .touchUpInside)
        self.btn_reset.addTarget(self, action: #selector(reset_click_method), for: .touchUpInside)
        
        
        
        // self.btn_country.addTarget(self, action: #selector(country_webservice), for: .touchUpInside)
        // self.btn_state.addTarget(self, action: #selector(validation_before_state), for: .touchUpInside)
        
        
        
        
        
        // Available `.arc`, `.star`, `.heart`, `.circle`, `.triangle` and `.polygon`.
        // SPConfetti.startAnimating(.centerWidthToUp, particles: [.heart])
        
        /*let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: cordinate, addressDictionary: nil))
         mapItem.name = "test"
         mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])*/
        
        
        // UIApplication.shared.open(URL(string: "http://maps.google.com/maps?q=loc:\("28.99"),\("77.14")&zoom=14&views=traffic&q=\("30.44"),\("21.00")")!, options: [:], completionHandler: nil)
        
        // self.openMapButtonAction()
        
        self.view.backgroundColor = APP_BASIC_COLOR // cell_bg_color//APP_BASIC_COLOR
        self.navigationController?.isNavigationBarHidden = true
        self.tablView.separatorColor = .clear
        // self.sideBarMenuClick()
        
        // self.country_webservice()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.refresh_time = "0"
        
        self.txt_Search.text    = ""
        // self.txt_country.text   = ""
        // self.txt_state.text     = ""
        
        self.customer_dashboard_wb(str_loader_text: "yes")
        
        // self.get_current_location_permission()
        
        if self.traitCollection.userInterfaceStyle == .dark {
            
            txt_Search.attributedPlaceholder = NSAttributedString(
                string: "club , city , country , state name...",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
            )
            
            
            
            
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
                self.strSaveLatitude = ""
                self.strSaveLongitude = ""
                
                self.arr_mut_dashboard_Data.removeAllObjects()
                self.customer_dashboard_wb(str_loader_text: "yes")
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
                
                /*self.arr_mut_dashboard_Data.removeAllObjects()
                 self.customer_dashboard_wb(str_loader_text: "yes")*/
                
                /*if self.refresh_time == "0" {
                 self.refresh_time = "1"
                 print("dishu")
                 self.arr_mut_dashboard_Data.removeAllObjects()
                 self.customer_dashboard_wb(str_loader_text: "yes")
                 
                 }*/
                
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
            
            self.arr_mut_dashboard_Data.removeAllObjects()
            if self.refresh_time == "0" {
                self.refresh_time = "1"
                print("dishu")
                self.arr_mut_dashboard_Data.removeAllObjects()
                self.customer_dashboard_wb(str_loader_text: "yes")
                
            }
            
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        self.search_click_method()
        
        return true
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
    
    @objc func search_click_method() {
        
        self.arr_mut_dashboard_Data.removeAllObjects()
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            print(person as Any)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            self.view.endEditing(true)
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
            
            let params = customer_dashboard(action: "clublist",
                                            userId:String(myString),
                                            keyword:String(self.txt_Search.text!),
                                            latitude:String(self.strSaveLatitude),
                                            longitude:String(self.strSaveLongitude),
                                            countryId:String(countryId),
                                            stateId: String(stateId))
            
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
                        
                        var ar : NSArray!
                        ar = (JSON["data"] as! Array<Any>) as NSArray
                        
                        if ar.count == 0 {
                            
                            self.lbl_pw.isHidden = false
                            self.lbl_pw.textAlignment = .center
                            self.lbl_pw.numberOfLines = 0
                            self.lbl_pw.text = "No Day/Night Club Register in this area. Please Try Something else."
                            self.tablView.isHidden = true
                            
                        } else {
                            
                            self.arr_mut_dashboard_Data.addObjects(from: ar as! [Any])
                            
                            self.lbl_pw.isHidden = true
                            
                            self.tablView.isHidden = false
                            self.tablView.delegate = self
                            self.tablView.dataSource = self
                            self.tablView.reloadData()
                            
                        }
                        
                        
                    } else {
                        print("no")
                        //  ERProgressHud.sharedInstance.hide()
                        
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
        } else {
            
            // search as a guest
            self.club_list_search_with_guest_login(str_keyword: String(self.txt_Search.text!))
        }
    }
    
    
    
    
    @objc func customer_dashboard_wb(str_loader_text:String) {
        
        self.arr_mut_dashboard_Data.removeAllObjects()
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            print(person as Any)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            self.view.endEditing(true)
            
            if str_loader_text == "yes" {
                ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
            }
            
            
            let params = customer_dashboard(action: "clublist",
                                            userId:String(myString),
                                            keyword:String(""),
                                            latitude:String(self.strSaveLatitude),
                                            longitude:String(self.strSaveLongitude),
                                            countryId: "",
                                            stateId: "")
            
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
                        
                        var ar : NSArray!
                        ar = (JSON["data"] as! Array<Any>) as NSArray
                        
                        if ar.count == 0 {
                            
                            self.lbl_pw.isHidden = false
                            
                        } else {
                            
                            self.arr_mut_dashboard_Data.addObjects(from: ar as! [Any])
                            
                            self.lbl_pw.isHidden = true
                            
                            self.tablView.isHidden = false
                            self.tablView.delegate = self
                            self.tablView.dataSource = self
                            self.tablView.reloadData()
                            
                        }
                        
                    } else {
                        print("no")
                        //  ERProgressHud.sharedInstance.hide()
                        
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
        } else {
            self.club_list_with_guest_login()
        }
    }
    
    @objc func club_list_with_guest_login() {
        
        self.arr_mut_dashboard_Data.removeAllObjects()
        
        self.view.endEditing(true)
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        let params = customer_dashboard(action: "clublist",
                                        userId:String(""),
                                        keyword:String(""),
                                        latitude:String(self.strSaveLatitude),
                                        longitude:String(self.strSaveLongitude),
                                        countryId: "",
                                        stateId: "")
        
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
                    
                    var ar : NSArray!
                    ar = (JSON["data"] as! Array<Any>) as NSArray
                    
                    if ar.count == 0 {
                        
                        self.lbl_pw.isHidden = false
                        
                    } else {
                        
                        self.arr_mut_dashboard_Data.addObjects(from: ar as! [Any])
                        
                        self.lbl_pw.isHidden = true
                        
                        self.tablView.isHidden = false
                        self.tablView.delegate = self
                        self.tablView.dataSource = self
                        self.tablView.reloadData()
                        
                    }
                    
                } else {
                    print("no")
                    //  ERProgressHud.sharedInstance.hide()
                    
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
    
    @objc func club_list_search_with_guest_login(str_keyword:String) {
        
        self.arr_mut_dashboard_Data.removeAllObjects()
        
        self.view.endEditing(true)
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        let params = customer_dashboard(action: "clublist",
                                        userId:String(""),
                                        keyword:String(str_keyword),
                                        latitude:String(self.strSaveLatitude),
                                        longitude:String(self.strSaveLongitude),
                                        countryId:String(countryId),
                                        stateId: String(stateId))
        
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
                    
                    var ar : NSArray!
                    ar = (JSON["data"] as! Array<Any>) as NSArray
                    
                    if ar.count == 0 {
                        
                        self.lbl_pw.isHidden = false
                        self.lbl_pw.text = "No data found. Click refresh to load all nearby clubs."
                        self.lbl_pw.numberOfLines = 0
                        self.tablView.isHidden = true
                        
                    } else {
                        
                        self.arr_mut_dashboard_Data.addObjects(from: ar as! [Any])
                        
                        self.lbl_pw.isHidden = true
                        
                        self.tablView.isHidden = false
                        self.tablView.delegate = self
                        self.tablView.dataSource = self
                        self.tablView.reloadData()
                        
                    }
                    
                } else {
                    print("no")
                    //  ERProgressHud.sharedInstance.hide()
                    
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
    
    func openMapButtonAction() {
        
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.open(NSURL(string:
                                                "comgooglemaps://?saddr=&daddr=\(Float(28.11)),\(Float(77.1))&directionsmode=driving")! as URL)
            
        } else {
            // if GoogleMap App is not installed
            UIApplication.shared.open(NSURL(string:"https://maps.google.com/?q=@\(Float(30.99)),\(Float(78))")! as URL)
        }
        
        
    }
    
    
    @objc func reset_click_method() {
        
        self.txt_Search.text = ""
        // self.txt_country.text = ""
        // self.txt_state.text = ""
        
         self.customer_dashboard_wb(str_loader_text: "yes")
        
        
    }
    
    
    @objc func country_webservice() {
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please Wait...")
        
        self.countryListArray.removeAllObjects()
        
        let params = countryListWeb(action: "countrylist")
        
        
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
                strSuccess = JSON["status"]as Any as? String
                
                if strSuccess == String("success") {
                    
                    print("yes")
                    ERProgressHud.sharedInstance.hide()
                    var ar : NSArray!
                    ar = (JSON["data"] as! Array<Any>) as NSArray
                    self.countryListArray.addObjects(from: ar as! [Any])
                    
                    
                    
                } else {
                    print("no")
                    ERProgressHud.sharedInstance.hide()
                    
                }
            case let .failure(error):
                
                print(error)
                ERProgressHud.sharedInstance.hide()
            }
            
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}


//MARK:- TABLE VIEW -
extension NPHomeVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_mut_dashboard_Data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NPHomeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NPHomeTableCell") as! NPHomeTableViewCell
        
        cell.backgroundColor = .clear //APP_BASIC_COLOR
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        let item = self.arr_mut_dashboard_Data[indexPath.row] as? [String:Any]
        print(item as Any)
        
        /*
         ["Userimage": https://demo4.evirtualservices.net/bookit/img/uploads/users/16400815972.jpg, "openTime": 10:30 AM, "state": Delhi, "fullName": Raushan Kumar, "closeTime": 11:30 PM, "contactNumber": 7428171872, "userId": 2, "banner": , "email": raushan@mailinator.com]
         */
        
        // cell.btnDistance.setTitle("2 miles", for: .normal)
        
        // AVGRating
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            print(person["role"] as! String)
            
            if "\(item!["AVGRating"]!)" == "" {
                
                cell.btnStarOne.setImage(UIImage(systemName: "star"), for: .normal)
                cell.btnStarTwo.setImage(UIImage(systemName: "star"), for: .normal)
                cell.btnStarThree.setImage(UIImage(systemName: "star"), for: .normal)
                cell.btnStarFour.setImage(UIImage(systemName: "star"), for: .normal)
                cell.btnStarFive.setImage(UIImage(systemName: "star"), for: .normal)
                
            } else if "\(item!["AVGRating"]!)" == "1" {
                
                cell.btnStarOne.setImage(UIImage(systemName: "star.fill"), for: .normal)
                cell.btnStarTwo.setImage(UIImage(systemName: "star"), for: .normal)
                cell.btnStarThree.setImage(UIImage(systemName: "star"), for: .normal)
                cell.btnStarFour.setImage(UIImage(systemName: "star"), for: .normal)
                cell.btnStarFive.setImage(UIImage(systemName: "star"), for: .normal)
                
            } else if "\(item!["AVGRating"]!)" == "2" {
                
                cell.btnStarOne.setImage(UIImage(systemName: "star.fill"), for: .normal)
                cell.btnStarTwo.setImage(UIImage(systemName: "star.fill"), for: .normal)
                cell.btnStarThree.setImage(UIImage(systemName: "star"), for: .normal)
                cell.btnStarFour.setImage(UIImage(systemName: "star"), for: .normal)
                cell.btnStarFive.setImage(UIImage(systemName: "star"), for: .normal)
                
            } else if "\(item!["AVGRating"]!)" == "3" {
                
                cell.btnStarOne.setImage(UIImage(systemName: "star.fill"), for: .normal)
                cell.btnStarTwo.setImage(UIImage(systemName: "star.fill"), for: .normal)
                cell.btnStarThree.setImage(UIImage(systemName: "star.fill"), for: .normal)
                cell.btnStarFour.setImage(UIImage(systemName: "star"), for: .normal)
                cell.btnStarFive.setImage(UIImage(systemName: "star"), for: .normal)
                
            } else if "\(item!["AVGRating"]!)" == "4" {
                
                cell.btnStarOne.setImage(UIImage(systemName: "star.fill"), for: .normal)
                cell.btnStarTwo.setImage(UIImage(systemName: "star.fill"), for: .normal)
                cell.btnStarThree.setImage(UIImage(systemName: "star.fill"), for: .normal)
                cell.btnStarFour.setImage(UIImage(systemName: "star.fill"), for: .normal)
                cell.btnStarFive.setImage(UIImage(systemName: "star"), for: .normal)
                
            } else {
                
                cell.btnStarOne.setImage(UIImage(systemName: "star.fill"), for: .normal)
                cell.btnStarTwo.setImage(UIImage(systemName: "star.fill"), for: .normal)
                cell.btnStarThree.setImage(UIImage(systemName: "star.fill"), for: .normal)
                cell.btnStarFour.setImage(UIImage(systemName: "star.fill"), for: .normal)
                cell.btnStarFive.setImage(UIImage(systemName: "star.fill"), for: .normal)
                
            }
            
            cell.lblName.text = (item!["fullName"] as! String)
            cell.btnPhone.setTitle((item!["contactNumber"] as! String), for: .normal)
            cell.btnPhone.isHidden = true
            
            cell.imgBG.image = UIImage(named: "bar")
            
            cell.imgBG.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
            cell.imgBG.sd_setImage(with: URL(string: (item!["banner"] as! String)), placeholderImage: UIImage(named: "bar"))
            
            
            /*let my_location_latitude    = Double(self.strSaveLatitude)
             let my_location_longitude   = Double(self.strSaveLongitude)
             
             let club_location_latitude    = Double(item!["latitude"] as! String)
             let club_location_longitude   = Double(item!["longitude"] as! String)
             
             let coordinate₀ = CLLocation(latitude: my_location_latitude!, longitude: my_location_longitude!)
             let coordinate₁ = CLLocation(latitude: club_location_latitude!, longitude: club_location_longitude!)
             
             let distanceInMeters = coordinate₀.distance(from: coordinate₁)
             print(distanceInMeters as Any)
             
             // remove decimal
             let distanceFloat: Double = (distanceInMeters as Any as! Double)
             // print(distanceFloat as Any)
             // self.lblDistance.text = (String(format: "Distance : %.0f Miles away", distanceFloat/1609.344))
             // self.lblMessage.text = "Rider is "+(String(format: " : %.0f Miles away", distanceFloat/1609.344))+" from you."
             
             // print(distanceFloat/1609.344)
             // print(String(format: "Distance : %.0f Miles away", distanceFloat/1609.344))
             
             let s:String = String(format: "%.0f",distanceFloat/1609.344)
             // print(s as Any)
             
             cell.btnDistance.setTitle(String(s)+" miles", for: .normal)*/
            
            cell.btnDistance.setTitle(String("test ")+" miles", for: .normal)
            
            // cell.btnSignUp.addTarget(self, action: #selector(btnSignUpTapped), for: .touchUpInside)
            
            if (item!["youliked"] as! String) == "No" {
                
                cell.btnLike.setImage(UIImage(systemName: "heart"), for: .normal)
                cell.btnLike.tintColor = .systemGray
                
            } else {
                
                cell.btnLike.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                cell.btnLike.tintColor = .systemRed
                
            }
            
            cell.btnLocation.setTitle((item!["address"] as! String), for: .normal)
            
            cell.btnLike.tag = indexPath.row
            cell.btnLike.addTarget(self, action: #selector(like_club_click_method), for: .touchUpInside)
            
            cell.btnShare.tag = indexPath.row
            cell.btnShare.addTarget(self, action: #selector(share_club_Data_click_method), for: .touchUpInside)
            
        } else {
            
            // guest user
            cell.btnLike.isHidden = true
            cell.btnShare.isHidden = true
            
            cell.lblName.text = (item!["fullName"] as! String)
            cell.btnPhone.setTitle((item!["contactNumber"] as! String), for: .normal)
            cell.btnPhone.isHidden = true
            
            cell.btnLocation.setTitle((item!["address"] as! String), for: .normal)
            
            cell.imgBG.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
            cell.imgBG.sd_setImage(with: URL(string: (item!["banner"] as! String)), placeholderImage: UIImage(named: "bar"))
            
        }
        
        return cell
    }
    
    @objc func share_club_Data_click_method (_ sender:UIButton) {
        
        let btn:UIButton = sender
        
        let item = self.arr_mut_dashboard_Data[btn.tag] as? [String:Any]
        
        let firstActivityItem = "Club Name : "+(item!["fullName"] as! String)+"\nClub Address : "+(item!["address"] as! String)
        
        let text = firstActivityItem
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
        
        
        
        /*// Setting description
         let firstActivityItem = "Club Name : "+(item!["fullName"] as! String)+"\nClub Address : "+(item!["address"] as! String)
         
         // Setting url
         let secondActivityItem : NSURL = NSURL(string: (item!["Userimage"] as! String))!
         
         
         let url = URL(string:(item!["Userimage"] as! String))
         
         if let data = try? Data(contentsOf: url!)
         {
         let image_2: UIImage = UIImage(data: data)!
         
         // If you want to use an image
         let image : UIImage = image_2
         let activityViewController : UIActivityViewController = UIActivityViewController(
         activityItems: [firstActivityItem, secondActivityItem, image], applicationActivities: nil)
         
         // This lines is for the popover you need to show in iPad
         activityViewController.popoverPresentationController?.sourceView = sender
         
         // This line remove the arrow of the popover to show in iPad
         activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
         activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
         
         // Pre-configuring activity items
         activityViewController.activityItemsConfiguration = [
         UIActivity.ActivityType.message
         ] as? UIActivityItemsConfigurationReading
         
         // Anything you want to exclude
         activityViewController.excludedActivityTypes = [
         UIActivity.ActivityType.postToWeibo,
         UIActivity.ActivityType.print,
         UIActivity.ActivityType.assignToContact,
         UIActivity.ActivityType.saveToCameraRoll,
         UIActivity.ActivityType.addToReadingList,
         UIActivity.ActivityType.postToFlickr,
         UIActivity.ActivityType.postToVimeo,
         UIActivity.ActivityType.postToTencentWeibo,
         UIActivity.ActivityType.postToFacebook
         ]
         
         activityViewController.isModalInPresentation = true
         self.present(activityViewController, animated: true, completion: nil)
         
         }*/
        
        
    }
    
    @objc func like_club_click_method(_ sender:UIButton) {
        
        let btn:UIButton = sender
        
        let item = self.arr_mut_dashboard_Data[btn.tag] as? [String:Any]
        
        let like_status:String!
        
        if (item!["youliked"] as! String) == "No" {
            
            like_status = "1"
            
        } else {
            
            like_status = "0"
            
        }
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        self.arr_mut_dashboard_Data.removeAllObjects()
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            print(person as Any)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            // let x_2 : Int = item!["userId"] as! Int
            let myString_2 = "\(item!["userId"]!)"
            
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
                        
                        // ERProgressHud.sharedInstance.hide()
                        
                        self.customer_dashboard_wb(str_loader_text: "no")
                        
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
    
    @objc func btnSignUpTapped() {
        
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddTableVC") as? AddTableVC
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = self.arr_mut_dashboard_Data[indexPath.row] as? [String:Any]
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NPClubDetailVC") as? NPClubDetailVC
        push!.dict_get_club_details = item! as NSDictionary
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    
}

extension NPHomeVC: UITableViewDelegate {
    
}


