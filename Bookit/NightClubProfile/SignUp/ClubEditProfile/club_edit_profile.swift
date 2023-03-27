//
//  club_edit_profile.swift
//  Bookit
//
//  Created by Apple on 01/03/22.
//

import UIKit

import Alamofire
import SDWebImage

import QCropper

class club_edit_profile: UIViewController , UINavigationControllerDelegate, UIImagePickerControllerDelegate , CropperViewControllerDelegate {
    
    
    
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
            lblNavigationTitle.text = "Edit profile"
            lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
            lblNavigationTitle.backgroundColor = .clear
        }
    }
    
    // ***************************************************************** // nav
    
    @IBOutlet weak var tablView:UITableView!{
        didSet {
            // tablView.delegate = self
            // tablView.dataSource = self
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
        
        
        
        
        // self.manage_profile()
        
        self.btnBack.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        self.get_club_Details()
        
        
        
    }
    
    
    @objc func manage_profile() {
        
        if let myLoadedString = UserDefaults.standard.string(forKey: "keySetToBackOrMenu") {
            print(myLoadedString)
            
            if myLoadedString == "backOrMenu" {
                // menu
                self.btnBack.setImage(UIImage(systemName: "list.dash"), for: .normal)
                // self.sideBarMenuClick()
            } else {
                // back
                self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
            }
        } else {
            // back
            self.btnBack.setImage(UIImage(systemName: "arrow.left"), for: .normal)
            self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
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
    
    // MARK: - GET CLUB DETAILS -
    @objc func get_club_Details() {
    
        self.countryListWebSer()
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
            
            /*if self.str_status_upload_logo == "0" {
                
                let alert = NewYorkAlertController(title: String("Alert"), message: "Please upload logo first.", style: .alert)
                
                alert.addImage(UIImage.gif(name: "gif_alert"))
                
                let cancel = NewYorkButton(title: "Ok", style: .cancel)
                alert.addButtons([cancel])
                
                self.present(alert, animated: true)
                
            } else {*/
                
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
                
            // }
            
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
        let cell = self.tablView.cellForRow(at: indexPath) as! club_edit_profile_table_cell
        
        let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        if self.str_status_upload_logo == "1" {
            
            // self.str_status_upload_logo = "2"
            
            /*cell.img_logo.image = image_data // show image on profile
            let imageData:Data = image_data!.pngData()!
            self.img_Str_logo = imageData.base64EncodedString()
            self.dismiss(animated: true, completion: nil)
            self.img_data_logo = image_data!.jpegData(compressionQuality: 0.2)!
            self.dismiss(animated: true, completion: nil)*/
            
            let cropper = CropperViewController(originalImage: image_data!)
            
            cropper.delegate = self
            
            picker.dismiss(animated: true) {
                self.present(cropper, animated: true, completion: nil)
                
            }
            
            // self.upload_club_logo_to_server()
            
        } else if self.str_status_upload_banner == "1" {
            
            // self.str_status_upload_banner = "2"
            
            /*cell.img_banner.image = image_data // show image on profile
            let imageData:Data = image_data!.pngData()!
            self.img_Str_banner = imageData.base64EncodedString()
            self.dismiss(animated: true, completion: nil)
            self.img_data_banner = image_data!.jpegData(compressionQuality: 0.2)!
            self.dismiss(animated: true, completion: nil)*/
            
            let cropper = CropperViewController(originalImage: image_data!)
            
            cropper.delegate = self
            
            picker.dismiss(animated: true) {
                self.present(cropper, animated: true, completion: nil)
                
            }
            
           // self.upload_club_banner_to_server()
            
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
        let cell = self.tablView.cellForRow(at: indexPath) as! club_edit_profile_table_cell
        
        // print(self.str_status_upload_logo as Any)
        // print(self.str_status_upload_banner as Any)
        
        if let state = state,
           let image = cropper.originalImage.cropped(withCropperState: state) {
            
            if self.str_status_upload_logo == "1" {
                
                 self.str_status_upload_logo = "2"
                
                cell.img_logo.image = image
                
                let imageData:Data = image.pngData()!
                self.img_data_logo = imageData
                
                self.upload_club_logo_to_server()
                
            } else if self.str_status_upload_banner == "1" {
                
                 self.str_status_upload_banner = "2"
                
                cell.img_banner.image = image
                
                let imageData:Data = image.pngData()!
                self.img_data_banner = imageData
                
                self.upload_club_banner_to_server()
                
            }
            
            
        } else {
            print("Something went wrong")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - VALIDATION -
    @objc func validation_before_complete_profile() {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! club_edit_profile_table_cell
        
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
        let cell = self.tablView.cellForRow(at: indexPath) as! club_edit_profile_table_cell
        
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
                                           countryId: String(self.countryId),
                                           stateId: String(self.stateId),
                                           openTime: String(cell.txtClubOpenTime.text!),
                                           closeTime: String(cell.txtClubCloseTime.text!),
                                           zipCode:String(cell.txtZipCode.text!),
                                           city:String(cell.txtZipCode.text!),
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
                        
                        ERProgressHud.sharedInstance.hide()
                        
                        let defaults = UserDefaults.standard
                        defaults.setValue(nil, forKey: "keyLoginFullData")
                        defaults.setValue("", forKey: "keyLoginFullData")
                        
                        defaults.setValue(nil, forKey: "key_is_user_remembered")
                        defaults.setValue("", forKey: "key_is_user_remembered")
                        
                        
                        var dict: Dictionary<AnyHashable, Any>
                        dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                        
                        defaults.setValue(dict, forKey: "keyLoginFullData")
                        
                        var strSuccess2 : String!
                        strSuccess2 = JSON["msg"]as Any as? String
                        
                        let alert = NewYorkAlertController(title: "Success", message: String(strSuccess2), style: .alert)
                        
                        alert.addImage(UIImage.gif(name: "success3"))
                        
                        let cancel = NewYorkButton(title: "Ok", style: .cancel)
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
        }
    }
    
    
    
    @objc func upload_club_logo_to_server() {
        
         ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
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
                            
                            ERProgressHud.sharedInstance.hide()
                            
                            let defaults = UserDefaults.standard
                            defaults.setValue(nil, forKey: "keyLoginFullData")
                            defaults.setValue("", forKey: "keyLoginFullData")
                            
                            defaults.setValue(nil, forKey: "key_is_user_remembered")
                            defaults.setValue("", forKey: "key_is_user_remembered")
                            
                            
                            var dict: Dictionary<AnyHashable, Any>
                            dict = dictionary["data"] as! Dictionary<AnyHashable, Any>
                            
                            defaults.setValue(dict, forKey: "keyLoginFullData")
                            
                            var strSuccess2 : String!
                            strSuccess2 = dictionary["msg"]as Any as? String
                            
                            let alert = NewYorkAlertController(title: "Success", message: String(strSuccess2), style: .alert)
                            
                            alert.addImage(UIImage.gif(name: "success3"))
                            
                            let cancel = NewYorkButton(title: "Ok", style: .cancel)
                            alert.addButtons([cancel])
                            
                            self.present(alert, animated: true)
                            
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
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
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
                multiPart.append(self.img_data_banner, withName: "banner", fileName: "edit_club_banner.png", mimeType: "image/png")
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
                            
                            ERProgressHud.sharedInstance.hide()
                            
                            let defaults = UserDefaults.standard
                            defaults.setValue(nil, forKey: "keyLoginFullData")
                            defaults.setValue("", forKey: "keyLoginFullData")
                            
                            defaults.setValue(nil, forKey: "key_is_user_remembered")
                            defaults.setValue("", forKey: "key_is_user_remembered")
                            
                            
                            var dict: Dictionary<AnyHashable, Any>
                            dict = dictionary["data"] as! Dictionary<AnyHashable, Any>
                            
                            defaults.setValue(dict, forKey: "keyLoginFullData")
                            
                            var strSuccess2 : String!
                            strSuccess2 = dictionary["msg"]as Any as? String
                            
                            let alert = NewYorkAlertController(title: "Success", message: String(strSuccess2), style: .alert)
                            
                            alert.addImage(UIImage.gif(name: "success3"))
                            
                            let cancel = NewYorkButton(title: "Ok", style: .cancel)
                            alert.addButtons([cancel])
                            
                            self.present(alert, animated: true)
                            
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
                
                // print(JSON as Any)
                
                var strSuccess : String!
                strSuccess = JSON["status"]as Any as? String
                
                if strSuccess == String("success") {
                    
                    print("yes")
                    // ERProgressHud.sharedInstance.hide()
                    var ar : NSArray!
                    ar = (JSON["data"] as! Array<Any>) as NSArray
                    self.countryListArray.addObjects(from: ar as! [Any])
                    
                    self.edit_club_WB()
                    
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
            
            let indexPath = IndexPath.init(row: 0, section: 0)
            let cell = self.tablView.cellForRow(at: indexPath) as! club_edit_profile_table_cell
            
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
            
            let indexPath = IndexPath.init(row: 0, section: 0)
            let cell = self.tablView.cellForRow(at: indexPath) as! club_edit_profile_table_cell
            
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
        let cell = self.tablView.cellForRow(at: indexPath) as! club_edit_profile_table_cell
        
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
            let cell = self.tablView.cellForRow(at: indexPath) as! club_edit_profile_table_cell
            
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
    
    
    @objc func edit_club_WB(){
        
        self.view.endEditing(true)
        
        // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            print(person as Any)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params = club_earning(action: "profile",
                                      userId: String(myString))
            
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
                        
                        // total amount
                        
                        var dict: Dictionary<AnyHashable, Any>
                        dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                        
                        let defaults = UserDefaults.standard
                        defaults.setValue(dict, forKey: "keyLoginFullData")
                        
                        self.tablView.delegate = self
                        self.tablView.dataSource = self
                        self.tablView.reloadData()
                        
//                        self.strSuccess2_total_amount = "\(dict["wallet"]!)"
//
//                        self.lblTotalEarning.text = "$"+String(self.strSuccess2_total_amount)
//                        self.lblWithdrawableAmount.text = "Withdrawable balance : $\(dict["wallet"]!)"
//
                        
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
    
}

//MARK:- TABLE VIEW -
extension club_edit_profile: UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:club_edit_profile_table_cell = tableView.dequeueReusableCell(withIdentifier: "club_edit_profile_table_cell") as! club_edit_profile_table_cell
        
        cell.backgroundColor = APP_BASIC_COLOR
      
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            print(person as Any)
            
            
            cell.txtAddress.text = (person["address"] as! String)
            cell.txtZipCode.text = (person["zipCode"] as! String)
            cell.txtClubOpenTime.text = (person["openTime"] as! String)
            cell.txtClubCloseTime.text = (person["closeTime"] as! String)
            cell.txt_city.text = (person["city"] as! String)
            
            self.countryId = "\((person["countryId"]!))"
            self.stateId = "\((person["stateId"]!))"
            
            cell.txtCountry.text = (person["countryName"] as! String)
            cell.txtState.text = (person["stateName"] as! String)
            cell.txt_view_about.text    = "\(person["about"]!)"
            
            // var countryId = ""
            // var stateId = ""
            
            cell.img_logo.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
            cell.img_logo.sd_setImage(with: URL(string: (person["image"] as! String)), placeholderImage: UIImage(named: "logo"))
            
            
            cell.img_banner.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
            cell.img_banner.sd_setImage(with: URL(string: (person["banner"] as! String)), placeholderImage: UIImage(named: "logo"))
            
        }
        
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
        let cell = self.tablView.cellForRow(at: indexPath) as! club_edit_profile_table_cell
        
        RPicker.selectDate(title: "Select open time", cancelText: "Cancel", datePickerMode: .time, didSelectDate: {[] (selectedDate) in
            // TODO: Your implementation for date
            cell.txtClubOpenTime.text = selectedDate.dateString("hh:mm a")
        })
        
    }
    
    // MARK: - CLOSE CLICK -
    @objc func close_time_click_method() {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! club_edit_profile_table_cell
        
        RPicker.selectDate(title: "Select close time", cancelText: "Cancel", datePickerMode: .time, didSelectDate: {[] (selectedDate) in
            // TODO: Your implementation for date
            cell.txtClubCloseTime.text = selectedDate.dateString("hh:mm a")
        })
        
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1000
    }
    
    
}

class club_edit_profile_table_cell: UITableViewCell {
    
    
    let paddingFromLeftIs:CGFloat = 10
    
    @IBOutlet weak var txtAddress:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txtAddress,
                              tfName: txtAddress.text!,
                              tfCornerRadius: 27.5,
                              tfpadding: paddingFromLeftIs,
                              tfBorderWidth: 0.8,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Address")
        }
    }
    
    
    @IBOutlet weak var txtCountry:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txtCountry,
                              tfName: txtCountry.text!,
                              tfCornerRadius: 27.5,
                              tfpadding: paddingFromLeftIs,
                              tfBorderWidth: 0.8,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Country")
            txtCountry.textColor = .black
        }
    }
    
    @IBOutlet weak var txtState:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txtState,
                              tfName: txtState.text!,
                              tfCornerRadius: 27.5,
                              tfpadding: paddingFromLeftIs,
                              tfBorderWidth: 0.8,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "State")
        }
    }
    
    @IBOutlet weak var txtZipCode:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txtZipCode,
                              tfName: txtZipCode.text!,
                              tfCornerRadius: 27.5,
                              tfpadding: paddingFromLeftIs,
                              tfBorderWidth: 0.8,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Zip Code")
        }
    }
    
    @IBOutlet weak var txt_city:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txt_city,
                              tfName: txt_city.text!,
                              tfCornerRadius: 27.5,
                              tfpadding: paddingFromLeftIs,
                              tfBorderWidth: 0.8,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "City")
        }
    }
    
    @IBOutlet weak var txtClubOpenTime:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txtClubOpenTime,
                              tfName: txtClubOpenTime.text!,
                              tfCornerRadius: 27.5,
                              tfpadding: paddingFromLeftIs,
                              tfBorderWidth: 0.8,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Open Time")
        }
    }
    
    @IBOutlet weak var txtClubCloseTime:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txtClubCloseTime,
                              tfName: txtClubCloseTime.text!,
                              tfCornerRadius: 27.5,
                              tfpadding: paddingFromLeftIs,
                              tfBorderWidth: 0.8,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Close Time")
        }
    }
    
    @IBOutlet weak var txtUploadLogo:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txtUploadLogo,
                              tfName: txtUploadLogo.text!,
                              tfCornerRadius: 27.5,
                              tfpadding: paddingFromLeftIs,
                              tfBorderWidth: 0.8,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Upload Logo")
        }
    }
    
    @IBOutlet weak var txtUploadBanner:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txtUploadBanner,
                              tfName: txtUploadBanner.text!,
                              tfCornerRadius: 27.5,
                              tfpadding: paddingFromLeftIs,
                              tfBorderWidth: 0.8,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Upload Banner")
        }
    }
    
    @IBOutlet weak var view_bg:UIView! {
        didSet {
            view_bg.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_bg.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            view_bg.layer.shadowOpacity = 1.0
            view_bg.layer.shadowRadius = 15.0
            view_bg.layer.masksToBounds = false
            view_bg.layer.cornerRadius = 15
            view_bg.backgroundColor = .systemGray4
        }
    }
    
    @IBOutlet weak var img_logo:UIImageView! {
        didSet {
            /*img_logo.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            img_logo.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            img_logo.layer.shadowOpacity = 1.0
            img_logo.layer.shadowRadius = 15.0
            img_logo.layer.masksToBounds = false
            img_logo.layer.cornerRadius = 15
            img_logo.backgroundColor = .white*/
        }
    }
    
    @IBOutlet weak var btn_country:UIButton!
    @IBOutlet weak var btn_state:UIButton!
    
    @IBOutlet weak var img_banner:UIImageView! {
        didSet {
            /*img_banner.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            img_banner.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            img_banner.layer.shadowOpacity = 1.0
            img_banner.layer.shadowRadius = 15.0
            img_banner.layer.masksToBounds = false
            img_banner.layer.cornerRadius = 15
            img_banner.backgroundColor = .white*/
        }
    }
    
    @IBOutlet weak var btn_open_time:UIButton!
    @IBOutlet weak var btn_close_time:UIButton!
    
    @IBOutlet weak var btnSave:UIButton!{
        
        didSet{
            btnSave.layer.cornerRadius = 27.5
            btnSave.clipsToBounds = true
            btnSave.setTitle("Update", for: .normal)
            btnSave.backgroundColor =  BUTTON_DARK_APP_COLOR
        }
    }

    @IBOutlet weak var txt_view_about:UITextView! {
        didSet {
            txt_view_about.text = ""
            txt_view_about.layer.cornerRadius = 16
            txt_view_about.clipsToBounds = true
            txt_view_about.backgroundColor = .white
            txt_view_about.textColor = .black
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
