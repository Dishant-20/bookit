//
//  payment_options.swift
//  Bookit
//
//  Created by Apple on 01/06/22.
//

// fyun-ldus-wmds-pzuz-hxep

import UIKit
import Alamofire

class payment_options: UIViewController {
    
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
            lblNavigationTitle.text = "Payment options"
        }
    }
    
    // ***************************************************************** // nav
    
    var str_payment_options:String! = "0"
    
    var arr_choose_payment:NSMutableArray! = []
    
    var is_your_wired_transfer_active:String! =  "(Take 3-4 days to transfer after request)"
    var is_your_stripe_account_is_active:String! =  "(Directly transfer to your Stripe account)"
    
    var timer: Timer?
    
    @IBOutlet weak var tablView:UITableView! {
        didSet {
            tablView.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var btn_update:UIButton! {
        didSet {
            Utils.button_ui(button: btn_update ,
                            button_text : "Update" ,
                            button_bg_color:.systemOrange ,
                            button_text_color:.white)
            btn_update.layer.cornerRadius = 0
            btn_update.clipsToBounds = true
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        self.tablView.separatorColor = .white
        
        self.btnBack.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        self.btn_update.addTarget(self, action: #selector(update_click_method), for: .touchUpInside)
        
        // self.cheque_stripe_account_is_active_or_not()
        
        self.create_custom_dict()
        
    }
    
    @objc func update_click_method() {
        
        if self.str_payment_options == "0" {
            
        } else if self.str_payment_options == "WIRED" {
            
            print("wired transfer activated")
            self.edit_stripe_Status(str_loader_show: "yes")
            
        } else {
            
            self.refresh_profile()
            
        }
        
    }
    
    @objc func create_custom_dict() {
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            print(person as Any)
            
            if (person["currentPaymentOption"] as! String) == "WIRED" {
                
                self.str_payment_options = "WIRED"
                
                print("yes, my stripe account number is zero")
                
                for indexx in 0..<2 {
                    
                    if indexx == 0 {
                        
                        let custom_dict = ["name"   : "Wired Transfer",
                                           "sub_title"  : String(self.is_your_wired_transfer_active),
                                           "status"  : "yes"]
                        
                        self.arr_choose_payment.add(custom_dict)
                        
                    } else {
                        
                        let custom_dict = ["name"    : "Stripe Payment",
                                           "sub_title"  : String(self.is_your_stripe_account_is_active),
                                           "status"  : "no"]
                        
                        self.arr_choose_payment.add(custom_dict)
                        
                    }
                    
                    
                }
                
            } else if (person["currentPaymentOption"] as! String) == "STRIPE" {
                
                self.str_payment_options = "STRIPE"
                
                for indexx in 0..<2 {
                    
                    if indexx == 0 {
                        
                        let custom_dict = ["name"   : "Wired Transfer",
                                           "sub_title"  : String(self.is_your_wired_transfer_active),
                                           "status"  : "no"]
                        
                        self.arr_choose_payment.add(custom_dict)
                        
                    } else {
                        
                        let custom_dict = ["name"    : "Stripe Payment",
                                           "sub_title"  : String(self.is_your_stripe_account_is_active),
                                           "status"  : "yes"]
                        
                        self.arr_choose_payment.add(custom_dict)
                        
                    }
                    
                    
                }
                
                self.refresh_profile()
                
            } else {
                
                self.str_payment_options = "0"
                
                for indexx in 0..<2 {
                    
                    if indexx == 0 {
                        
                        let custom_dict = ["name"   : "Wired Transfer",
                                           "sub_title"  : String(self.is_your_wired_transfer_active),
                                           "status"  : "no"]
                        
                        self.arr_choose_payment.add(custom_dict)
                        
                    } else {
                        
                        let custom_dict = ["name"    : "Stripe Payment",
                                           "sub_title"  : String(self.is_your_stripe_account_is_active),
                                           "status"  : "no"]
                        
                        self.arr_choose_payment.add(custom_dict)
                        
                    }
                    
                    
                }
                
            }
            
            
        }
        
        
        
        tablView.delegate = self
        tablView.dataSource = self
        tablView.reloadData()
        
    }
    
    @objc func appMovedToBackground() {
        print("App moved to foreground!")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            print(person as Any)
            
            if (person["stripeAccountNo"] as! String) == "" {
                
                print("yes, my stripe account number is zero")
                
                timer = Timer.scheduledTimer(timeInterval: 1.0,
                                             target: self,
                                             selector: #selector(eventWith(timer:)),
                                             userInfo: [ "foo" : "bar" ],
                                             repeats: true)
                
            } else {
                
                print("yes, your stripe account is active")
                
                timer = Timer.scheduledTimer(timeInterval: 1.0,
                                             target: self,
                                             selector: #selector(eventWith(timer:)),
                                             userInfo: [ "foo" : "bar" ],
                                             repeats: true)
                
            }
            
        }
        
    }
    
    @objc func eventWith(timer: Timer!) {
        let info = timer.userInfo as Any
        print(info)
        
        timer.invalidate()
        self.refresh_profile()
        
    }
    
    @objc func back_click_method() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func refresh_profile() {
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        // self.arr_mut_dashboard_Data.removeAllObjects()
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            print(person as Any)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params = check_profile_status(action: "profile",
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
                        
                        // ERProgressHud.sharedInstance.hide()
                        
                        // self.customer_dashboard_wb()
                        
                        var dict: Dictionary<AnyHashable, Any>
                        dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                        
                        let defaults = UserDefaults.standard
                        defaults.setValue(dict, forKey: "keyLoginFullData")
                        
                        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
                            print(person as Any)
                            
                            if (person["stripeAccountNo"] as! String) == "" {
                                
                                self.check_stripe_registration()
                                
                            } else {
                                
                                self.check_stripe_status_wb(str_account_number: (person["stripeAccountNo"] as! String))
                            }
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
    
    @objc func check_stripe_registration() {
        
        self.view.endEditing(true)
        // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
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
                            
                            let alert = NewYorkAlertController(title: "Stripe account", message: String("You did not setup your stripe account. Please setup your account."), style: .alert)
                            
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
    
    @objc func check_stripe_status_wb(str_account_number:String) {
        
        self.view.endEditing(true)
        // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        // self.arr_mut_dashboard_Data.removeAllObjects()
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            print(person as Any)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params = check_stripe_status(action: "checkstripe",
                                             userId: String(myString),
                                             Account: String(str_account_number))
            
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
                        
                        var strSuccess2 : String!
                        strSuccess2 = "\(JSON["StripeStatus"]!)"
                        
                        if strSuccess2 == "0" {
                            
                            let alert = NewYorkAlertController(title: "Stripe account", message: String("Your account is not active yet. Please complete your details to active your stripe account."), style: .alert)
                            
                            let yes_logout = NewYorkButton(title: "yes, setup", style: .destructive) {
                                _ in
                                
                                if let url = URL(string: "\(JSON["url"]!)") {
                                    UIApplication.shared.open(url)
                                }
                                
                            }
                            
                            let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                            alert.addButtons([cancel,yes_logout])
                            
                            self.present(alert, animated: true)
                            
                        } else {
                            print("everything is fine")
                            
                            self.edit_stripe_Status(str_loader_show: "no")
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
    
    @objc func edit_stripe_Status(str_loader_show:String) {
        
        if str_loader_show != "no" {
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        }
        
        self.view.endEditing(true)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            print(person as Any)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params = edit_profile_for_stipe_payment_option(action: "editprofile",
                                                               userId: String(myString),
                                                               currentPaymentOption: String(self.str_payment_options))
            
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
                        
                        /*var strSuccess2 : String!
                         strSuccess2 = JSON["msg"]as Any as? String
                         
                         let alert = NewYorkAlertController(title: "Success", message: String(strSuccess2), style: .alert)
                         
                         alert.addImage(UIImage.gif(name: "success3"))
                         
                         let cancel = NewYorkButton(title: "Ok", style: .cancel)
                         alert.addButtons([cancel])
                         
                         self.present(alert, animated: true)*/
                        
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
    
    // MARK: - CLICK HERE -
    @objc func click_here_click_method() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "bank_details_id")
        self.navigationController?.pushViewController(push, animated: true)
        
    }
    
}


//MARK:- TABLE VIEW -
extension payment_options: UITableViewDataSource , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_choose_payment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:payment_options_table_cell = tableView.dequeueReusableCell(withIdentifier: "payment_options_table_cell") as! payment_options_table_cell
        
        cell.backgroundColor = .clear
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        let item = self.arr_choose_payment[indexPath.row] as? [String:Any]
        
        cell.lbl_club_days_off_title.text = (item!["name"] as! String)
        cell.lbl_club_days_off_sub_title.text = (item!["sub_title"] as! String)
        
        if (item!["status"] as! String) == "yes" {
            
            cell.btn_check_mark.setImage(UIImage(named: "check_mark"), for: .normal)
            
        } else {
            
            cell.btn_check_mark.setImage(UIImage(named: "un_check_mark"), for: .normal)
            
        }
        
        cell.btn_click_here.addTarget(self, action: #selector(click_here_click_method), for: .touchUpInside)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = self.arr_choose_payment[indexPath.row] as? [String:Any]
        
        self.arr_choose_payment.removeAllObjects()
        
        
        for indexx in 0..<2 {
            
            if indexx == 0 {
                
                let custom_dict = ["name"   : "Wired Transfer",
                                   "sub_title"  : String(self.is_your_wired_transfer_active),
                                   "status"  : "no"]
                
                self.arr_choose_payment.add(custom_dict)
                
            } else {
                
                let custom_dict = ["name"    : "Stripe Payment",
                                   "sub_title"  : String(self.is_your_stripe_account_is_active),
                                   "status"  : "no"]
                
                self.arr_choose_payment.add(custom_dict)
                
            }
            
        }
        
        self.arr_choose_payment.removeObject(at: indexPath.row)
        
        if (item!["name"] as! String) == "Wired Transfer" {
            
            self.str_payment_options = "WIRED"
            
            let custom_dict = ["name"   : (item!["name"] as! String),
                               "sub_title"  : String(self.is_your_wired_transfer_active),
                               "status"  : "yes"]
            
            self.arr_choose_payment.insert(custom_dict, at: indexPath.row)
            
        } else {
            
            self.str_payment_options = "STRIPE"
            
            let custom_dict = ["name"   : (item!["name"] as! String),
                               "sub_title"  : String(self.is_your_stripe_account_is_active),
                               "status"  : "yes"]
            
            self.arr_choose_payment.insert(custom_dict, at: indexPath.row)
            
        }
        
        self.tablView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 140
        } else {
            return 90
        }
        
    }
    
}

class payment_options_table_cell : UITableViewCell {
    
    @IBOutlet weak var lbl_club_days_off_title:UILabel! {
        didSet {
            lbl_club_days_off_title.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_club_days_off_sub_title:UILabel! {
        didSet {
            lbl_club_days_off_sub_title.textColor = .lightGray
        }
    }
    
    @IBOutlet weak var btn_click_here:UIButton! {
        didSet {
            Utils.button_ui(button: btn_click_here ,
                            button_text : "click here",
                            button_bg_color:.clear ,
                            button_text_color:.systemBlue)
            
        }
    }
    
    @IBOutlet weak var btn_check_mark:UIButton! {
        didSet {
            Utils.button_ui(button: btn_check_mark ,
                            button_text : "" ,
                            button_bg_color:.clear ,
                            button_text_color:.clear)
            
            btn_check_mark.setImage(UIImage(named: "un_check_mark"), for: .normal)
            btn_check_mark.isUserInteractionEnabled = false
            
        }
    }
    
}
