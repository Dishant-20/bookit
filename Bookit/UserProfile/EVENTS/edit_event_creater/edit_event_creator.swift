//
//  edit_event_creator.swift
//  Bookit
//
//  Created by Apple on 09/03/22.
//

import UIKit
import Alamofire
import SDWebImage

import QCropper

class edit_event_creator: UIViewController , UINavigationControllerDelegate , UIImagePickerControllerDelegate , CropperViewControllerDelegate {

    var strPassImgString:String!
    var imageStr:String!
    var imgData:Data! = nil
    
    var dict_get_event_details:NSDictionary!
    
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
                lblNavigationTitle.text = "Edit event"
                lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
                lblNavigationTitle.backgroundColor = .clear
            }
        }
                    
    // ***************************************************************** // nav
    
    
    @IBOutlet weak var tablView:UITableView!{
        didSet {
            tablView.delegate = self
            tablView.dataSource = self
            tablView.backgroundColor =  .clear
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        self.btnBack.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        
        
        
    }
    
    @objc func back_click_method() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    @objc func cellTappedMethod(_ sender:AnyObject){
        print("you tap image number: \(sender.view.tag)")
        
        let actionSheet = NewYorkAlertController(title: "Upload profile picture", message: nil, style: .actionSheet)
        
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
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
         let indexPath = IndexPath.init(row: 0, section: 0)
         let cell = self.tablView.cellForRow(at: indexPath) as! edit_event_creator_table_cell
        
        cell.img_event_image.isHidden = false
        
        let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        let cropper = CropperViewController(originalImage: image_data!)
        
        cropper.delegate = self
        
        picker.dismiss(animated: true) {
            self.present(cropper, animated: true, completion: nil)
            
        }
        
        /*cell.img_event_image.image = image_data // show image on profile
        let imageData:Data = image_data!.pngData()!
        imageStr = imageData.base64EncodedString()
        self.dismiss(animated: true, completion: nil)
        imgData = image_data!.jpegData(compressionQuality: 0.2)!*/
        //print(type(of: imgData)) // data
        
        self.strPassImgString = "1"
        
        // self.uploadWithImage()
    }
    
    func cropperDidConfirm(_ cropper: CropperViewController, state: CropperState?) {
        cropper.dismiss(animated: true, completion: nil)
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! edit_event_creator_table_cell
        
        if let state = state,
           let image = cropper.originalImage.cropped(withCropperState: state) {
            cell.img_event_image.image = image
            
            let imageData:Data = image.pngData()!
            
            self.imgData = imageData
            
        } else {
            print("Something went wrong")
        }
        self.dismiss(animated: true, completion: nil)
    }
    

    @objc func create_an_event_wb() {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! edit_event_creator_table_cell
        
        if cell.txt_event_name.text == "" {
            
            let alert = NewYorkAlertController(title: String("Alert"), message: String("Event name should not be empty"), style: .alert)
            
            alert.addImage(UIImage.gif(name: "gif_alert"))
            
            let cancel = NewYorkButton(title: "Ok", style: .cancel)
            alert.addButtons([cancel])
            
            self.present(alert, animated: true)
            
        } else if cell.txt_event_timing_to.text == "" {
            
            let alert = NewYorkAlertController(title: String("Alert"), message: String("Event timing to should not be empty"), style: .alert)
            
            alert.addImage(UIImage.gif(name: "gif_alert"))
            
            let cancel = NewYorkButton(title: "Ok", style: .cancel)
            alert.addButtons([cancel])
            
            self.present(alert, animated: true)
            
        } else if cell.txt_event_timing_from.text == "" {
            
            let alert = NewYorkAlertController(title: String("Alert"), message: String("Event timing from should not be empty"), style: .alert)
            
            alert.addImage(UIImage.gif(name: "gif_alert"))
            
            let cancel = NewYorkButton(title: "Ok", style: .cancel)
            alert.addButtons([cancel])
            
            self.present(alert, animated: true)
            
        } else if cell.txt_event_description.text == "" {
            
            let alert = NewYorkAlertController(title: String("Alert"), message: String("Description should not be empty"), style: .alert)
            
            alert.addImage(UIImage.gif(name: "gif_alert"))
            
            let cancel = NewYorkButton(title: "Ok", style: .cancel)
            alert.addButtons([cancel])
            
            self.present(alert, animated: true)
            
        } else if self.imgData == nil {
            
            self.edit_event_without_image()
            
        } else {
            self.validation_before_create_event()
        }
        
        
    }
    
    @objc func edit_event_without_image() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! edit_event_creator_table_cell
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "please wait...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // let str:String = person["role"] as! String
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
        let params = edit_an_event(action: "addevent",
                                   eventId: "\(self.dict_get_event_details["eventId"]!)",
                                   clubId: String(myString),
                                   eventName: String(cell.txt_event_name.text!),
                                   EventDate: (self.dict_get_event_details["EventDate"] as! String),
                                   EventTimeFrom: String(cell.txt_event_timing_from.text!),
                                   EventTimeTo: String(cell.txt_event_timing_to.text!),
                                   EventDescription: String(cell.txt_event_description.text!)
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
                    
                    let alert = NewYorkAlertController(title: "Success", message: String(strSuccess2), style: .alert)
                    
                    alert.addImage(UIImage.gif(name: "success3"))
                    
                    let cancel = NewYorkButton(title: "Ok", style: .cancel) {
                        _ in
                        
                        self.back_click_method()
                        
                    }
                    alert.addButtons([cancel])
                    
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
         }
    }
    
    @objc func validation_before_create_event() {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! edit_event_creator_table_cell
        
        
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
            
            //Set Your Parameter
            let parameterDict = NSMutableDictionary()
            parameterDict.setValue("addevent", forKey: "action")
            parameterDict.setValue("\(self.dict_get_event_details["eventId"]!)", forKey: "eventId")
            parameterDict.setValue(String(myString), forKey: "clubId")
            parameterDict.setValue(String(cell.txt_event_name.text!), forKey: "eventName")
            
            parameterDict.setValue((self.dict_get_event_details["EventDate"] as! String), forKey: "EventDate")
            
            parameterDict.setValue(String(cell.txt_event_timing_from.text!), forKey: "EventTimeFrom")
            parameterDict.setValue(String(cell.txt_event_timing_to.text!), forKey: "EventTimeTo")
            parameterDict.setValue(String(cell.txt_event_description.text!), forKey: "EventDescription")
            
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
                multiPart.append(self.imgData, withName: "Eventimage", fileName: "bookit_edited_event.png", mimeType: "image/png")
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
                            
                                
                                var strSuccess2 : String!
                                strSuccess2 = dictionary["msg"]as Any as? String
                                
                                let alert = NewYorkAlertController(title: "Success", message: String(strSuccess2), style: .alert)
                                
                                alert.addImage(UIImage.gif(name: "success3"))
                                
                            let cancel = NewYorkButton(title: "Ok", style: .cancel) {
                                _ in
                                
                                self.back_click_method()
                                
                            }
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
                        print(data.result)
                        ERProgressHud.sharedInstance.hide()
                        break
                        
                    }
                    
                    
                })
            
        }
        
        
    }
    
    
    
    
    
}


//MARK:- TABLE VIEW -
extension edit_event_creator: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:edit_event_creator_table_cell = tableView.dequeueReusableCell(withIdentifier: "edit_event_creator_table_cell") as! edit_event_creator_table_cell
        
        cell.backgroundColor = .clear
      
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        // print(self.dict_get_event_details as Any)
        
        /*
         EventDate = "2022-03-10";
         EventDescription = "";
         EventTimeFrom = "04:08 PM";
         EventTimeTo = "04:08 PM";
         Eventimage = "";
         address = "";
         clubId = 72;
         created = "2022-03-09 16:08:00";
         eventId = 3;
         eventName = event;
         status = 1;
         */
        
        cell.txt_event_name.text = (self.dict_get_event_details["eventName"] as! String)
        cell.txt_event_timing_to.text = (self.dict_get_event_details["EventTimeTo"] as! String)
        cell.txt_event_timing_from.text = (self.dict_get_event_details["EventTimeFrom"] as! String)
        cell.txt_event_description.text = (self.dict_get_event_details["EventDescription"] as! String)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date_set = dateFormatter.date(from: (self.dict_get_event_details["EventDate"] as! String))
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let resultString = dateFormatter.string(from: date_set!)
        
        cell.lbl_selected_date.text = "Event date : "+resultString
        cell.lbl_selected_date.textAlignment = .center
        
        cell.btn_time_from.addTarget(self, action: #selector(btn_time_from_click_method), for: .touchUpInside)
        cell.btn_time_to.addTarget(self, action: #selector(btn_time_to_click_method), for: .touchUpInside)
        
         cell.btn_save_continue.addTarget(self, action: #selector(create_an_event_wb), for: .touchUpInside)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(REditProfile.cellTappedMethod(_:)))
        
        cell.img_event_image.isUserInteractionEnabled = true
        cell.img_event_image.addGestureRecognizer(tapGestureRecognizer)
        
        cell.img_event_image.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
        cell.img_event_image.sd_setImage(with: URL(string: (self.dict_get_event_details["Eventimage"] as! String)), placeholderImage: UIImage(named: "logo"))
        
        return cell
    }

    @objc func btn_time_to_click_method() {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! edit_event_creator_table_cell
        
        // Simple Time Picker
        RPicker.selectDate(title: "To", cancelText: "Cancel", datePickerMode: .time, didSelectDate: { [](selectedDate) in
            // TODO: Your implementation for date
            cell.txt_event_timing_to.text = selectedDate.dateString("hh:mm a")
            
         })
        
    }
    
    @objc func btn_time_from_click_method() {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! edit_event_creator_table_cell
        
        // Simple Time Picker
        RPicker.selectDate(title: "From", cancelText: "Cancel", datePickerMode: .time, didSelectDate: { [](selectedDate) in
            // TODO: Your implementation for date
            cell.txt_event_timing_from.text = selectedDate.dateString("hh:mm a")
            
         })
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1000
    }
    
}

class edit_event_creator_table_cell : UITableViewCell {
 
    @IBOutlet weak var txt_event_name:UITextField! {
        didSet {
            txt_event_name.setLeftPaddingPoints(20)
            txt_event_name.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            txt_event_name.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            txt_event_name.layer.shadowOpacity = 1.0
            txt_event_name.layer.shadowRadius = 15.0
            txt_event_name.layer.masksToBounds = false
            txt_event_name.layer.cornerRadius = 15
            txt_event_name.backgroundColor = .white
            txt_event_name.isUserInteractionEnabled = true
            txt_event_name.textColor = .black
        }
    }
    
    @IBOutlet weak var txt_event_description:UITextView! {
        didSet {
            txt_event_description.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            txt_event_description.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            txt_event_description.layer.shadowOpacity = 1.0
            txt_event_description.layer.shadowRadius = 15.0
            txt_event_description.layer.masksToBounds = true
            txt_event_description.layer.cornerRadius = 15
            txt_event_description.backgroundColor = .white
            txt_event_description.isUserInteractionEnabled = true
            txt_event_description.text = ""
            txt_event_description.layer.borderColor = UIColor.lightGray.cgColor
            txt_event_description.layer.borderWidth = 0.8
            txt_event_description.textColor = .black
        }
    }
    
    @IBOutlet weak var txt_event_timing_to:UITextField! {
        didSet {
            txt_event_timing_to.setLeftPaddingPoints(20)
            txt_event_timing_to.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            txt_event_timing_to.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            txt_event_timing_to.layer.shadowOpacity = 1.0
            txt_event_timing_to.layer.shadowRadius = 15.0
            txt_event_timing_to.layer.masksToBounds = false
            txt_event_timing_to.layer.cornerRadius = 15
            txt_event_timing_to.backgroundColor = .white
            txt_event_timing_to.isUserInteractionEnabled = false
            txt_event_timing_to.textColor = .black
        }
    }
    
    @IBOutlet weak var txt_event_timing_from:UITextField! {
        didSet {
            txt_event_timing_from.setLeftPaddingPoints(20)
            txt_event_timing_from.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            txt_event_timing_from.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            txt_event_timing_from.layer.shadowOpacity = 1.0
            txt_event_timing_from.layer.shadowRadius = 15.0
            txt_event_timing_from.layer.masksToBounds = false
            txt_event_timing_from.layer.cornerRadius = 15
            txt_event_timing_from.backgroundColor = .white
            txt_event_timing_from.isUserInteractionEnabled = false
            txt_event_timing_from.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_selected_date:UILabel! {
        didSet {
            lbl_selected_date.textColor = .black
        }
    }
    
    @IBOutlet weak var btn_time_to:UIButton!
    @IBOutlet weak var btn_time_from:UIButton!
    
    @IBOutlet weak var btn_save_continue:UIButton! {
        didSet {
            btn_save_continue.backgroundColor = BUTTON_DARK_APP_COLOR
            btn_save_continue.tintColor = .white
            btn_save_continue.setTitle("Update", for: .normal)
            btn_save_continue.layer.cornerRadius = 10.0
            btn_save_continue.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var img_event_image:UIImageView! {
        didSet {
            img_event_image.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            img_event_image.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            img_event_image.layer.shadowOpacity = 1.0
            img_event_image.layer.shadowRadius = 15.0
            img_event_image.layer.masksToBounds = false
            img_event_image.layer.cornerRadius = 15
            img_event_image.backgroundColor = .white
            img_event_image.isUserInteractionEnabled = false
        }
    }
}
