//
//  AddressVC.swift
//  Bookit
//
//  Created by Ranjan on 21/12/21.
//

import UIKit
import Alamofire
import SDWebImage

// MARK:- LOCATION -
import CoreLocation

import QCropper

// import ybte
class AddressVC: UIViewController , CLLocationManagerDelegate , UINavigationControllerDelegate, UIImagePickerControllerDelegate , CropperViewControllerDelegate {
    
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
    
    var str_status_upload_logo:String! = "0"
    var str_status_upload_banner:String! = "0"
    
    var img_data_logo : Data!
    var img_Str_logo : String!
    
    var img_data_banner : Data!
    var img_Str_banner : String!
    
    let regularFont = UIFont.systemFont(ofSize: 16)
    let boldFont = UIFont.boldSystemFont(ofSize: 16)
    
    var strSaveSelectedCountryId:String! = "0"
    // var strSaveSelectedCountryId:String! = "0"
    
    var stateListArray:NSMutableArray = []
    var countryListArray:NSMutableArray = []
    
    var myStr = ""
    var myStr2 = ""
    var countryId = ""
    
    var stateId = ""
    
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
            btnBack.isHidden = false
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "Complete Profile"
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
        /*NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)*/
        
        self.btnBack.addTarget(self, action: #selector(back_click_methodd), for: .touchUpInside)
        self.get_current_location_permission()
        
        self.countryListWebSer()
        
    }
    
    @objc func back_click_methodd() {
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
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnSaveTapped(){
        
        registerClubWB()
        
    }
    
    @objc func registerClubWB() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! AddressTableViewCell
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        
        // if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
        
        // let x : Int = person["userId"] as! Int
        // let myString = String(x)
        
        let params = ClubRegister(action: "registration",
                                  banner:"",
                                  fullName: String(clubName),
                                  email: String(clubEmail),
                                  password: String(clubPassword),
                                  contactNumber: String(clubPhone),
                                  address:String(cell.txtAddress.text!),
                                  device: "iOS",
                                  role: "Club",
                                  latitude: String(self.strSaveLatitude),
                                  longitude:String(self.strSaveLongitude),
                                  deviceToken:"",
                                  countryId:"",
                                  image: "",
                                  state: String(cell.txtState.text!),
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
                    
                    let alert = UIAlertController(title: String(strSuccess).uppercased(), message: String(strSuccess2), preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                        self.backClickMethod()
                    }))
                    
                    self.present(alert, animated: true)
                    
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
        // }
    }
    
    @objc func cellTappedMethod1(_ sender:AnyObject) {
        print("you tap image number: \(sender.view.tag)")
        
        let str_title:String!
        
        if "\(sender.view.tag)" == "100" {
            
            str_title = "Upload Club's logo"
            self.str_status_upload_logo = "1"
            
            let actionSheet = NewYorkAlertController(title: str_title, message: nil, style: .actionSheet)
            
            actionSheet.addImage(UIImage(named: "camera"))
            
            let cameraa = NewYorkButton(title: "Camera", style: .default) { _ in
                // print("camera clicked done")
                
                self.open_camera_or_gallery(str_type: "c")
            }
            
            let gallery = NewYorkButton(title: "Gallery", style: .default) { _ in
                // print("camera clicked done")
                
                self.open_camera_or_gallery(str_type: "g")
            }
            
            let cancel = NewYorkButton(title: "Cancel", style: .cancel)
            
            actionSheet.addButtons([cameraa, gallery, cancel])
            
            self.present(actionSheet, animated: true)
            
        } else {
            // 200
            
            if self.str_status_upload_logo == "0" {
                
                let alert = NewYorkAlertController(title: String("Alert"), message: "Please upload logo first.", style: .alert)
                
                alert.addImage(UIImage.gif(name: "gif_alert"))
                
                let cancel = NewYorkButton(title: "Ok", style: .cancel)
                alert.addButtons([cancel])
                
                self.present(alert, animated: true)
                
            } else {
                
                str_title = "Upload Club's banner"
                self.str_status_upload_banner = "1"
                
                let actionSheet = NewYorkAlertController(title: str_title, message: nil, style: .actionSheet)
                
                actionSheet.addImage(UIImage(named: "camera"))
                
                let cameraa = NewYorkButton(title: "Camera", style: .default) { _ in
                    // print("camera clicked done")
                    
                    self.open_camera_or_gallery(str_type: "c")
                }
                
                let gallery = NewYorkButton(title: "Gallery", style: .default) { _ in
                    // print("camera clicked done")
                    
                    self.open_camera_or_gallery(str_type: "g")
                }
                
                let cancel = NewYorkButton(title: "Cancel", style: .cancel)
                
                actionSheet.addButtons([cameraa, gallery, cancel])
                
                self.present(actionSheet, animated: true)
                
            }
            
        }
        
        
        
    }
    
    // MARK: - OPEN CAMERA or GALLERY -
    @objc func open_camera_or_gallery(str_type:String) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if str_type == "c" {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! AddressTableViewCell
        
        let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        if self.str_status_upload_logo == "1" {
            
            // self.str_status_upload_logo = "2"
            
            let cropper = CropperViewController(originalImage: image_data!)
            
            cropper.delegate = self
            
            picker.dismiss(animated: true) {
                self.present(cropper, animated: true, completion: nil)
                
            }
            
            /*cell.img_logo.image = image_data // show image on profile
            let imageData:Data = image_data!.pngData()!
            self.img_Str_logo = imageData.base64EncodedString()
            self.dismiss(animated: true, completion: nil)
            self.img_data_logo = image_data!.jpegData(compressionQuality: 0.2)!
            self.dismiss(animated: true, completion: nil)*/
            
        } else if self.str_status_upload_banner == "1" {
            
            // self.str_status_upload_banner = "2"
            
            let cropper = CropperViewController(originalImage: image_data!)
            
            cropper.delegate = self
            
            picker.dismiss(animated: true) {
                self.present(cropper, animated: true, completion: nil)
                
            }
            
            /*cell.img_banner.image = image_data // show image on profile
            let imageData:Data = image_data!.pngData()!
            self.img_Str_banner = imageData.base64EncodedString()
            self.dismiss(animated: true, completion: nil)
            self.img_data_banner = image_data!.jpegData(compressionQuality: 0.2)!
            self.dismiss(animated: true, completion: nil)*/
            
        } else {
            
            cell.img_banner.image = UIImage(named: "logo") // show image on profile
            let imageData:Data = image_data!.pngData()!
            self.img_Str_banner = imageData.base64EncodedString()
            self.dismiss(animated: true, completion: nil)
            self.img_data_banner = image_data!.jpegData(compressionQuality: 0.2)!
            self.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    func cropperDidConfirm(_ cropper: CropperViewController, state: CropperState?) {
        cropper.dismiss(animated: true, completion: nil)
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! AddressTableViewCell
        
        // print(self.str_status_upload_logo as Any)
        // print(self.str_status_upload_banner as Any)
        
        if let state = state,
           let image = cropper.originalImage.cropped(withCropperState: state) {
            
            if self.str_status_upload_logo == "1" {
                
                 self.str_status_upload_logo = "2"
                
                cell.img_logo.image = image
                
                let imageData:Data = image.pngData()!
                self.img_data_logo = imageData
                
            } else if self.str_status_upload_banner == "1" {
                
                 self.str_status_upload_banner = "2"
                
                cell.img_banner.image = image
                
                let imageData:Data = image.pngData()!
                self.img_data_banner = imageData
                
            }
            // self.imgProfile.image = image
            
            // let imageData:Data = image.pngData()!
            
            // self.imgData = imageData
            
        } else {
            print("Something went wrong")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - VALIDATION -
    @objc func validation_before_complete_profile() {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! AddressTableViewCell
        
        if String(cell.txtAddress.text!) == "" {
            
            self.promt_value(str_name: "Address")
            
        } else if String(cell.txtCountry.text!) == "" {
            
            self.promt_value(str_name: "Country")
            
        } else if String(cell.txtState.text!) == "" {
            
            self.promt_value(str_name: "State")
            
        } else if String(cell.txtZipCode.text!) == "" {
            
            self.promt_value(str_name: "Zipcode")
            
        } else if String(cell.txtClubOpenTime.text!) == "" {
            
            self.promt_value(str_name: "Open time")
            
        } else if String(cell.txtClubCloseTime.text!) == "" {
            
            self.promt_value(str_name: "Close time")
            
        } else if String(cell.txt_view_about.text!) == "" {
            
            self.promt_value(str_name: "About")
            
        } else {
            
            self.upload_only_details_wb()
                
        }
        
    }
    
    @objc func promt_value(str_name:String) {
        
        let alert = NewYorkAlertController(title: String("Alert"), message: String(str_name)+" should not be empty", style: .alert)
        
        alert.addImage(UIImage.gif(name: "gif_alert"))
        
        let cancel = NewYorkButton(title: "Ok", style: .cancel)
        alert.addButtons([cancel])
        
        self.present(alert, animated: true)
        
    }
    
    // MARK:- UPLOAD ONLY DETAILS -
    @objc func upload_only_details_wb() {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! AddressTableViewCell
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            print(person as Any)
            
            print((person["role"] as! String))
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params = edit_club_profile(action: "editprofile",
                                           userId: String(myString),
                                           address: String(cell.txtAddress.text!),
                                           countryId: String(self.strSaveSelectedCountryId),// String(self.countryId),
                                           stateId: String(self.stateId),
                                           openTime: String(cell.txtClubOpenTime.text!),
                                           closeTime: String(cell.txtClubCloseTime.text!),
                                           zipCode:String(cell.txtZipCode.text!),
                                           city:String(cell.txt_city.text!),
                                           about:String(cell.txt_view_about.text!))
            
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
                        
                        let defaults = UserDefaults.standard
                        defaults.setValue(nil, forKey: "keyLoginFullData")
                        defaults.setValue("", forKey: "keyLoginFullData")
                        
                        defaults.setValue(nil, forKey: "key_is_user_remembered")
                        defaults.setValue("", forKey: "key_is_user_remembered")
                        
                        
                        var dict: Dictionary<AnyHashable, Any>
                        dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                        
                        defaults.setValue(dict, forKey: "keyLoginFullData")
                        
                        if self.str_status_upload_logo == "2" {
                            
                            self.upload_club_logo_to_server()
                            
                        } else {
                            
                            ERProgressHud.sharedInstance.hide()
                            let tab_bar = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "tav_bar_controller_club_id") as? tav_bar_controller_club
                            tab_bar?.selectedIndex = 0
                            self.navigationController?.pushViewController(tab_bar!, animated: false)
                            
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
    }
    
    
    
    @objc func upload_club_logo_to_server() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! AddressTableViewCell
        
        // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        //Set Your URL
        let api_url = APPLICATION_BASE_URL
        guard let url = URL(string: api_url) else {
            return
        }
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // let str:String = person["role"] as! String
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            
            // let indexPath = IndexPath.init(row: 0, section: 0)
            // let cell = self.tablView.cellForRow(at: indexPath) as! AddTableTableViewCell
            
            //Set Your Parameter
            let parameterDict = NSMutableDictionary()
            parameterDict.setValue("editprofile", forKey: "action")
            parameterDict.setValue(String(myString), forKey: "userId")
            
            /*
             action: "editprofile",
                                            userId: String(myString),
                                            address: String(cell.txtAddress.text!),
                                            countryId: String(self.strSaveSelectedCountryId),// String(self.countryId),
                                            stateId: String(self.stateId),
                                            openTime: String(cell.txtClubOpenTime.text!),
                                            closeTime: String(cell.txtClubCloseTime.text!),
                                            zipCode:String(cell.txtZipCode.text!),
                                            city:String(cell.txt_city.text!),
                                            about:String(cell.txt_view_about.text!)
             */
            
            parameterDict.setValue(String(cell.txtAddress.text!), forKey: "address")
            parameterDict.setValue(String(self.strSaveSelectedCountryId), forKey: "countryId")
            parameterDict.setValue(String(self.stateId), forKey: "stateId")
            parameterDict.setValue(String(cell.txtClubOpenTime.text!), forKey: "openTime")
            parameterDict.setValue(String(cell.txtClubCloseTime.text!), forKey: "closeTime")
            parameterDict.setValue(String(cell.txtZipCode.text!), forKey: "zipCode")
            parameterDict.setValue(String(cell.txt_city.text!), forKey: "city")
            parameterDict.setValue(String(cell.txt_view_about.text!), forKey: "about")
            
            print(parameterDict as Any)
            
            // Now Execute
            AF.upload(multipartFormData: { multiPart in
                for (key, value) in parameterDict {
                    if let temp = value as? String {
                        multiPart.append(temp.data(using: .utf8)!, withName: key as! String)
                    }
                    if let temp = value as? Int {
                        multiPart.append("\(temp)".data(using: .utf8)!, withName: key as! String)
                    }
                    if let temp = value as? NSArray {
                        temp.forEach({ element in
                            let keyObj = key as! String + "[]"
                            if let string = element as? String {
                                multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                            } else
                            if let num = element as? Int {
                                let value = "\(num)"
                                multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                            }
                        })
                    }
                }
                multiPart.append(self.img_data_logo, withName: "image", fileName: "add_club_logo.png", mimeType: "image/png")
            }, with: urlRequest)
                .uploadProgress(queue: .main, closure: { progress in
                    //Current upload progress of file
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                .responseJSON(completionHandler: { data in
                    
                    switch data.result {
                        
                    case .success(_):
                        do {
                            
                            let dictionary = try JSONSerialization.jsonObject(with: data.data!, options: .fragmentsAllowed) as! NSDictionary
                            
                            print("Success!")
                            print(dictionary)
                            
                            let defaults = UserDefaults.standard
                            defaults.setValue(nil, forKey: "keyLoginFullData")
                            defaults.setValue("", forKey: "keyLoginFullData")
                            
                            defaults.setValue(nil, forKey: "key_is_user_remembered")
                            defaults.setValue("", forKey: "key_is_user_remembered")
                            
                            
                            var dict: Dictionary<AnyHashable, Any>
                            dict = dictionary["data"] as! Dictionary<AnyHashable, Any>
                            
                            defaults.setValue(dict, forKey: "keyLoginFullData")
                            
                            if self.str_status_upload_banner == "2" {
                                
                                self.upload_club_banner_to_server()
                                
                            } else {
                                
                                ERProgressHud.sharedInstance.hide()
                                let tab_bar = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "tav_bar_controller_club_id") as? tav_bar_controller_club
                                tab_bar?.selectedIndex = 0
                                self.navigationController?.pushViewController(tab_bar!, animated: false)
                                
                            }
                            
                        }
                        catch {
                            // catch error.
                            print("catch error")
                            ERProgressHud.sharedInstance.hide()
                        }
                        break
                        
                    case .failure(_):
                        print("failure")
                        ERProgressHud.sharedInstance.hide()
                        break
                        
                    }
                    
                    
                })
            
        }}
    
    @objc func upload_club_banner_to_server() {
        
        // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        //Set Your URL
        let api_url = APPLICATION_BASE_URL
        guard let url = URL(string: api_url) else {
            return
        }
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // let str:String = person["role"] as! String
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            
            // let indexPath = IndexPath.init(row: 0, section: 0)
            // let cell = self.tablView.cellForRow(at: indexPath) as! AddTableTableViewCell
            
            //Set Your Parameter
            let parameterDict = NSMutableDictionary()
            parameterDict.setValue("editprofile", forKey: "action")
            parameterDict.setValue(String(myString), forKey: "userId")
            
            
            // Now Execute
            AF.upload(multipartFormData: { multiPart in
                for (key, value) in parameterDict {
                    if let temp = value as? String {
                        multiPart.append(temp.data(using: .utf8)!, withName: key as! String)
                    }
                    if let temp = value as? Int {
                        multiPart.append("\(temp)".data(using: .utf8)!, withName: key as! String)
                    }
                    if let temp = value as? NSArray {
                        temp.forEach({ element in
                            let keyObj = key as! String + "[]"
                            if let string = element as? String {
                                multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                            } else
                            if let num = element as? Int {
                                let value = "\(num)"
                                multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                            }
                        })
                    }
                }
                multiPart.append(self.img_data_banner, withName: "banner", fileName: "add_club_banner.png", mimeType: "image/png")
            }, with: urlRequest)
                .uploadProgress(queue: .main, closure: { progress in
                    //Current upload progress of file
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                .responseJSON(completionHandler: { data in
                    
                    switch data.result {
                        
                    case .success(_):
                        do {
                            
                            let dictionary = try JSONSerialization.jsonObject(with: data.data!, options: .fragmentsAllowed) as! NSDictionary
                            
                            print("Success!")
                            print(dictionary)
                            
                            let defaults = UserDefaults.standard
                            defaults.setValue(nil, forKey: "keyLoginFullData")
                            defaults.setValue("", forKey: "keyLoginFullData")
                            
                            defaults.setValue(nil, forKey: "key_is_user_remembered")
                            defaults.setValue("", forKey: "key_is_user_remembered")
                            
                            
                            var dict: Dictionary<AnyHashable, Any>
                            dict = dictionary["data"] as! Dictionary<AnyHashable, Any>
                            
                            defaults.setValue(dict, forKey: "keyLoginFullData")
                            
                            ERProgressHud.sharedInstance.hide()
                            let tab_bar = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "tav_bar_controller_club_id") as? tav_bar_controller_club
                            tab_bar?.selectedIndex = 0
                            self.navigationController?.pushViewController(tab_bar!, animated: false)
                            
                        }
                        catch {
                            // catch error.
                            print("catch error")
                            ERProgressHud.sharedInstance.hide()
                        }
                        break
                        
                    case .failure(_):
                        print("failure")
                        ERProgressHud.sharedInstance.hide()
                        break
                        
                    }
                    
                    
                })
            
        }}
    
    
    @objc func countryListWebSer() {
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
                    
                    
                }
                else{
                    print("no")
                    ERProgressHud.sharedInstance.hide()
                    
                }
            case let .failure(error):
                
                print(error)
                ERProgressHud.sharedInstance.hide()
            }
            
        }
        
    }
    
    
    
    @objc func btnCountryPress() {
        
        if self.traitCollection.userInterfaceStyle == .dark {
            // User Interface is Dark
            
            let indexPath = IndexPath.init(row: 0, section: 0)
            let cell = self.tablView.cellForRow(at: indexPath) as! AddressTableViewCell
            
            let redAppearance = YBTextPickerAppearanceManager.init(
                pickerTitle         : "Select Country",
                titleFont           : boldFont,
                titleTextColor      : .white,
                titleBackground     : .systemTeal,
                searchBarFont       : regularFont,
                searchBarPlaceholder: "Search Country",
                closeButtonTitle    : "Cancel",
                closeButtonColor    : .darkGray,
                closeButtonFont     : regularFont,
                doneButtonTitle     : "Okay",
                doneButtonColor     : .systemTeal,
                doneButtonFont      : boldFont,
                checkMarkPosition   : .Right,
                itemCheckedImage    : UIImage(named:"red_ic_checked"),
                itemUncheckedImage  : UIImage(named:"red_ic_unchecked"),
                itemColor           : .white,
                itemFont            : regularFont
            )
            
            //let arrGender = ["Male", "Female", "Prefer not to Say"]
            
            let item = countryListArray.mutableArrayValue(forKey: "name")
            
            
            // let item2 = countryListArray.mutableArrayValue(forKey: "id")
            
            //print(item as Any)
            
            let picker = YBTextPicker.init(with: item as! [String], appearance: redAppearance,onCompletion: { [self] (selectedIndexes, selectedValues) in
                
                if let selectedValue = selectedValues.first{
                    
                    cell.btn_country.setTitle("\(selectedValue)", for: .normal)
                    cell.btn_country.setTitleColor(.clear, for: .normal)
                    
                    cell.txtCountry.text = "\(selectedValue)"
                    
                    myStr = selectedValue
                    
                    
                    // print(myStr)
                    
                    for index in 0..<countryListArray.count {
                        
                        let itm = countryListArray[index] as? [String:Any]
                        
                        // let name = (itm!["name"] as! String)
                        
                        //print(name)
                        
                        if myStr == (itm!["name"] as! String) {
                            
                            print("selected index = \(countryListArray[index])")
                            
                            countryId = String((itm!["id"] as! Int))
                            
                            print(countryId)
                            
                            // cell.txtCountry.text = countryId
                            cell.txtCountry.textColor = .black
                            
                            self.strSaveSelectedCountryId = String(countryId)
                            
                        }
                    }
                    
                    
                }
                else {
                    
                    cell.btn_country.setTitle("Select Country", for: .normal)
                    
                }
            },
                                           onCancel: {
                
                print("Cancelled")
            }
                                           
            )
            
            
            picker.show(withAnimation: .FromBottom)
            
            
        } else {
            // User Interface is Light
            
            let indexPath = IndexPath.init(row: 0, section: 0)
            let cell = self.tablView.cellForRow(at: indexPath) as! AddressTableViewCell
            
            let redAppearance = YBTextPickerAppearanceManager.init(
                pickerTitle         : "Select Country",
                titleFont           : boldFont,
                titleTextColor      : .white,
                titleBackground     : .systemTeal,
                searchBarFont       : regularFont,
                searchBarPlaceholder: "Search Country",
                closeButtonTitle    : "Cancel",
                closeButtonColor    : .darkGray,
                closeButtonFont     : regularFont,
                doneButtonTitle     : "Okay",
                doneButtonColor     : .systemTeal,
                doneButtonFont      : boldFont,
                checkMarkPosition   : .Right,
                itemCheckedImage    : UIImage(named:"red_ic_checked"),
                itemUncheckedImage  : UIImage(named:"red_ic_unchecked"),
                itemColor           : .black,
                itemFont            : regularFont
            )
            
            //let arrGender = ["Male", "Female", "Prefer not to Say"]
            
            let item = countryListArray.mutableArrayValue(forKey: "name")
            
            
            // let item2 = countryListArray.mutableArrayValue(forKey: "id")
            
            //print(item as Any)
            
            let picker = YBTextPicker.init(with: item as! [String], appearance: redAppearance,onCompletion: { [self] (selectedIndexes, selectedValues) in
                
                if let selectedValue = selectedValues.first{
                    
                    cell.btn_country.setTitle("\(selectedValue)", for: .normal)
                    cell.btn_country.setTitleColor(.clear, for: .normal)
                    
                    cell.txtCountry.text = "\(selectedValue)"
                    
                    myStr = selectedValue
                    
                    
                    // print(myStr)
                    
                    for index in 0..<countryListArray.count {
                        
                        let itm = countryListArray[index] as? [String:Any]
                        
                        // let name = (itm!["name"] as! String)
                        
                        //print(name)
                        
                        if myStr == (itm!["name"] as! String) {
                            
                            print("selected index = \(countryListArray[index])")
                            
                            countryId = String((itm!["id"] as! Int))
                            
                            print(countryId)
                            
                            // cell.txtCountry.text = countryId
                            cell.txtCountry.textColor = .black
                            
                            self.strSaveSelectedCountryId = String(countryId)
                            
                        }
                    }
                    
                    
                }
                else {
                    
                    cell.btn_country.setTitle("Select Country", for: .normal)
                    
                }
            },
                                           onCancel: {
                
                print("Cancelled")
            }
                                           
            )
            
            
            picker.show(withAnimation: .FromBottom)
            
        }
        
        
        
        
        
    }
    
    @objc func state_click() {
        
        if self.traitCollection.userInterfaceStyle == .dark {
            
            let indexPath = IndexPath.init(row: 0, section: 0)
            let cell = self.tablView.cellForRow(at: indexPath) as! AddressTableViewCell
            
            let redAppearance = YBTextPickerAppearanceManager.init(
                pickerTitle         : "Select State",
                titleFont           : boldFont,
                titleTextColor      : .white,
                titleBackground     : .systemTeal,
                searchBarFont       : regularFont,
                searchBarPlaceholder: "Search Country",
                closeButtonTitle    : "Cancel",
                closeButtonColor    : .darkGray,
                closeButtonFont     : regularFont,
                doneButtonTitle     : "Okay",
                doneButtonColor     : .systemTeal,
                doneButtonFont      : boldFont,
                checkMarkPosition   : .Right,
                itemCheckedImage    : UIImage(named:"red_ic_checked"),
                itemUncheckedImage  : UIImage(named:"red_ic_unchecked"),
                itemColor           : .white,
                itemFont            : regularFont
            )
            
            //let arrGender = ["Male", "Female", "Prefer not to Say"]
            
            let item = stateListArray.mutableArrayValue(forKey: "name")
            
            
            // let item2 = countryListArray.mutableArrayValue(forKey: "id")
            
            //print(item as Any)
            
            let picker = YBTextPicker.init(with: item as! [String], appearance: redAppearance,onCompletion: { [self] (selectedIndexes, selectedValues) in
                
                if let selectedValue = selectedValues.first{
                    
                    cell.btn_country.setTitle("\(selectedValue)", for: .normal)
                    cell.btn_country.setTitleColor(.clear, for: .normal)
                    
                    cell.txtState.text = "\(selectedValue)"
                    
                    myStr2 = selectedValue
                    
                    
                    // print(myStr)
                    
                    for index in 0..<stateListArray.count {
                        
                        let itm = stateListArray[index] as? [String:Any]
                        
                        // let name = (itm!["name"] as! String)
                        
                        //print(name)
                        
                        if myStr2 == (itm!["name"] as! String) {
                            
                            print("selected index = \(stateListArray[index])")
                            
                            stateId = String((itm!["id"] as! Int))
                            
                            print(stateId)
                            
                            // cell.txtCountry.text = countryId
                            cell.txtState.textColor = .black
                            
                            // self.strSaveSelectedCountryId = String(stateId)
                            
                        }
                    }
                    
                    
                }
                else {
                    
                    cell.btn_country.setTitle("Select Country", for: .normal)
                    
                }
            },
                                           onCancel: {
                
                print("Cancelled")
            }
                                           
            )
            
            
            picker.show(withAnimation: .FromBottom)
            
        } else {
            
            let indexPath = IndexPath.init(row: 0, section: 0)
            let cell = self.tablView.cellForRow(at: indexPath) as! AddressTableViewCell
            
            let redAppearance = YBTextPickerAppearanceManager.init(
                pickerTitle         : "Select State",
                titleFont           : boldFont,
                titleTextColor      : .white,
                titleBackground     : .systemTeal,
                searchBarFont       : regularFont,
                searchBarPlaceholder: "Search Country",
                closeButtonTitle    : "Cancel",
                closeButtonColor    : .darkGray,
                closeButtonFont     : regularFont,
                doneButtonTitle     : "Okay",
                doneButtonColor     : .systemTeal,
                doneButtonFont      : boldFont,
                checkMarkPosition   : .Right,
                itemCheckedImage    : UIImage(named:"red_ic_checked"),
                itemUncheckedImage  : UIImage(named:"red_ic_unchecked"),
                itemColor           : .black,
                itemFont            : regularFont
            )
            
            //let arrGender = ["Male", "Female", "Prefer not to Say"]
            
            let item = stateListArray.mutableArrayValue(forKey: "name")
            
            
            // let item2 = countryListArray.mutableArrayValue(forKey: "id")
            
            //print(item as Any)
            
            let picker = YBTextPicker.init(with: item as! [String], appearance: redAppearance,onCompletion: { [self] (selectedIndexes, selectedValues) in
                
                if let selectedValue = selectedValues.first{
                    
                    cell.btn_country.setTitle("\(selectedValue)", for: .normal)
                    cell.btn_country.setTitleColor(.clear, for: .normal)
                    
                    cell.txtState.text = "\(selectedValue)"
                    
                    myStr2 = selectedValue
                    
                    
                    // print(myStr)
                    
                    for index in 0..<stateListArray.count {
                        
                        let itm = stateListArray[index] as? [String:Any]
                        
                        // let name = (itm!["name"] as! String)
                        
                        //print(name)
                        
                        if myStr2 == (itm!["name"] as! String) {
                            
                            print("selected index = \(stateListArray[index])")
                            
                            stateId = String((itm!["id"] as! Int))
                            
                            print(stateId)
                            
                            // cell.txtCountry.text = countryId
                            cell.txtState.textColor = .black
                            
                            // self.strSaveSelectedCountryId = String(stateId)
                            
                        }
                    }
                    
                    
                }
                else {
                    
                    cell.btn_country.setTitle("Select Country", for: .normal)
                    
                }
            },
                                           onCancel: {
                
                print("Cancelled")
            }
                                           
            )
            
            
            picker.show(withAnimation: .FromBottom)
            
        }
    }
    
    
    @objc func state_list_wb() {
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please Wait...")
        
        
        self.stateListArray.removeAllObjects()
        
        let params = state_list(action:"stateList",
                                countryId: String(self.countryId))
        
        
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
                    self.stateListArray.addObjects(from: ar as! [Any])
                    
                    self.state_click()
                }
                else{
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
extension AddressVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:AddressTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AddressTableCell") as! AddressTableViewCell
        
        cell.backgroundColor = APP_BASIC_COLOR
      
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        // image logo
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(AddressVC.cellTappedMethod1(_:)))
        cell.img_logo.isUserInteractionEnabled = true
        cell.img_logo.tag = 100
        cell.img_logo.addGestureRecognizer(tapGestureRecognizer1)
        
        // image banner
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(AddressVC.cellTappedMethod1(_:)))
        cell.img_banner.isUserInteractionEnabled = true
        cell.img_banner.tag = 200
        cell.img_banner.addGestureRecognizer(tapGestureRecognizer2)
        
        cell.btn_open_time.addTarget(self, action: #selector(open_time_click_method), for: .touchUpInside)
        cell.btn_close_time.addTarget(self, action: #selector(close_time_click_method), for: .touchUpInside)
        
        cell.btn_state.addTarget(self, action: #selector(state_list_wb), for: .touchUpInside)
        cell.btn_country.addTarget(self, action: #selector(btnCountryPress), for: .touchUpInside)
        cell.btnSave.addTarget(self, action: #selector(validation_before_complete_profile), for: .touchUpInside)
        
        return cell
    }

    // MARK: - OPEN CLICK -
    @objc func open_time_click_method() {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! AddressTableViewCell
        
        RPicker.selectDate(title: "Select open time", cancelText: "Cancel", datePickerMode: .time, didSelectDate: {[] (selectedDate) in
            // TODO: Your implementation for date
            cell.txtClubOpenTime.text = selectedDate.dateString("hh:mm a")
        })
        
    }
    
    // MARK: - CLOSE CLICK -
    @objc func close_time_click_method() {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! AddressTableViewCell
        
        RPicker.selectDate(title: "Select close time", cancelText: "Cancel", datePickerMode: .time, didSelectDate: {[] (selectedDate) in
            // TODO: Your implementation for date
            cell.txtClubCloseTime.text = selectedDate.dateString("hh:mm a")
        })
        
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1500
    }
    
    
}

extension AddressVC: UITableViewDelegate {
    
}
