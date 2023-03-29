//
//  NPClubTableDetailVC.swift
//  Bookit
//
//  Created by Ranjan on 22/12/21.
//

import UIKit
import Alamofire
import SDWebImage

import PassKit
import SwiftyJSON

struct ResponseObject<T: Decodable>: Decodable {
    let form: T    // often the top level key is `data`, but in the case of https://httpbin.org, it echos the submission under the key `form`
}
/*
 "zip":"77777",
                   "country":"India",
                   "amount":"1.10",
                   "firstname":"Dishant",
                   "cvv":"999",
                   "city":"Delhi",
                   "address1":"888",
                   "type":"sale",
                   "lastname":"Rajput",
                   "security_key":"rzv73u6neV6sNdWH7r22q5WGJU3a9Q6T",
                   "phone":"8287632340",
                   "state":"Delhi",
                   "ccexp":"1025",
                   "ccnumber":"4111111111111111"
 */
struct Foo: Decodable {
     
    let zip: String
    let country: String
    let amount: Double
    let firstname: String
    let cvv: String
    let city: String
    let address1: String
    let type: String
    let lastname: String
    let security_key: String
    let phone: String
    let state: String
    let ccexp: String
    let ccnumber: String
}

class NPClubTableDetailVC: UIViewController {
    
    var dict_save_club_info_for_apple_pay:NSDictionary!
    
    var club_Details:NSDictionary!
    var get_table_id:String!
    
    var arr_mut_club_data:NSMutableArray! = []
    var arr_enlarge_table_image:NSMutableArray! = []
    
    var str_name:String!
    
    var dict_get_for_guest:NSDictionary!
    
    var str_guest_select_final_date:String!
    
    
    var payment_for_apple_pay:String!
    
    var txt_card_number = UITextField()
    var txt_exp = UITextField()
    var txt_cvv = UITextField()
    
    @IBOutlet weak var lbl_no_data_found:UILabel! {
        didSet {
            lbl_no_data_found.textColor = .black
            lbl_no_data_found.isHidden = true
            lbl_no_data_found.textAlignment = .center
            lbl_no_data_found.numberOfLines = 0
        }
    }
    
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
                lblNavigationTitle.text = "Tables"
                lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
                lblNavigationTitle.backgroundColor = .clear
            }
        }
                    
    // ***************************************************************** // nav
   
    @IBOutlet weak var tablView:UITableView! {
        didSet {
            // tablView.delegate = self
            // tablView.dataSource = self
            tablView.backgroundColor =  .clear // UIColor.init(red: 230.0/255.0, green: 212.0/255.0, blue: 196.0/255.0, alpha: 1)
        }
    }

    // 230 , 212 , 196

    @IBOutlet weak var btn_plus:UIButton! {
        didSet {
            btn_plus.tintColor = .white
            btn_plus.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.init(red: 250.0/255.0, green: 248.0/255.0, blue: 246.0/255.0, alpha: 1)
        
        self.navigationController?.isNavigationBarHidden = true
        self.tablView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        // btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        // self.view.backgroundColor = .white
        
        self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        self.btn_plus.addTarget(self, action: #selector(add_plus_click_method), for: .touchUpInside)
        
        // print(self.club_Details as Any)
        
//        let url = URL(string: "http://www.stackoverflow.com")!
//
//        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
//            guard let data = data else { return }
//            print(String(data: data, encoding: .utf8)!)
//        }
//
//        task.resume()
        
        
        /*let json: [String: Any] = ["zip":"77777",
                                   "country":"India",
                                   "amount":1.00,
                                   "firstname":"Dishant",
                                   "cvv":"999",
                                   "city":"Delhi",
                                   "address1":"888",
                                   "type":"sale",
                                   "lastname":"Rajput",
                                   "security_key":"rzv73u6neV6sNdWH7r22q5WGJU3a9Q6T",
                                   "phone":"8287632340",
                                   "state":"Delhi",
                                   "ccexp":"1025",
                                   "ccnumber":"4111111111111111",]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)
print(jsonData)
        // create post request
        let url = URL(string: "https://cwamerchantservices.transactiongateway.com/api/transact.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // insert json data to the request
        request.httpBody = jsonData
        // print(jsonData as Any)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }

        task.resume()*/
        
        
        
        
        //declare parameter as a dictionary which contains string as key and value combination.
            /*let parameters = ["zip":"77777",
                              "country":"India",
                              "amount":"1.10",
                              "firstname":"Dishant",
                              "cvv":"999",
                              "city":"Delhi",
                              "address1":"888",
                              "type":"sale",
                              "lastname":"Rajput",
                              "security_key":"rzv73u6neV6sNdWH7r22q5WGJU3a9Q6T",
                              "phone":"8287632340",
                              "state":"Delhi",
                              "ccexp":"1025",
                              "ccnumber":"4111111111111111"] as [String : Any]

            //create the url with NSURL
            let url = URL(string: "https://cwamerchantservices.transactiongateway.com/api/transact.php")!

            //create the session object
            let session = URLSession.shared

            //now create the Request object using the url object
            var request = URLRequest(url: url)
            request.httpMethod = "POST" //set http method as POST

            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to data object and set it as request body
            } catch let error {
                print(error.localizedDescription)
//                completion(nil, error)
            }

            //HTTP Headers
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")

            //create dataTask using the session object to send data to the server
            let task = session.dataTask(with: request, completionHandler: { data, response, error in

                guard error == nil else {
//                    completion(nil, error)
                    return
                }

                guard let data = data else {
//                    completion(nil, NSError(domain: "dataNilError", code: -100001, userInfo: nil))
                    return
                }

                do {
                    //create json object from data
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
//                        completion(nil, NSError(domain: "invalidJSONTypeError", code: -100009, userInfo: nil))
                        return
                    }
                    print(json)
//                    completion(json, nil)
                } catch let error {
                    print(error.localizedDescription)
//                    completion(nil, error)
                }
            })

        task.resume()*/
        
        /*let json: [String: Any] = ["zip":"77777",
                                   "country":"India",
                                   "amount":"1.10",
                                   "firstname":"Dishant",
                                   "cvv":"999",
                                   "city":"Delhi",
                                   "address1":"888",
                                   "type":"sale",
                                   "lastname":"Rajput",
                                   "security_key":"rzv73u6neV6sNdWH7r22q5WGJU3a9Q6T",
                                   "phone":"8287632340",
                                   "state":"Delhi",
                                   "ccexp":"1025",
                                   "ccnumber":"4111111111111111"]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        // create post request
        let url = URL(string: "https://cwamerchantservices.transactiongateway.com/api/transact.php/")! //PUT Your URL
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // insert json data to the request
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON) //Code after Successfull POST Request
            }
        }

        task.resume()*/
        
        
        //
        
        
        UserDefaults.standard.set("", forKey: "key_save_card_details")
        UserDefaults.standard.set(nil, forKey: "key_save_card_details")
        
        
        /*
         response=3&responsetext=CVV must be 3 or 4 digits REFID:1151386023&authcode=&transactionid=&avsresponse=&cvvresponse=&orderid=&type=sale&response_code=300
         */
        
        let str = "response=3&responsetext=CVV must be 3 or 4 digits REFID:1151386023&authcode=&transactionid=&avsresponse=&cvvresponse=&orderid=&type=sale&response_code=300"

        
        var ch = Character("&")
        var result = str.split(separator: ch)
        print("Result : \(result)")
        
        print("Result : \(result.count)")
        
        for indexx in 0..<result.count {
            
            print(result)
            print(result[0])
            
            var ch_2 = Character("=")
            var result_2 = result[0].split(separator: ch_2)
            print(result_2)
            
            if "\(result_2[1])" == "1" {
                print("all details are perfect")
                return
            } else {
                print("something went wrong")
                
                var ch_3 = Character("=")
                var result_3 = result[1].split(separator: ch_3)
                print(result_3)
                
            }
            
        }
        
        
        
        // let dict = convertToDictionary(text: str)
//        print(dict as Any)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
//        UserDefaults.standard.set("", forKey: "key_save_card_details")
//        UserDefaults.standard.set(nil, forKey: "key_save_card_details")
        
        if let payment_details = UserDefaults.standard.value(forKey: "key_save_card_details") as? [String:Any] {
            
            self.btnBack.isHidden = true
            self.lblNavigationTitle.text = "please wait..."
            
                self.payment_via_cwa(payment_to_cwa: (payment_details["card_amount"] as! String),
                                     get_card_number: (payment_details["card_number"] as! String),
                                     get_card_name: (payment_details["card_name"] as! String),
                                     get_card_cvv: (payment_details["card_cvv"] as! String),
                                     get_card_year: (payment_details["card_year"] as! String),
                                     get_card_month: (payment_details["card_month"] as! String))
           
        }
        
        self.club_table_listing_wb()
        
        // self.manage_profile()
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
    
    @objc func add_plus_click_method() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddTableVC") as? AddTableVC
        push!.str_edit_table_Status = "yes"
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    @objc func club_table_listing_wb() {
        
        self.arr_mut_club_data.removeAllObjects()
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        // let x : Int = self.club_Details["userId"] as! Int
        let myString = "\(self.club_Details["userId"]!)"
        
        
        let params = customer_table_listing(action: "tablelist",
                                            clubId: String(myString),
                                            pageNo: "")
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
                    
                    if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
                        
                        if (person["role"] as! String) == "Club" {
                            
                            self.btn_plus.isHidden = false
                            
                            if ar.count == 0 {
                                
                                
                                self.tablView.isHidden = true
                                self.lbl_no_data_found.isHidden = false
                                self.lbl_no_data_found.text = "You didn't add a table yet. Please click '+' to add table."
                                
                            } else {
                                
                                
                                self.tablView.isHidden = false
                                self.lbl_no_data_found.isHidden = true
                                
                                self.arr_mut_club_data.addObjects(from: ar as! [Any])
                                
                                self.tablView.delegate = self
                                self.tablView.dataSource = self
                                self.tablView.reloadData()
                                
                            }
                        } else {
                            // customer
                            
                            self.btn_plus.isHidden = true
                            
                            if ar.count == 0 {
                                
                                self.tablView.isHidden = true
                                self.lbl_no_data_found.isHidden = false
                                self.lbl_no_data_found.text = "No table found"
                                
                            } else {
                                
                                self.tablView.isHidden = false
                                self.lbl_no_data_found.isHidden = true
                                
                                self.arr_mut_club_data.addObjects(from: ar as! [Any])
                                
                                self.tablView.delegate = self
                                self.tablView.dataSource = self
                                self.tablView.reloadData()
                                
                            }
                            
                        }
                        
                    } else {
                        
                        // guest login show data
                        self.btn_plus.isHidden = true
                        
                        if ar.count == 0 {
                            
                            self.tablView.isHidden = true
                            self.lbl_no_data_found.isHidden = false
                            self.lbl_no_data_found.text = "No table found"
                            
                        } else {
                            
                            self.tablView.isHidden = false
                            self.lbl_no_data_found.isHidden = true
                            
                            self.arr_mut_club_data.addObjects(from: ar as! [Any])
                            
                            self.tablView.delegate = self
                            self.tablView.dataSource = self
                            self.tablView.reloadData()
                            
                        }
                        
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
        // }
    }
    
    
    
    @objc func guest_login_click_method(_ sender:UIButton) {
        
        let btn:UIButton! = sender
        print(btn.tag as Any)
        
        let item = self.arr_mut_club_data[btn.tag] as? [String:Any]
        
        self.dict_get_for_guest = item as NSDictionary?
        print(self.dict_get_for_guest as Any)
        
        let defaults = UserDefaults.standard
        // defaults.set(self.arr_only_store_ids, forKey: "key_save_aggression_development_delay_BH")
        
        let array = defaults.object(forKey: "key_save_guest_ids") as? [String] ?? [String]()
         print(array as Any)
        
        if array.count == 0 {
            
             // self.please_register_prompt()
            
            self.only_for_guest_booking(dict_get_table_data: item! as NSDictionary)
            
        } else {
            
        }
        
        
        
    }
    
    @objc func only_for_guest_booking(dict_get_table_data:NSDictionary) {
        
        print(dict_get_table_data as Any)
        
        let alert = NewYorkAlertController(title: "Book a Table", message: "Book a table for today or schedule it.", style: .alert)

        self.get_table_id = "\(dict_get_table_data["clubTableId"] as! Int)"
        
        
        let book_for_today = NewYorkButton(title: "BOOK FOR TODAY", style: .default) { _ in
            print("Tapped BOOK FOR TODAY")
            
            let date = Date().today(format: "yyyy-MM-dd")
            self.str_guest_select_final_date = "\(date)"
            print(self.str_guest_select_final_date as Any)
            
            self.direct_payment_for_guest(dict_get: self.dict_get_for_guest, str_status: "1")
            
        }
        
        let schedule_A_Date = NewYorkButton(title: "SCHEDULE A DATE", style: .default) { _ in
            print("Tapped SCHEDULE A DATE")
            
            // self.schedule_a_data(dict_get: self.dict_get_for_guest)
             self.open_schedule_a_date_for_guest(dict_get_customer_data: self.dict_get_for_guest)
            
            // self.schedule_a_data(dict_get: self.dict_get_for_guest)
            
        }
        
        book_for_today.setDynamicColor(.purple)
        schedule_A_Date.setDynamicColor(.purple)
        
        let cancel = NewYorkButton(title: "Cancel", style: .cancel)
        alert.addButtons([book_for_today,schedule_A_Date, cancel])

        present(alert, animated: true)
        
    }
    
    
    @objc func open_schedule_a_date_for_guest(dict_get_customer_data:NSDictionary) {
        
        RPicker.selectDate(title: "Select Date", didSelectDate: {[] (selectedDate) in
            // TODO: Your implementation for date
            // self?.outputLabel.text = selectedDate.dateString("MMM-dd-YYYY")
            
            self.str_guest_select_final_date = selectedDate.dateString("yyyy-MM-dd")
            
            self.direct_payment_for_guest(dict_get: dict_get_customer_data,
                                          str_status: "2")
        })
        
    }
    
    
    
    // MARK: - CHECK DATES AVAILAIBLE -
    @objc func check_availaibility_for_guest(dict_of_that_club:NSDictionary) {
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "checking availaibility...")
        
        // print(self.str_guest_select_final_date as Any)
        
        // let date = Date().today(format: "yyyy-MM-dd")

        // print(date)
        
        let params = check_dates_availaibility(action: "checkavailable",
                                               date: String(self.str_guest_select_final_date),//"\(date)",
                                               tableId: String(self.get_table_id)
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
                    strSuccess2 = JSON["Availabe"]as Any as? String
                    
                    if strSuccess2 == "No" {
                    
                        let alert = NewYorkAlertController(title: String("Alert"), message: String("This table is already booked for today. Please choose another table."), style: .alert)
                        
                        alert.addImage(UIImage.gif(name: "gif_alert"))
                        
                        let cancel = NewYorkButton(title: "Ok", style: .cancel)
                        alert.addButtons([cancel])
                        
                        self.present(alert, animated: true)
                        
                        
                    } else {
                        
                        self.please_register_prompt()
                        
                         
                        
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
        // }
    }
    
    
    @objc func please_register_prompt() {
        
        let alert = NewYorkAlertController(title: "Alert", message: String("Enter full name and email to book a table."), style: .alert)
        
        let yes_logout = NewYorkButton(title: "Enter", style: .default) {
            _ in
            
            self.open_action_sheet()
            
        }
        
        let cancel = NewYorkButton(title: "Dismiss", style: .destructive)
        alert.addButtons([cancel,yes_logout])
        
        self.present(alert, animated: true)
        
    }
    
    @objc func open_action_sheet() {
        
        let alert = NewYorkAlertController.init(title: "Register", message: "Please enter your Full name and Email address.", style: .alert)

        // alert.addImage(UIImage(named: "Image"))
        
        alert.addTextField { tf in
            tf.placeholder = "full name"
            tf.tag = 1
        }
        alert.addTextField { tf in
            tf.placeholder = "email address"
            tf.keyboardType = .emailAddress
            tf.tag = 2
        }

        let ok = NewYorkButton(title: "submit", style: .default) { [unowned alert] _ in
            alert.textFields.forEach { tf in
                let text = tf.text ?? ""
                switch tf.tag {
                case 1:
                    print("username: \(text)")
                    
                    self.str_name = "\(text)"
                    
                case 2:
                    print("password: \(text)")
                    
                    self.register_as_a_guest(str_email: "\(text)", str_full_name: String(self.str_name))
                    
                default:
                    break
                }
            }
        }
        let cancel = NewYorkButton(title: "Cancel", style: .cancel)
        
        alert.addButtons([ok, cancel])

        alert.isTapDismissalEnabled = false

        present(alert, animated: true)
        
    }
    
    @objc func register_as_a_guest(str_email:String ,
                                   str_full_name:String) {
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "please wait...")
         
        let random_password_generate = String.randomNumberGenerate()
        
        let params = guest_register(action: "registration",
                                    fullName: String(str_full_name),
                                    email: String(str_email),
                                    password: String(random_password_generate),
                                    device: "iOS",
                                    role: "Customer",
                                    deviceToken: "")
        
        
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
                    
                    self.btnBack.isHidden = true
                    
                    
                    
                    // print(self.dict_get_for_guest as Any)
                    
                    /*
                     advancePercentage = 10;
                     clubTableId = 13;
                     created = "Apr 28th, 2022, 3:08 am";
                     description = "";
                     image = "";
                     name = "Table 15 - Floor Table";
                     "profile_picture" = "";
                     seatPrice = 2000;
                     totalSeat = 6;
                     userAddress = "621 West 46th st";
                     userId = 38;
                     userName = "Harbor club ";
                     */
                    
                    let club_name = (self.dict_get_for_guest["userName"] as! String)
                    
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PaymentVC") as? PaymentVC
                    
                    let date = Date().today(format: "yyyy-MM-dd")
                    
                    if String(date) == String(self.str_guest_select_final_date) {
                        
                        print(self.str_guest_select_final_date as Any)
                        
                        push!.dict_get_table_Details = self.dict_get_for_guest
                        push!.get_club_name = club_name
                        push!.dict_get_club_details = self.club_Details
                        push!.my_payment_server_status = "yes"
                        
                    } else {
                        
                        print(self.str_guest_select_final_date as Any)
                        
                        push!.dict_get_table_Details = self.dict_get_for_guest
                         push!.get_club_name = club_name
                        push!.dict_get_club_details = self.club_Details
                        // push!.my_payment_server_status = "yes"
                        push!.str_schedule_date = String(self.str_guest_select_final_date)
                    }
                    
                    
                    self.navigationController?.pushViewController(push!, animated: true)
                    
                    
                    
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
        // }
    }
    
    
    @objc func apple_pay_in_bookit(
        str_club_name:String,str_table_name:String,str_table_price:String) {
        
            self.payment_for_apple_pay = String(str_table_price)
            // print(self.payment_for_apple_pay as Any)
            
            let paymentItem = PKPaymentSummaryItem.init(label: str_club_name+"\n"+str_table_name, amount: NSDecimalNumber(value: str_table_price.toDouble()!))
        
        // for cards
            let paymentNetworks = [PKPaymentNetwork.amex, .discover, .masterCard, .visa]
        
        // check user did payment
            if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
            
            // if user make payment
            let request = PKPaymentRequest()
            request.currencyCode = "USD" // 1
            request.countryCode = "US" // 2

                request.merchantIdentifier = merchant_id

            request.merchantCapabilities = PKMerchantCapability.capability3DS // 4
            request.supportedNetworks = paymentNetworks // 5
            request.paymentSummaryItems = [paymentItem] // 6
            
            
            guard let paymentVC = PKPaymentAuthorizationViewController(paymentRequest: request) else {
                displayDefaultAlert(title: "Error", message: "Unable to present Apple Pay authorization.")
                return
            }
            paymentVC.delegate = self
            self.present(paymentVC, animated: true, completion: nil)

        } else {
            displayDefaultAlert(title: "Error", message: "Unable to make Apple Pay transaction.")
        }
        
    }
    
    func displayDefaultAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
       let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

    @objc func payment_via_cwa(payment_to_cwa:String,
                               get_card_number:String,
                               get_card_name:String,
                               get_card_cvv:String,
                               get_card_year:String,
                               get_card_month:String
                                
    
    ) {
        
         
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            DispatchQueue.main.async {
                // send data to evs server
                ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
            }
        let myDouble = Double(payment_to_cwa)
        
        let url = URL(string: cwa_payment_URL)!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        
        let parameters: [String: Any] = [
            "zip"       : (person["zipCode"] as! String),
            "country"   : (person["countryId"] as! String),
            "amount"    : myDouble!,
            "firstname" : String(get_card_name),
            "cvv"       : String(get_card_cvv),
            "city"      : (person["city"] as! String),
            "address1"  : (person["address"] as! String),
            "type"      : "sale",
            "lastname"  : String(get_card_name),
            "security_key"  : cwa_payment_api_key,
            "phone"     : (person["contactNumber"] as! String),
            "state"     : (person["stateId"] as! String),
            "ccexp"     : String(get_card_month)+String(get_card_year),
            "ccnumber"  : String(get_card_number),
        ]
        
            print(parameters as Any)
            
        request.httpBody = parameters.percentEncoded()
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                error == nil
            else {                                                               // check for fundamental networking error
                print("error", error ?? URLError(.badServerResponse))
                return
            }
            
            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
            
            // do whatever you want with the `data`, e.g.:
            
            do {
                
                let responseObject = try JSONDecoder().decode(ResponseObject<Foo>.self, from: data)
                print(responseObject)
                
                // let json = JSON.init(parseJSON: "\(responseObject)")//parse("\(responseString)")
                // print(json)
                
            } catch {
                print(error) // parsing error
                
                if let responseString = String(data: data, encoding: .utf8) {
                    print("responseString = \(responseString)")
                    print(type(of: "\(responseString)"))
                    
                    let ch = Character("&")
                    let result = "\(responseString)".split(separator: ch)
                    
                    for _ in 0..<result.count {
                        
                        print(result)
                        print(result[0])
                        
                        let ch_2 = Character("=")
                        var result_2 = result[0].split(separator: ch_2)
                        print(result_2)
                        
                        if "\(result_2[1])" == "1" {
                            print("all details are perfect")
                            
                            DispatchQueue.main.async {
                                // send data to evs server
                                
                                ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
                                self.book_a_table_wb(advanced_payment: myDouble!)
                            }
                            
                            
                            return
                        } else {
                            print("something went wrong")
                            
                            let ch_3 = Character("=")
                            let result_3 = result[1].split(separator: ch_3)
                            print(result_3)
                            
                            DispatchQueue.main.async {
                                
                                let alert = UIAlertController(title: String("Alert").uppercased(), message: "\(result_3[1])", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                self.present(alert, animated: true)
                                
                                    }
                            
                            
                            
                            return
                            
                        }
                        
                    }
                    
                    
                    //
                } else {
                    print("unable to parse response as string")
                }
            }
        }
        
        task.resume()
        
        // delete this after uncomment
        /*let myDouble = Double(payment_to_cwa)
         self.book_a_table_wb(advanced_payment: myDouble!)*/
    }
    }
    
    @objc func book_a_table_wb(advanced_payment:Double) {
      
        print(self.dict_save_club_info_for_apple_pay as Any)
        print(self.club_Details as Any)
        
        /*
         Optional({
             advancePercentage = 20;
             clubTableId = 81;
             created = "Jan 3rd, 2023, 9:58 pm";
             description = "Five premium no cover up to 10 people ";
             image = "https://bookitweb.com/img/uploads/table/1672801106add_table.png";
             name = PLATINUM;
             "profile_picture" = "https://bookitweb.com/img/uploads/users/1672801183add_club_logo.png";
             seatPrice = 1500;
             totalSeat = 5;
             userAddress = "51-07 27th Street";
             userId = 1336;
             userName = "Sugar Daddy's Gentlemen\U2019s Club";
         })
         Optional({
             AVGRating = "";
             Fri = 0;
             Mon = 0;
             Sat = 0;
             StripeStatus = "";
             Sun = 0;
             Thu = 0;
             Tue = 0;
             Userimage = "https://bookitweb.com/img/uploads/users/1672801183add_club_logo.png";
             Wed = 0;
             about = "Gentlemen\U2019s Club";
             address = "51-07 27th Street";
             banner = "https://bookitweb.com/img/uploads/users/1672801191edit_club_banner.png";
             city = 11101;
             closeTime = "04:00 AM";
             contactNumber = "718-706-9600";
             currentPaymentOption = WIRED;
             device = "";
             deviceToken = "";
             email = "";
             fullName = "Sugar Daddy's Gentlemen\U2019s Club";
             latitude = "";
             longitude = "";
             openTime = "08:00 PM";
             stripeAccountNo = "";
             totalLiked = 0;
             userId = 1336;
             youliked = No;
             zipCode = 11101;
         */
         //
        
        
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // print(person as Any)

            let x : Int = person["userId"] as! Int
            let myString = String(x)

            let x_2 : Int = (self.dict_save_club_info_for_apple_pay["userId"] as! Int)
            let myString_2 = String(x_2)

            let x_3 : Int = (self.dict_save_club_info_for_apple_pay["clubTableId"] as! Int)
            let myString_3 = String(x_3)

            let x_4 : Int = (self.dict_save_club_info_for_apple_pay["totalSeat"] as! Int)
            let myString_4 = String(x_4)

            let x_5 : Int = (self.dict_save_club_info_for_apple_pay["seatPrice"] as! Int)
            let myString_5 = String(x_5)

            let params = customer_book_a_table(action   : "addbooking",
                                               userId       : myString,
                                               clubId       : myString_2,
                                               clubTableId  : myString_3,
                                               bookingDate  : Date.getCurrentDate(),
                                               arrvingTime  : String("N.A."),
                                               totalSeat    : myString_4,
                                               seatPrice    : myString_5,
                                               adminFee     : "0",
                                               totalAmount  : String(myString_5),
                                               advancePayment : "\(advanced_payment)",
                                               fullPaymentStatus: String("2") // half payment
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

                        // ERProgressHud.sharedInstance.hide()

                        let x : Int = JSON["bookingId"] as! Int
                        let myString_bid = String(x)

                        /*self.update_payment_from_stripe_to_EVS(str_booking_id_2: String(myString_bid),
                                                               str_payment_Status_2: self.is_full_payment_status,
                                                               str_status_is_2: "yes",
                                                               str_total_amount: String(myString_5))*/
                        
                        
                        self.update_payment_after_stripe(str_booking_id: String(myString_bid),
                                                         str_payment_Status: "2",
                                                         str_status_is: "yes",
                                                         str_transaction_id: "dummy_transaction_id",
                                                         str_total_price: "\(advanced_payment)")



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
    
    @objc func update_payment_after_stripe(str_booking_id:String,
                                           str_payment_Status:String,
                                           str_status_is:String,
                                           str_transaction_id:String,
                                           str_total_price:String) {
        
        
        
        self.view.endEditing(true)
        // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // print(person as Any)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params = Bookit.update_payment_after_stripe_webservice(action: "updatepayment",
                                                     userId: String(myString),
                                                     bookingId: String(str_booking_id),
                                                     fullPaymentStatus: String(str_payment_Status),
                                                     transactionId: String(str_transaction_id))
            
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
                        
                        if str_status_is == "yes" {
                            
                            self.confirm_payment(str_total_price_show: str_total_price)
                            
                        } else {
                            
                            var strSuccess2 : String!
                            strSuccess2 = JSON["msg"]as Any as? String
                            
                            let alert = NewYorkAlertController(title: "Success", message: String(strSuccess2), style: .alert)
                            
                            alert.addImage(UIImage.gif(name: "success3"))
                            
                            let cancel = NewYorkButton(title: "Ok", style: .cancel) { _ in
                                
                                let tab_bar = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "tab_bar_controller_id") as? tab_bar_controller
                                tab_bar?.selectedIndex = 0
                                self.navigationController?.pushViewController(tab_bar!, animated: false)
                                
                            }
                            alert.addButtons([cancel])
                            
                            self.present(alert, animated: true)
                            
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
    
    @objc func confirm_payment(str_total_price_show:String) {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BookingSuccessVC") as? BookingSuccessVC
         push!.str_booked_price = str_total_price_show
        self.navigationController?.pushViewController(push!, animated: true)
    }
    
}


//MARK:- TABLE VIEW -
extension NPClubTableDetailVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_mut_club_data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NPClubTableDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NPClubTableDetailCell") as! NPClubTableDetailTableViewCell
        
        cell.backgroundColor = .clear // cell_bg_color
      
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        let item = self.arr_mut_club_data[indexPath.row] as? [String:Any]
        print(item as Any)
        
        // let x : Int = item!["seatPrice"] as! Int
        // let myString = String(x)
        
        cell.lblPrice.text = "$\(item!["seatPrice"]!)"
        
        
        
        // let x_total_seat : Int = item!["totalSeat"] as! Int
        // let myString_x_total_seat = String(x_total_seat)
        
        /*if "\(item!["totalSeat"]!)" == "0" {
            cell.btnSeat.setTitle("\(item!["totalSeat"]!) seat", for: .normal)
        } else if "\(item!["seatPrice"]!)" == "1" {
            cell.btnSeat.setTitle("\(item!["totalSeat"]!) seat", for: .normal)
        } else {
            cell.btnSeat.setTitle("\(item!["totalSeat"]!) seats", for: .normal)
        }*/
        
        cell.btnSeat.setTitle("Guest", for: .normal)
        
        
        cell.lblTableNum.text = (item!["name"] as! String)
        
        cell.imgTable.image = UIImage(named: "bar")
        
        cell.imgTable.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.imgTable.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "logo"))
        
        cell.lbl_description.text = (item!["description"] as! String)
        
       // cell.btnSignUp.addTarget(self, action: #selector(btnSignUpTapped), for: .touchUpInside)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
            
            if (person["role"] as! String) == "Club" {
                
                cell.btnSeat.setTitle(" Delete", for: .normal)
                cell.btnSeat.backgroundColor = .systemRed
                cell.btnSeat.setImage(UIImage(systemName: "trash"), for: .normal)
                cell.btnSeat.tintColor = .white
                
                cell.btnSeat.tag = indexPath.row
                cell.btnSeat.addTarget(self, action: #selector(delete_table_click_method), for: .touchUpInside)
                
                cell.btnBook.setTitle("Edit", for: .normal)
                
            } else {
                
                if "\(item!["totalSeat"]!)" == "0" {
                    cell.btnSeat.setTitle("\(item!["totalSeat"]!) Guest", for: .normal)
                } else if "\(item!["totalSeat"]!)" == "1" {
                    cell.btnSeat.setTitle("\(item!["totalSeat"]!)  Guest", for: .normal)
                } else {
                    cell.btnSeat.setTitle("\(item!["totalSeat"]!)  Guests", for: .normal)
                }
                
                
                cell.btnBook.setTitle("Book", for: .normal)
                
                
                
            }
            
            cell.btnBook.tag = indexPath.row
            cell.btnBook.addTarget(self, action: #selector(book_click_method), for: .touchUpInside)
            
        } else {
            
            if "\(item!["totalSeat"]!)" == "0" {
                cell.btnSeat.setTitle("\(item!["totalSeat"]!) Guest", for: .normal)
            } else if "\(item!["totalSeat"]!)" == "1" {
                cell.btnSeat.setTitle("\(item!["totalSeat"]!)  Guest", for: .normal)
            } else {
                cell.btnSeat.setTitle("\(item!["totalSeat"]!)  Guests", for: .normal)
            }
            
            cell.btnBook.tag = indexPath.row
            cell.btnBook.setTitle("Book", for: .normal)
            cell.btnBook.addTarget(self, action: #selector(guest_login_click_method), for: .touchUpInside)
        }
        
        return cell
    }

    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let item = self.arr_mut_club_data[indexPath.row] as? [String:Any]
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
            
            if (person["role"] as! String) == "Club" {
                
            } else {
                
                self.arr_enlarge_table_image.removeAllObjects()
                self.arr_enlarge_table_image.add(item!["image"] as! String)
                
                let vc = ImagePreviewVC()
                vc.PhotoArray = self.arr_enlarge_table_image
                vc.passedContentOffset = indexPath
                vc.str_from = "club_details"
                self.navigationController?.pushViewController(vc, animated: false)
                
            }
            
        } else {
            
            self.arr_enlarge_table_image.removeAllObjects()
            self.arr_enlarge_table_image.add(item!["image"] as! String)
            
            let vc = ImagePreviewVC()
            vc.PhotoArray = self.arr_enlarge_table_image
            vc.passedContentOffset = indexPath
            vc.str_from = "club_details"
            self.navigationController?.pushViewController(vc, animated: false)
            
        }
        
    }
    
    @objc func delete_table_click_method(_ sender:UIButton) {
        
        let btn:UIButton! = sender
        print(btn.tag as Any)
        
        let item = self.arr_mut_club_data[btn.tag] as? [String:Any]
        print(item as Any)
        
        let alert = NewYorkAlertController(title: String("Delete"), message: "Are you sure you want to delete '"+(item!["name"] as! String)+"' table ?", style: .alert)
        
        alert.addImage(UIImage.gif(name: "gif_bin"))
        
        let yes_Delete = NewYorkButton(title: "Yes, delete", style: .default) {
            _ in
            
            self.delete_table_wb(str_club_id: "\(item!["userId"]!)",
                                 str_club_table_id: "\(item!["clubTableId"]!)")
        }
        
        let dismiss = NewYorkButton(title: "dismiss", style: .cancel)
        
        alert.addButtons([yes_Delete,dismiss])
        
        self.present(alert, animated: true)
        
    }
    
    // MARK: - DELETE TABLE -
    @objc func delete_table_wb(str_club_id:String , str_club_table_id:String) {
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "deleting...")
         
        let params = club_delete_table(action: "deletetable",
                                       clubId: String(str_club_id),
                                       clubTableId: String(str_club_table_id)
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
                        self.club_table_listing_wb()
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
        // }
    }
    
    @objc func book_click_method(_ sender:UIButton) {
        
        let btn:UIButton! = sender
        print(btn.tag as Any)
        
        if btn.titleLabel?.text == "Edit" {
            
            let item = self.arr_mut_club_data[btn.tag] as? [String:Any]
            
            // push to edit screen
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddTableVC") as? AddTableVC
            
            push!.dict_get_table_data = item as NSDictionary?
            
            self.navigationController?.pushViewController(push!, animated: true)
            
        } else {
            
            let item = self.arr_mut_club_data[btn.tag] as? [String:Any]
            
            let alert = NewYorkAlertController(title: "Book a Table", message: "Book a table for today or schedule it.", style: .alert)

            // alert.addImage(UIImage(named: "Image"))
            // clubTableId
            self.get_table_id = "\(item!["clubTableId"] as! Int)"
            
            
            let book_for_today = NewYorkButton(title: "BOOK FOR TODAY", style: .default) { _ in
                print("Tapped BOOK FOR TODAY")
                
                self.direct_payment(dict_get: item! as NSDictionary)
                
            }
            
            let schedule_A_Date = NewYorkButton(title: "SCHEDULE A DATE", style: .default) { _ in
                print("Tapped SCHEDULE A DATE")
                
                self.schedule_a_data(dict_get: item! as NSDictionary)
                
            }
            
            book_for_today.setDynamicColor(.purple)
            schedule_A_Date.setDynamicColor(.purple)
            
            let cancel = NewYorkButton(title: "Cancel", style: .cancel)
            alert.addButtons([book_for_today,schedule_A_Date, cancel])

            present(alert, animated: true)
            
        }
        
    }
    
    @objc func schedule_a_data(dict_get:NSDictionary) {
        
        let club_name = (self.club_Details["fullName"] as! String)
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BookingVC") as? BookingVC
        
        push!.dict_get_table_Details = dict_get
        push!.get_club_name = club_name
        // push!.dict_get_club_details = self.club_Details
        push!.club_details_get_for_schedule = self.club_Details
        
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    @objc func direct_payment_for_guest(dict_get:NSDictionary , str_status:String) {
        
        self.dismiss(animated: true)
        
        var get_day_from_date:String!
        
        if str_status == "1" { // book for today
            
            let date = Date().today(format: "yyyy-MM-dd")
            
            get_day_from_date = self.getDayNameBy(stringDate: "\(date)")
            print(get_day_from_date as Any)
            
        } else { // schedule
            
            print(self.str_guest_select_final_date as Any)
            get_day_from_date = self.getDayNameBy(stringDate: self.str_guest_select_final_date)
            print(get_day_from_date as Any)
            
        }
        
        
        
        
        // print("\(self.club_Details[get_day_from_date]!)")
        
        if "\(self.club_Details[get_day_from_date!]!)" == "1" {
            
            let alert = NewYorkAlertController(title: "Alert", message: String("This club is closed today. Please select another date to book this table."), style: .alert)
            
            let cancel = NewYorkButton(title: "dismiss", style: .cancel)
            alert.addButtons([cancel])
            
            self.present(alert, animated: true)
            
        } else {
            
            self.check_availaibility_for_guest(dict_of_that_club: dict_get)
            
        }
        
    }
    
    @objc func direct_payment(dict_get:NSDictionary) {
        
        let date = Date().today(format: "yyyy-MM-dd")
        
        let get_day_from_date = self.getDayNameBy(stringDate: "\(date)")
        // print(get_day_from_date as Any)
        
        // print("\(self.club_Details[get_day_from_date]!)")
         
        if "\(self.club_Details[get_day_from_date]!)" == "1" {
            
            let alert = NewYorkAlertController(title: "Alert", message: String("This club is closed today. Please select another date to book this table."), style: .alert)
            
            let cancel = NewYorkButton(title: "dismiss", style: .cancel)
            alert.addButtons([cancel])
            
            self.present(alert, animated: true)
            
        } else {
        
            self.check_availaibility(dict_of_that_club: dict_get)
            
        }
        
        
        
    }
    
    func getDayNameBy(stringDate: String) -> String {
        
        let df  = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let date = df.date(from: stringDate)!
        // df.dateFormat = "EEEE"
        df.dateFormat = "EE"
        return df.string(from: date)
        
    }
    
    
    // MARK: - CHECK DATES AVAILAIBLE -
    @objc func check_availaibility(dict_of_that_club:NSDictionary) {
        
        /*action:checkavailable
         date:
         tableId:*/
        
        // check_dates_availaibility
        
        print(self.str_guest_select_final_date as Any)
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "please wait...")
        
        let date = Date().today(format: "yyyy-MM-dd")

        print(date)
        
        let params = check_dates_availaibility(action: "checkavailable",
                                               date: "\(date)",
                                               tableId: String(self.get_table_id)
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
                    strSuccess2 = JSON["Availabe"]as Any as? String
                    
                    if strSuccess2 == "No" {
                    
                        let alert = NewYorkAlertController(title: String("Alert"), message: String("This table is already booked for today. Please choose another table."), style: .alert)
                        
                        alert.addImage(UIImage.gif(name: "gif_alert"))
                        
                        let cancel = NewYorkButton(title: "Ok", style: .cancel)
                        alert.addButtons([cancel])
                        
                        self.present(alert, animated: true)
                        
                        
                    } else {
                        
                        
                        print(dict_of_that_club as Any)
                        
                        self.dict_save_club_info_for_apple_pay = dict_of_that_club
                        
                        print(self.dict_save_club_info_for_apple_pay as Any)
                        print(self.club_Details as Any)
                        //
                        /*
                         
                         advancePercentage = 20;
                         clubTableId = 81;
                         created = "Jan 3rd, 2023, 9:58 pm";
                         description = "Five premium no cover up to 10 people ";
                         image = "https://bookitweb.com/img/uploads/table/1672801106add_table.png";
                         name = PLATINUM;
                         "profile_picture" = "https://bookitweb.com/img/uploads/users/1672801183add_club_logo.png";
                         seatPrice = 1500;
                         totalSeat = 5;
                         userAddress = "51-07 27th Street";
                         userId = 1336;
                         userName = "Sugar Daddy's Gentlemen\U2019s Club";
                         
                         */
                        // seat price
                        let myString = "\(dict_of_that_club["seatPrice"]!)"
                        let convert_seat_price_to_double = myString.toDouble()
                        // print(convert_seat_price_to_double)
                        
                        // username
                        let club_name = (dict_of_that_club["userName"] as! String)
                        
                        // club name
                        let table_name = (dict_of_that_club["name"] as! String)
                        
                        //
                        
                        
                        
                        // calculate booking fee
                        let double_add_booking_fee_with_total = (convert_seat_price_to_double!*Double(0.039))+Double(0.30)
                        print(double_add_booking_fee_with_total as Any)
                        
                        let s_final_amount = (String(format:"%.02f", double_add_booking_fee_with_total))
                        // let myInt3_final_amount = (s_final_amount as NSString).integerValue
//                        print(s_final_amount as Any)
                        
                        
                        // table price
                        let final_table_price = (String(format:"%.02f", convert_seat_price_to_double!))
                        
                        print("Table Price ========> "+final_table_price)
                        print("Your Booking Fees ========> "+s_final_amount)
                        
                        
                        
                        // advance percentage
                        let club_deposit_advance = "\(dict_of_that_club["advancePercentage"]!)"
                        print(club_deposit_advance as Any)
                        
                        // deduct deposit from total price
                        let deduct_deposit_from_total = (Double(club_deposit_advance)!/100)*Double(final_table_price)!
                        print(deduct_deposit_from_total as Any)
                        
                        let deposit_with_total = (String(format:"%.02f", deduct_deposit_from_total))
                        print(deposit_with_total as Any)
                        
                        // addbooking fee with deposit total
                        let final_pay_to_club_double = Double(deposit_with_total)!+Double(s_final_amount)!
                        print(final_pay_to_club_double as Any)
                        
                        let final_pay_to_club = (String(format:"%.02f", final_pay_to_club_double))
                        print(final_pay_to_club as Any)
                        
                        let alert_table_price = "Table Price : $"+String(final_table_price)
                        let alert_booking_price = "\n\nBooking fees : $"+String(s_final_amount)
                        let alert_deposit = "\n\nDeposit : "+String(club_deposit_advance)+"%"
                        let alert_pay_price = " : $"+final_pay_to_club
                        
                        let actionSheet = NewYorkAlertController(title: "Payment", message: alert_table_price+alert_booking_price+alert_deposit, style: .actionSheet)
                        
                        actionSheet.addImage(UIImage(named: "payment_1"))
                        
                        let apple_pay = NewYorkButton(title: "Apple Pay"+alert_pay_price, style: .default) { _ in
                            // print("camera clicked done")

                            self.apple_pay_in_bookit(str_club_name: club_name,
                                                     str_table_name: table_name,
                                                     str_table_price: final_pay_to_club)
                            
                         }
                        
                        let cwd_payment = NewYorkButton(title: "CWA"+alert_pay_price, style: .default) { _ in
                            
                            self.open_card_popup(final_payment_for_card_payment: final_pay_to_club)
                            
                         }
                                                
                        let cancel = NewYorkButton(title: "Dismiss", style: .cancel)
                        
                        actionSheet.addButtons([apple_pay,cwd_payment, cancel])
                        
                        self.present(actionSheet, animated: true)
                          
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
        // }
    }
    
    @objc func open_card_popup(final_payment_for_card_payment:String) {
        
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "card_payment_screen_id") as? card_payment_screen
        
        settingsVCId!.str_price = String(final_payment_for_card_payment)
        
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
        
    }
    
    @objc func push_when_time_select_successfully(get_my_dict:NSDictionary) {
        
        
        
    }
    
    @objc func btnSignUpTapped() {
        
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddTableVC") as? AddTableVC
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}

extension NPClubTableDetailVC: UITableViewDelegate {
    
}

extension NPClubTableDetailVC: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        
        //
        
        dismiss(animated: true, completion: nil)
        //
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        
        dismiss(animated: true, completion: nil)
        
        print("The Apple Pay transaction was complete.")
        
        print(payment.token.paymentData)
        print(payment.token.paymentMethod)
        print(payment.token.transactionIdentifier)
        
        if let url = Bundle.main.appStoreReceiptURL,
           let data = try? Data(contentsOf: url) {
              let receiptBase64 = data.base64EncodedString()
              // Send to server
            print(receiptBase64)
        }
        
        // displayDefaultAlert(title: "Success!", message: "The Apple Pay transaction was complete.")
        
        // call webservice
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        self.book_a_table_wb(advanced_payment: Double(self.payment_for_apple_pay)!)
        
    }
    
 
}

extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}


extension Dictionary {
    func percentEncoded() -> Data? {
        map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed: CharacterSet = .urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}


extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}


func convertToDictionary(text: String) -> [String: Any]? {
    if let data = text.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
    }
    return nil
}


 
