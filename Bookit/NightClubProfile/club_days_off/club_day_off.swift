//
//  club_day_off.swift
//  Bookit
//
//  Created by Apple on 09/05/22.
//

import UIKit
import Alamofire

class club_day_off: UIViewController {

    var arr_day = ["Mon" , "Tue" , "Wed" , "Thu" , "Fri" , "Sat" , "Sun"]
    var arr_day_full = ["Monday" , "Tuesday" , "Wednesday" , "Thursday" , "Friday" , "Saturday" , "Sunday"]
    
    var str_mon:String!
    var str_tue:String!
    var str_wed:String!
    var str_thu:String!
    var str_fri:String!
    var str_sat:String!
    var str_sun:String!
    
    var arr_mut_days_select:NSMutableArray! = []
    
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
            lblNavigationTitle.text = "Select Club Days closed"
        }
    }
    
    // ***************************************************************** // nav
    
    @IBOutlet weak var btn_update:UIButton!
    
    @IBOutlet weak var tablView:UITableView! {
        didSet {
            tablView.backgroundColor = .clear
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = APP_BASIC_COLOR
        self.navigationController?.isNavigationBarHidden = true
        self.tablView.separatorColor = .white
        
        // // self.sideBarMenuClick()
        
        // self.manage_profile()
        self.btnBack.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        self.btn_update.addTarget(self, action: #selector(update_off_days), for: .touchUpInside)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            print(person as Any)
            
            
            
            for indexx in 0..<self.arr_day.count {
                
                // print("\(self.arr_day[indexx])")
                let str_day_name = "\(self.arr_day[indexx])"
                
                if  "\(person[str_day_name]!)" == "1" {
                    
                    let custom_dict = ["name":"\(self.arr_day[indexx])",
                                       "status":"yes"]
                 
                    self.arr_mut_days_select.add(custom_dict)
                    
                } else {
                    
                    let custom_dict = ["name":"\(self.arr_day[indexx])",
                                       "status":"no"]
                 
                    self.arr_mut_days_select.add(custom_dict)
                    
                }
                
                
            }
            
            // print(self.arr_mut_days_select as Any)
            
            
            self.tablView.delegate = self
            self.tablView.dataSource = self
            self.tablView.reloadData()
            
            
            
        }
        
    }

    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    @objc func update_off_days() {
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // print(person as Any)
            
            // print((person["role"] as! String))
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            // print(self.arr_mut_days_select as Any)
            
            
            for indexx in 0..<self.arr_mut_days_select.count {
                
                let item = self.arr_mut_days_select[indexx] as? [String:Any]
                
                if indexx == 0 {
                    
                    if (item!["status"] as! String) == "yes" {
                        self.str_mon = "1"
                    } else {
                        self.str_mon = "0"
                    }
                    
                } else if indexx == 1 {
                    
                    if (item!["status"] as! String) == "yes" {
                        self.str_tue = "1"
                    } else {
                        self.str_tue = "0"
                    }
                    
                } else if indexx == 2 {
                    
                    if (item!["status"] as! String) == "yes" {
                        self.str_wed = "1"
                    } else {
                        self.str_wed = "0"
                    }
                    
                } else if indexx == 3 {
                    
                    if (item!["status"] as! String) == "yes" {
                        self.str_thu = "1"
                    } else {
                        self.str_thu = "0"
                    }
                    
                } else if indexx == 4 {
                    
                    if (item!["status"] as! String) == "yes" {
                        self.str_fri = "1"
                    } else {
                        self.str_fri = "0"
                    }
                    
                } else if indexx == 5 {
                    
                    if (item!["status"] as! String) == "yes" {
                        self.str_sat = "1"
                    } else {
                        self.str_sat = "0"
                    }
                    
                } else {
                    
                    if (item!["status"] as! String) == "yes" {
                        self.str_sun = "1"
                    } else {
                        self.str_sun = "0"
                    }
                    
                }
                
                
            }
            
            
            let params = update_club_off_day(action: "editprofile",
                                             userId: String(myString),
                                             Mon: String(self.str_mon),
                                             Tue: String(self.str_tue),
                                             Wed: String(self.str_wed),
                                             Thu: String(self.str_thu),
                                             Fri: String(self.str_fri),
                                             Sat: String(self.str_sat),
                                             Sun: String(self.str_sun))
            
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
}


//MARK:- TABLE VIEW -
extension club_day_off: UITableViewDataSource , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_mut_days_select.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:club_day_off_table_cell = tableView.dequeueReusableCell(withIdentifier: "club_day_off_table_cell") as! club_day_off_table_cell
        
        cell.backgroundColor = APP_BASIC_COLOR
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        let item = self.arr_mut_days_select[indexPath.row] as? [String:Any]
        
        cell.lbl_club_days_off_title.text = "\(self.arr_day_full[indexPath.row])"
        
        if (item!["status"] as! String) == "yes" {
            cell.btn_check_mark.setImage(UIImage(systemName: "checkmark"), for: .normal)
        } else {
            cell.btn_check_mark.setImage(UIImage(systemName: ""), for: .normal)
        }
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = self.arr_mut_days_select[indexPath.row] as? [String:Any]
        
        if (item!["status"] as! String) == "yes" {
            
            self.arr_mut_days_select.removeObject(at: indexPath.row)
            
            let custom_dict = ["name":(item!["name"] as! String),
                               "status":"no"]
            
            self.arr_mut_days_select.insert(custom_dict, at: indexPath.row)
            
        } else {
            
            self.arr_mut_days_select.removeObject(at: indexPath.row)
            
            let custom_dict = ["name":(item!["name"] as! String),
                               "status":"yes"]
            
            self.arr_mut_days_select.insert(custom_dict, at: indexPath.row)
            
        }
        
        self.tablView.reloadData()
     
        // self.arr_mut_days_select.add(custom_dict)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80

    }
    
    
}

class club_day_off_table_cell : UITableViewCell {
    
    @IBOutlet weak var lbl_club_days_off_title:UILabel! {
        didSet {
            lbl_club_days_off_title.textColor = .white
        }
    }
    
    @IBOutlet weak var btn_check_mark:UIButton!{
        didSet {
            btn_check_mark.tintColor = .systemGreen
            btn_check_mark.setImage(UIImage(systemName: "checkmark"), for: .normal)
        }
    }
    
    
}
