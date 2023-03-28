//
//  customer_complete_profile.swift
//  Bookit
//
//  Created by Dishant Rajput on 28/03/23.
//

import UIKit

import Alamofire
import SDWebImage

class customer_complete_profile: UIViewController , UITextFieldDelegate {

    var str_edit_profile:String!
    
    let paddingFromLeftIs:CGFloat = 40
    
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
                lblNavigationTitle.text = "Member Inforamation"
                lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
                lblNavigationTitle.backgroundColor = .clear
            }
        }
                    
    // ***************************************************************** // nav
    
    let regularFont = UIFont.systemFont(ofSize: 16)
    let boldFont = UIFont.boldSystemFont(ofSize: 16)
    
    @IBOutlet weak var btn_country:UIButton!
    @IBOutlet weak var btn_state:UIButton!
    
    @IBOutlet weak var txt_address:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txt_address,
                              tfName: txt_address.text!,
                              tfCornerRadius: 27.5,
                              tfpadding: paddingFromLeftIs,
                              tfBorderWidth: 0.8,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Full Address")
        }
    }
    
    @IBOutlet weak var txt_country:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txt_country,
                              tfName: txt_country.text!,
                              tfCornerRadius: 27.5,
                              tfpadding: paddingFromLeftIs,
                              tfBorderWidth: 0.8,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Country")
        }
    }
    
    @IBOutlet weak var txt_state:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txt_state,
                              tfName: txt_state.text!,
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
    
    @IBOutlet weak var txt_zipcode:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txt_zipcode,
                              tfName: txt_zipcode.text!,
                              tfCornerRadius: 27.5,
                              tfpadding: paddingFromLeftIs,
                              tfBorderWidth: 0.8,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Zipcode")
        }
    }
    
    @IBOutlet weak var btn_submit:UIButton! {
        didSet {
            btn_submit.layer.cornerRadius = 27.5
            btn_submit.clipsToBounds = true
            btn_submit.setTitle("Submit", for: .normal)
            btn_submit.backgroundColor =  BUTTON_DARK_APP_COLOR
        }
    }
    
    var strSaveSelectedCountryId:String! = "0"
    // var strSaveSelectedCountryId:String! = "0"
    
    var stateListArray:NSMutableArray = []
    var countryListArray:NSMutableArray = []
    
    var myStr = ""
    var myStr2 = ""
    var countryId = ""
    
    var stateId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = APP_BASIC_COLOR
        self.navigationController?.isNavigationBarHidden = true
        
        self.txt_city.delegate = self
        self.txt_state.delegate = self
        self.txt_address.delegate = self
        self.txt_country.delegate = self
        self.txt_zipcode.delegate = self
        
        // back
        self.btnBack.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        
        self.btn_state.addTarget(self, action: #selector(state_list_wb), for: .touchUpInside)
        self.btn_country.addTarget(self, action: #selector(btnCountryPress), for: .touchUpInside)
        self.btn_submit.addTarget(self, action: #selector(validation_before_submit_member_information_click_method), for: .touchUpInside)
        
        if self.str_edit_profile == "yes" {
            
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
                
                self.txt_address.text = (person["address"] as! String)
                self.txt_city.text = (person["city"] as! String)
                
                self.txt_zipcode.text = (person["zipCode"] as! String)
                self.txt_state.text = (person["stateId"] as! String)
                self.txt_country.text = (person["countryId"] as! String)
                
            }
        }
        // web : country list
        self.countryListWebSer()
    }
    
    @objc func back_click_method() {
        self.navigationController?.popViewController(animated: true)
    }

    
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
                    
                    self.btn_country.setTitle("\(selectedValue)", for: .normal)
                    self.btn_country.setTitleColor(.clear, for: .normal)
                    
                    self.txt_country.text = "\(selectedValue)"
                    
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
                            self.txt_country.textColor = .black
                            
                            self.strSaveSelectedCountryId = String(countryId)
                            
                        }
                    }
                    
                    //
                    self.txt_state.text = ""
                    
                    
                }
                else {
                    
                    self.btn_country.setTitle("Select Country", for: .normal)
                    
                }
            },
                                           onCancel: {
                
                print("Cancelled")
            }
                                           
            )
            
            
            picker.show(withAnimation: .FromBottom)
            
            
        } else {
            // User Interface is Light
             
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
                    
                    self.btn_country.setTitle("\(selectedValue)", for: .normal)
                    self.btn_country.setTitleColor(.clear, for: .normal)
                    
                    self.txt_country.text = "\(selectedValue)"
                    
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
                            self.txt_country.textColor = .black
                            
                            self.strSaveSelectedCountryId = String(countryId)
                            
                        }
                    }
                    
                    //
                    self.txt_state.text = ""
                    
                }
                else {
                    
                    self.btn_country.setTitle("Select Country", for: .normal)
                    
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
                    
                    self.btn_country.setTitle("\(selectedValue)", for: .normal)
                    self.btn_country.setTitleColor(.clear, for: .normal)
                    
                    self.txt_state.text = "\(selectedValue)"
                    
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
                            self.txt_state.textColor = .black
                            
                            // self.strSaveSelectedCountryId = String(stateId)
                            
                        }
                    }
                    
                    
                }
                else {
                    
                    self.btn_country.setTitle("Select Country", for: .normal)
                    
                }
            },
                                           onCancel: {
                
                print("Cancelled")
            }
                                           
            )
            
            
            picker.show(withAnimation: .FromBottom)
            
        } else {
             
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
                    
                    self.btn_country.setTitle("\(selectedValue)", for: .normal)
                    self.btn_country.setTitleColor(.clear, for: .normal)
                    
                    self.txt_state.text = "\(selectedValue)"
                    
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
                            self.txt_state.textColor = .black
                            
                            // self.strSaveSelectedCountryId = String(stateId)
                            
                        }
                    }
                    
                    
                }
                else {
                    
                    self.btn_country.setTitle("Select Country", for: .normal)
                    
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
    
    @objc func validation_before_submit_member_information_click_method() {
        
        if String(self.txt_address.text!) == "" {
            
            let alert = UIAlertController(title: String("Alert").uppercased(), message: String("Address should not be empty"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            
        } else if String(self.txt_country.text!) == "" {
            
            let alert = UIAlertController(title: String("Alert").uppercased(), message: String("Country should not be empty"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            
        } else if String(self.txt_state.text!) == "" {
            
            let alert = UIAlertController(title: String("Alert").uppercased(), message: String("State should not be empty"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            
        } else if String(self.txt_city.text!) == "" {
            
            let alert = UIAlertController(title: String("Alert").uppercased(), message: String("City should not be empty"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            
        } else  if String(self.txt_zipcode.text!) == "" {
             
            let alert = UIAlertController(title: String("Alert").uppercased(), message: String("Zipcode should not be empty"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            
        } else {
            self.edit_profile_WB()
        }
    }
    
    @objc func edit_profile_WB() {
        
        self.view.endEditing(true)
        // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "checking availaibility...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
             
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params = edit_profile_for_member_information(action: "editprofile",
                                                             userId: String(myString),
                                                             address: String(self.txt_address.text!),
                                                             countryId: String(self.txt_country.text!),
                                                             stateId: String(self.txt_state.text!),
                                                              
                                                             zipCode: String(self.txt_zipcode.text!),
                                                             city: String(self.txt_city.text!))
            
            
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
                        
                        if self.str_edit_profile == "yes" {
                            
                            self.navigationController?.popViewController(animated: true)
                            
                        } else {
                            
                            let tab_bar = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "tab_bar_controller_id") as? tab_bar_controller
                            tab_bar?.selectedIndex = 0
                            self.navigationController?.pushViewController(tab_bar!, animated: false)
                            
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
}
