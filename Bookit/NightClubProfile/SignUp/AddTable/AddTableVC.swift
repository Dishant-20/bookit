//
//  AddTableVC.swift
//  Bookit
//
//  Created by Ranjan on 21/12/21.
//

import UIKit
import Alamofire
import SDWebImage

import QCropper

class AddTableVC: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate , UITextFieldDelegate , CropperViewControllerDelegate {
    
    var pickedImage = false
    
    var imgData1 : Data!
    var imageStr1 : String! = ""
    
    var str_upload_image_on_table_Status:String! = "0"
    
    var str_edit_table_Status:String!
    
    var dict_get_table_data:NSDictionary!
    
    var str_selected_percentage:String!
    
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
            
            lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
            lblNavigationTitle.backgroundColor = .clear
            
            if btnEditTappedStr == "EditBtnTapped" {
                
                lblNavigationTitle.text = "EDIT TABLE"
            }
            else{
                
                lblNavigationTitle.text = "ADD TABLE"
                
                
            }
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
        
        self.btnBack.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        
        // self.manage_table_data()
        
    }
    
    @objc func back_click_method() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func manage_table_data() {
        // str_edit_table_Status
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! AddTableTableViewCell
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // let str:String = person["role"] as! String
            print(person as Any)
            
            if (person["role"] as! String) == "Club" {
                
                if self.dict_get_table_data != nil {
                    
                    cell.txtTableNumber.text    = (dict_get_table_data["name"] as! String)
                    cell.txtTotaaSeat.text      = (dict_get_table_data["totalSeat"] as! String)
                    cell.txtPrice.text          = (dict_get_table_data["seatPrice"] as! String)
                    
                }
                
                
            }
            
            
        }
        
    }
    
    @objc func fieldShoulNotBeEmptyPopup(strTitle:String) {
        
        let alert = UIAlertController(title: "Alert", message: String(strTitle)+" Field should not be empty", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true)
        
    }
    
    @objc func btnContinueTapped(){
        
        if btnEditTappedStr == "EditBtnTapped"{
            
            EditTableWithImageWebService()
        }
        
        else{
            
            // callBeforeAddTable()
            
        }
    }
    
    
    @objc func btnAddMoreTableTapped(){
        
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddTableVC") as? AddTableVC
        self.navigationController?.pushViewController(settingsVCId!, animated: false)
    }
    
    //MARK:- Open Gallery Method
    
    @objc func openGallery(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) && !pickedImage {
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
            pickedImage = true
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    @objc func EditTableWithImageWebService(){
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! AddTableTableViewCell
        
        //Set Your URL
        let api_url = APPLICATION_BASE_URL
        guard let url = URL(string: api_url) else {
            return
        }
        
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            let clubName = person["fullName"] as! String
            
            //Set Your Parameter
            let parameterDict = NSMutableDictionary()
            parameterDict.setValue("edittable", forKey: "action")
            parameterDict.setValue(myString, forKey: "userId")
            parameterDict.setValue(String(cell.txtTableNumber.text!), forKey: "name")
            parameterDict.setValue(String(cell.txtTotaaSeat.text!), forKey: "totalSeat")
            parameterDict.setValue(String(cell.txtPrice.text!), forKey: "seatPrice")
            parameterDict.setValue(String(clubTableId), forKey: "clubTableId")
            parameterDict.setValue(String(cell.txt_view_about.text!), forKey: "about")
            
            print(parameterDict as Any)
            
            //Set Image Data
            let imgData = cell.imgUpload.image!.jpegData(compressionQuality: 0.5)!
            
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
                multiPart.append(imgData, withName: "image", fileName: "file.png", mimeType: "image/png")
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
                        
                        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NPManageTable") as? NPManageTable
                        self.navigationController?.pushViewController(settingsVCId!, animated: false)
                    }
                    catch {
                        // catch error.
                        print("catch error")
                        
                    }
                    break
                    
                case .failure(_):
                    print("failure")
                    
                    break
                    
                }
                
                
            })
            
        }
        
    }
    
    
    @objc func AddTableWithImageWebService(){
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        
        let cell = self.tablView.cellForRow(at: indexPath) as! AddTableTableViewCell
        
        //Set Your URL
        let api_url = APPLICATION_BASE_URL
        guard let url = URL(string: api_url) else {
            return
        }
        
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            let clubName = person["fullName"] as! String
            
            //Set Your Parameter
            let parameterDict = NSMutableDictionary()
            parameterDict.setValue("addtable", forKey: "action")
            parameterDict.setValue(myString, forKey: "userId")
            parameterDict.setValue(String(cell.txtTableNumber.text!), forKey: "name")
            parameterDict.setValue(String(cell.txtTotaaSeat.text!), forKey: "totalSeat")
            parameterDict.setValue(String(cell.txtPrice.text!), forKey: "seatPrice")
            parameterDict.setValue(String(cell.txt_view_about.text!), forKey: "description")
            parameterDict.setValue(String(self.str_selected_percentage), forKey: "advancePercentage")
            
            //  parameterDict.setValue(clubName, forKey: "name")
            
            print(parameterDict as Any)
            
            //Set Image Data
            let imgData = cell.imgUpload.image!.jpegData(compressionQuality: 0.5)!
            
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
                multiPart.append(imgData, withName: "image", fileName: "file.png", mimeType: "image/png")
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
                        
                        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NPManageTable") as? NPManageTable
                        self.navigationController?.pushViewController(settingsVCId!, animated: false)
                    }
                    catch {
                        // catch error.
                        print("catch error")
                        
                    }
                    break
                    
                case .failure(_):
                    print("failure")
                    
                    break
                    
                }
                
                
            })
            
        }
        
    }
    
    // MARK: - ADD TABLE CLICK METHOD -
    @objc func add_table_click_method() {
        
        self.open_camera_gallery_popup()
    }
    
    // MARK: - OPEN CAMERA GALLERY POPUP -
    @objc func open_camera_gallery_popup () {
        
        let actionSheet = NewYorkAlertController(title: "Please select", message: nil, style: .actionSheet)
        
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
        
        
        
        self.str_upload_image_on_table_Status = "1"
        
        let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        let cropper = CropperViewController(originalImage: image_data!)
        
        cropper.delegate = self
        
        picker.dismiss(animated: true) {
            self.present(cropper, animated: true, completion: nil)
            
        }
        
        /*cell.img_table_image.image = image_data // show image on profile
        let imageData:Data = image_data!.pngData()!
        imageStr1 = imageData.base64EncodedString()
        self.dismiss(animated: true, completion: nil)
        imgData1 = image_data!.jpegData(compressionQuality: 0.2)!*/
        
    }
    
    func cropperDidConfirm(_ cropper: CropperViewController, state: CropperState?) {
        cropper.dismiss(animated: true, completion: nil)
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! AddTableTableViewCell
        
        if let state = state,
           let image = cropper.originalImage.cropped(withCropperState: state) {
            cell.img_table_image.image = image
            
            let imageData:Data = image.pngData()!
            
            self.imgData1 = imageData
            
        } else {
            print("Something went wrong")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - VALIDATION BEFORE ADD TABLE -
    @objc func validation_before_add_Table() {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! AddTableTableViewCell
        
        if String(cell.txtTableNumber.text!) == "" {
            
            self.promt_value(str_name: "Table Name/Number")
            
        } else if String(cell.txtTotaaSeat.text!) == "" {
            
            self.promt_value(str_name: "Total Seat")
            
        } else if String(cell.txtPrice.text!) == "" {
            
            self.promt_value(str_name: "Price")
            
        } else if String(cell.txt_view_about.text!) == "" {
            
            self.promt_value(str_name: "About")
            
        } else {
            
            if self.str_upload_image_on_table_Status == "1" {
                
                self.add_table_with_image_wb()
                
            } else {
                
                if self.str_edit_table_Status == "yes" {
                    
                    self.add_table_without_image()
                    
                } else {
                    
                    self.edit_table_without_image()
                    
                }
                
            }
            
            
        }
        
    }
    
    @objc func promt_value(str_name:String) {
        
        let alert = NewYorkAlertController(title: String("Alert"), message: String(str_name)+" should not be empty", style: .alert)
        
        alert.addImage(UIImage.gif(name: "gif_alert"))
        
        let cancel = NewYorkButton(title: "Ok", style: .cancel)
        alert.addButtons([cancel])
        
        self.present(alert, animated: true)
        
    }
    
    // MARK: - ADD TABLE WB -
    @objc func add_table_with_image_wb() {
        
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
            
            let indexPath = IndexPath.init(row: 0, section: 0)
            let cell = self.tablView.cellForRow(at: indexPath) as! AddTableTableViewCell
            
            //Set Your Parameter
            let parameterDict = NSMutableDictionary()
            
            if self.str_edit_table_Status == "yes" {
                
                parameterDict.setValue("addtable", forKey: "action")
                parameterDict.setValue(String(cell.txt_view_about.text!), forKey: "description")
                
            } else {
                
                let x : Int = self.dict_get_table_data["clubTableId"] as! Int
                let myString = String(x)
                parameterDict.setValue("edittable", forKey: "action")
                parameterDict.setValue(String(myString), forKey: "clubTableId")
                parameterDict.setValue(String(cell.txt_view_about.text!), forKey: "about")
            }
            
            parameterDict.setValue(String(myString), forKey: "userId")
            
            parameterDict.setValue(String(cell.txtTableNumber.text!), forKey: "name")
            parameterDict.setValue(String(cell.txtTotaaSeat.text!), forKey: "totalSeat")
            parameterDict.setValue(String(cell.txtPrice.text!), forKey: "seatPrice")
            
            parameterDict.setValue(String(self.str_selected_percentage), forKey: "advancePercentage")
            
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
                
                if self.str_edit_table_Status == "yes" {
                    multiPart.append(self.imgData1, withName: "image", fileName: "add_table.png", mimeType: "image/png")
                } else {
                    multiPart.append(self.imgData1, withName: "image", fileName: "edit_table.png", mimeType: "image/png")
                }
                
                
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
                        
                        /*var dict: Dictionary<AnyHashable, Any>
                         dict = dictionary["data"] as! Dictionary<AnyHashable, Any>
                         
                         let defaults = UserDefaults.standard
                         defaults.setValue(dict, forKey: "keyLoginFullData")*/
                        ERProgressHud.sharedInstance.hide()
                        
                        if self.str_edit_table_Status == "yes" {
                            
                            var strSuccess2 : String!
                            strSuccess2 = dictionary["msg"]as Any as? String
                            
                            let alert = NewYorkAlertController(title: "Success", message: String(strSuccess2), style: .alert)
                            
                            alert.addImage(UIImage.gif(name: "success3"))
                            
                            let add_more_table = NewYorkButton(title: "Add more tables", style: .default) { _ in
                                
                                cell.img_table_image.image = UIImage(named: "logo")
                                
                                self.str_upload_image_on_table_Status = "0"
                                
                                self.imgData1 = nil
                                self.imageStr1 = ""
                                
                                
                                cell.txtTableNumber.text = ""
                                cell.txtTotaaSeat.text = ""
                                cell.txtPrice.text = ""
                                cell.txt_view_about.text = ""
                                
                            }
                            
                            let dismiss = NewYorkButton(title: "Dismiss", style: .cancel) { _ in
                                
                                self.navigationController?.popViewController(animated: true)
                            }
                            
                            alert.addButtons([add_more_table , dismiss])
                            
                            self.present(alert, animated: true)
                            
                        } else {
                            
                            var strSuccess2 : String!
                            strSuccess2 = dictionary["msg"]as Any as? String
                            
                            
                            let alert = NewYorkAlertController(title: "Success", message: String(strSuccess2), style: .alert)
                            
                            alert.addImage(UIImage.gif(name: "success3"))
                            
                            let dismiss = NewYorkButton(title: "Dismiss", style: .cancel)
                            
                            alert.addButtons([dismiss])
                            
                            self.present(alert, animated: true)
                            
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
    
    
    
    // MARK: - ADD TABLE WITHOUT IMAGE -
    @objc func add_table_without_image() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! AddTableTableViewCell
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // let str:String = person["role"] as! String
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params = add_table_from_club(action: "addtable",
                                             userId: String(myString),
                                             name: String(cell.txtTableNumber.text!),
                                             totalSeat: String(cell.txtTotaaSeat.text!),
                                             seatPrice: String(cell.txtPrice.text!),
                                             description: String(cell.txt_view_about.text!),
                                             advancePercentage:String(self.str_selected_percentage))
            
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
                        
                        if self.str_edit_table_Status == "yes" {
                            
                            let alert = NewYorkAlertController(title: "Success", message: String(strSuccess2), style: .alert)
                            
                            alert.addImage(UIImage.gif(name: "success3"))
                            
                            let add_more_table = NewYorkButton(title: "Add more tables", style: .default) { _ in
                                
                                self.str_upload_image_on_table_Status = "0"
                                
                                self.imgData1 = nil
                                self.imageStr1 = ""
                                
                                
                                cell.txtTableNumber.text = ""
                                cell.txtTotaaSeat.text = ""
                                cell.txtPrice.text = ""
                                cell.txt_view_about.text = ""
                                
                            }
                            
                            let dismiss = NewYorkButton(title: "Dismiss", style: .cancel) { _ in
                                
                                self.navigationController?.popViewController(animated: true)
                            }
                            
                            alert.addButtons([add_more_table , dismiss])
                            
                            self.present(alert, animated: true)
                            
                        } else {
                            
                            var strSuccess2 : String!
                            strSuccess2 = JSON["msg"]as Any as? String
                            
                            
                            let alert = NewYorkAlertController(title: "Success", message: String(strSuccess2), style: .alert)
                            
                            alert.addImage(UIImage.gif(name: "success3"))
                            
                            let dismiss = NewYorkButton(title: "Dismiss", style: .cancel)
                            
                            alert.addButtons([dismiss])
                            
                            self.present(alert, animated: true)
                            
                        }
                        
                        
                        
                        
                        
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
    
    @objc func edit_table_without_image() {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! AddTableTableViewCell
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // let str:String = person["role"] as! String
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let x_2 : Int = self.dict_get_table_data["clubTableId"] as! Int
            let myString_2 = String(x_2)
            
            let params = edit_table_from_club(action: "edittable",
                                              userId: String(myString),
                                              clubTableId:String(myString_2),
                                              name: String(cell.txtTableNumber.text!),
                                              totalSeat: String(cell.txtTotaaSeat.text!),
                                              seatPrice: String(cell.txtPrice.text!),
                                              description: String(cell.txt_view_about.text!),
                                              advancePercentage:String(self.str_selected_percentage))
            
            
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
                        
                        if self.str_edit_table_Status == "yes" {
                            
                            let alert = NewYorkAlertController(title: "Success", message: String(strSuccess2), style: .alert)
                            
                            alert.addImage(UIImage.gif(name: "success3"))
                            
                            let add_more_table = NewYorkButton(title: "Add more tables", style: .default) { _ in
                                
                                self.str_upload_image_on_table_Status = "0"
                                
                                self.imgData1 = nil
                                self.imageStr1 = ""
                                
                                
                                cell.txtTableNumber.text = ""
                                cell.txtTotaaSeat.text = ""
                                cell.txtPrice.text = ""
                                cell.txt_view_about.text = ""
                                
                            }
                            
                            let dismiss = NewYorkButton(title: "Dismiss", style: .cancel) { _ in
                                
                                self.navigationController?.popViewController(animated: true)
                            }
                            
                            alert.addButtons([add_more_table , dismiss])
                            
                            self.present(alert, animated: true)
                            
                        } else {
                            
                            var strSuccess2 : String!
                            strSuccess2 = JSON["msg"]as Any as? String
                            
                            
                            let alert = NewYorkAlertController(title: "Success", message: String(strSuccess2), style: .alert)
                            
                            alert.addImage(UIImage.gif(name: "success3"))
                            
                            let dismiss = NewYorkButton(title: "Dismiss", style: .cancel)
                            
                            alert.addButtons([dismiss])
                            
                            self.present(alert, animated: true)
                            
                        }
                        
                        
                        
                        
                        
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
    
    
    // MARK: - SUNDAY FROM -
    func textFieldDidBeginEditing(_ textField: UITextField) {
        /*let indexPath = IndexPath.init(row: 0, section: 0)
         let cell = self.tablView.cellForRow(at: indexPath) as! AddTableTableViewCell
         
         
         if textField.tag == 100 {
         
         self.view.endEditing(true)
         let dummyList = ["10" , "20" , "30" , "40" , "50" , "60" , "70" , "80"]
         RPicker.selectOption(title: "Advance ( % )", cancelText: "Cancel", dataArray: dummyList, selectedIndex: 0) {[] (selctedText, atIndex) in
         
         cell.txt_advance_percentage.text = "\(selctedText)%"
         
         self.str_selected_percentage = "\(selctedText)"
         }
         
         } else {
         
         }*/
        
        
    }
    
    @objc func btn_advance_percentage_click_method() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! AddTableTableViewCell
        self.view.endEditing(true)
        
        // let dummyList = ["20" , "30" , "40" , "50" , "60" , "70" , "80"]
        
        let dummyList = ["20"]
        
        RPicker.selectOption(title: "Advance ( % )", cancelText: "Cancel", dataArray: dummyList, selectedIndex: 0) {[] (selctedText, atIndex) in
            
            cell.txt_advance_percentage.text = "\(selctedText)%"
            
            self.str_selected_percentage = "\(selctedText)"
        }
        
    }
    
}


//MARK:- TABLE VIEW -
extension AddTableVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:AddTableTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AddTableCell") as! AddTableTableViewCell
        
        cell.backgroundColor = APP_BASIC_COLOR
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        /*cell.txtTableNumber.delegate = self
         cell.txtTotaaSeat.delegate = self
         cell.txtPrice.delegate = self
         cell.txt_advance_percentage.delegate = self*/
        
        cell.btn_advance_percentage.addTarget(self, action: #selector(btn_advance_percentage_click_method), for: .touchUpInside)
        
        // server value
        if self.dict_get_table_data != nil {
            
            cell.txtTableNumber.text    = (dict_get_table_data["name"] as! String)
            cell.txtTotaaSeat.text      = "\(dict_get_table_data["totalSeat"]!)"
            cell.txtPrice.text          = "\(dict_get_table_data["seatPrice"]!)"
            cell.txt_view_about.text    = "\(dict_get_table_data["description"]!)"
            cell.txt_advance_percentage.text    = "\(dict_get_table_data["advancePercentage"]!)%"
            
            self.str_selected_percentage = "\(dict_get_table_data["advancePercentage"]!)"
            
            cell.img_table_image.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
            cell.img_table_image.sd_setImage(with: URL(string: (dict_get_table_data["image"] as! String)), placeholderImage: UIImage(named: "logo"))
            
        }
        
        // image logo
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(add_table_click_method))
        cell.img_table_image.isUserInteractionEnabled = true
        cell.img_table_image.addGestureRecognizer(tapGestureRecognizer1)
        
        
        
        // cell.btnUploadImg.addTarget(self, action: #selector(openGallery), for: .touchUpInside)
        // cell.btnAddTable.addTarget(self, action: #selector(btnAddMoreTableTapped), for: .touchUpInside)
        
        // cell.btnUploadImg.addTarget(self, action: #selector(add_table_click_method), for: .touchUpInside)
        
        if self.str_edit_table_Status == "yes" {
            
            lblNavigationTitle.text = "Add Table"
            cell.btnSave.setTitle("Add", for: .normal)
            
            
        } else {
            
            lblNavigationTitle.text = "Edit Table"
            cell.btnSave.setTitle("Update", for: .normal)
            
        }
        
        cell.btnSave.addTarget(self, action: #selector(validation_before_add_Table), for: .touchUpInside)
        
        /*if btnEditTappedStr == "EditBtnTapped" {
         
         cell.txtPrice.text = seatPrice
         cell.txtTableNumber.text = tableName
         cell.txtTotaaSeat.text = tableTotalSeat
         
         cell.btnSave.setTitle("EDIT & CONTINUE", for: .normal)
         cell.btnAddTable.isHidden = true
         cell.btnSkip.isHidden = true
         
         }*/
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1000
    }
    
    
}

extension AddTableVC: UITableViewDelegate {
    
}
