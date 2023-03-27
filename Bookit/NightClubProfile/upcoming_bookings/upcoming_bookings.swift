//
//  upcoming_bookings.swift
//  Bookit
//
//  Created by Apple on 06/04/22.
//

import UIKit
import Alamofire
import SDWebImage

class upcoming_bookings: UIViewController {
    
    var dict_get_club_details:NSDictionary!
    
    var arr_mut_upcoming_bookings_list:NSMutableArray! = []
    
    var clicked_index:Int! = 999999
    
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
            btnBack.isHidden = true
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "Upcoming bookings"
        }
    }
    
    // ***************************************************************** // nav
    
    @IBOutlet weak var lbl_no_data_found:UILabel! {
        didSet {
            lbl_no_data_found.text = "You didn't add any table yet. Please click on '+' icon to add Tables."
            lbl_no_data_found.textColor = .white
            lbl_no_data_found.isHidden = true
            lbl_no_data_found.numberOfLines = 0
        }
    }
    
    @IBOutlet weak var tablView:UITableView! {
        didSet {
            // tablView.delegate = self
            // tablView.dataSource = self
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
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.booking_history_wb()
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - BOOKING HISTORY -
    @objc func booking_history_wb() {
        self.arr_mut_upcoming_bookings_list.removeAllObjects()
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            print(person as Any)
            
            print((person["role"] as! String))
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            // action:bookinglistgroupby
            
            let params = booking_list_for_upcoming_events(action: "upcomingbookinglist",
                                                          // userId: String(myString),
                                                          clubId: String(myString),
                                                          userType: (person["role"] as! String),
                                                          pageNo: "",
                                                          upcommimg:"Yes")
            
            
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
                            // lbl_no_data_found
                            
                            self.tablView.isHidden = true
                            self.lbl_no_data_found.text = "No upcoming bookings"
                            self.lbl_no_data_found.textColor = .white
                            self.lbl_no_data_found.textAlignment = .center
                            
                        } else {
                            
                            self.arr_mut_upcoming_bookings_list.addObjects(from: ar as! [Any])
                            
                            self.lbl_no_data_found.isHidden = true
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
    }
    
    
    @objc func cancel_booking_request_click_method(_ sender:UIButton) {
        
        let item = self.arr_mut_upcoming_bookings_list[sender.tag] as? [String:Any]
        
        let alert = NewYorkAlertController(title: "Cancel request", message: String("Confirm cancel this request ?"), style: .alert)
        
        let yes_logout = NewYorkButton(title: "cancel booking", style: .destructive) {
            _ in
            
            // print(item as Any)
            //
            
            self.cance_booking_request_wb(str_booking_id: "\(item!["bookingId"]!)", str_status: "2")
            
        }
        
        /*let decline_booking = NewYorkButton(title: "decline booking", style: .default) {
            _ in
            
            // print(item as Any)
            //
            
            self.cance_booking_request_wb(str_booking_id: "\(item!["bookingId"]!)", str_status: "3")
            
        }*/

        
        let cancel = NewYorkButton(title: "dismiss", style: .cancel)
        alert.addButtons([cancel,yes_logout])
        
        self.present(alert, animated: true)
        
    }
    
    
    @objc func cance_booking_request_wb(str_booking_id:String , str_status:String) {
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        // self.arr_mut_dashboard_Data.removeAllObjects()
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            print(person as Any)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params = cancel_booking_request(action: "cancelconfirm",
                                                userId: myString,
                                                bookingId: String(str_booking_id),
                                                cancelRequest: String(str_status))
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
                        
                        
                        let cancel = NewYorkButton(title: "dismiss", style: .cancel) {
                            _ in
                            
                            self.booking_history_wb()
                        }
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
extension upcoming_bookings: UITableViewDataSource , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_mut_upcoming_bookings_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:upcoming_bookings_table_cell = tableView.dequeueReusableCell(withIdentifier: "upcoming_bookings_table_cell") as! upcoming_bookings_table_cell
        
        cell.backgroundColor = APP_BASIC_COLOR
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        let item = self.arr_mut_upcoming_bookings_list[indexPath.row] as? [String:Any]
        // print(item as Any)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date_set = dateFormatter.date(from: (item!["bookingDate"] as! String))
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let resultString = dateFormatter.string(from: date_set!)
        
        cell.lbl_booking_date.text = String(resultString)
        
        // cell.lbl_user_name.text = (item!["fullName"] as! String)
        // cell.lbl_user_phone_number.text = (item!["email"] as! String)
        cell.lbl_table_name.text = (item!["tableName"] as! String)
        cell.lbl_table_price.text = "$\(item!["seatPrice"]!)"
        
        if "\(item!["fullPaymentStatus"]!)" == "1" {
            
            cell.btn_check_mark.isHidden = false
            cell.lbl_payment_status.text = "Full"
            cell.lbl_payment_status.textColor = .systemGreen
            
        } else {
            
            cell.btn_check_mark.isHidden = true
            cell.lbl_payment_status.text = "Advance"
            cell.lbl_payment_status.textColor = .systemOrange
            
        }
        
        if "\(item!["cancelRequest"]!)" == "0" {
            
            cell.btn_cancel_booking_request.setTitle("", for: .normal)
            cell.btn_cancel_booking_request.isHidden = true
            
        } else if "\(item!["cancelRequest"]!)" == "1" {
            
            cell.btn_cancel_booking_request.tag = indexPath.row
            cell.btn_cancel_booking_request.setTitle("cancel request", for: .normal)
            cell.btn_cancel_booking_request.setTitleColor(.black, for: .normal)
            cell.btn_cancel_booking_request.isHidden = true
            cell.btn_cancel_booking_request.backgroundColor = .white
            cell.btn_cancel_booking_request.addTarget(self, action: #selector(cancel_booking_request_click_method), for: .touchUpInside)
            
        } else {
            
            cell.btn_cancel_booking_request.isHidden = true
            cell.btn_cancel_booking_request.setTitle("cancelled", for: .normal)
            cell.btn_cancel_booking_request.backgroundColor = .systemRed
            cell.btn_cancel_booking_request.setTitleColor(.white, for: .normal)
        }
        
        cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
        cell.imgProfile.sd_setImage(with: URL(string: (item!["Tableimage"] as! String)), placeholderImage: UIImage(named: "logo"))
        
        cell.lbl_user_name.text = "\(item!["fullName"]!)"
        cell.lbl_user_name.textColor = .white
        
        cell.lbl_user_phone_number.text = "\(item!["email"]!)"
        cell.lbl_user_phone_number.textColor = .white
        
        cell.img_user_profile.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
        cell.img_user_profile.sd_setImage(with: URL(string: (item!["Userimage"] as! String)), placeholderImage: UIImage(named: "logo"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.clicked_index = indexPath.row
        self.tablView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == self.clicked_index {
            return 256
        } else {
            return 144
        }
        
    }
    
    
}

class upcoming_bookings_table_cell : UITableViewCell {
    
    @IBOutlet weak var viw:UIView!{
        didSet{
            viw.backgroundColor = APP_BASIC_COLOR
        }
    }
    
    @IBOutlet weak var imgProfile:UIImageView! {
        didSet {
            imgProfile.clipsToBounds = true
            imgProfile.layer.cornerRadius = 30.0
            imgProfile.layer.borderWidth = 5
            imgProfile.layer.borderColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1).cgColor
            
        }
    }
    
    @IBOutlet weak var lbl_booking_date:UILabel! {
        didSet {
            lbl_booking_date.textColor = .white
        }
    }
    
    @IBOutlet weak var lbl_table_name:UILabel! {
        didSet {
            lbl_table_name.textColor = .white
        }
    }
    
    @IBOutlet weak var lbl_table_price:UILabel! {
        didSet {
            lbl_table_price.textColor = .white
        }
    }
    
    @IBOutlet weak var lbl_payment_status:UILabel! {
        didSet {
            lbl_payment_status.textColor = .white
        }
    }
    
     
    
     
    
    @IBOutlet weak var btn_check_mark:UIButton!{
        didSet {
            btn_check_mark.tintColor = .systemGreen
            btn_check_mark.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        }
    }
    
    
    
    @IBOutlet weak var viw_user:UIView!{
        didSet{
            viw_user.backgroundColor = APP_BASIC_COLOR
        }
    }
    
    @IBOutlet weak var img_user_profile:UIImageView! {
        didSet {
            img_user_profile.clipsToBounds = true
            img_user_profile.layer.cornerRadius = 30.0
            img_user_profile.layer.borderWidth = 5
            img_user_profile.layer.borderColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1).cgColor
            
        }
    }
    
    @IBOutlet weak var lbl_user_name:UILabel! {
        didSet {
            lbl_user_name.textColor = .white
        }
    }
    
    @IBOutlet weak var lbl_user_phone_number:UILabel! {
        didSet {
            lbl_user_phone_number.textColor = .white
        }
    }
    
    @IBOutlet weak var btn_cancel_booking_request:UIButton! {
        didSet {
            btn_cancel_booking_request.backgroundColor = .white
            btn_cancel_booking_request.layer.cornerRadius = 20
            btn_cancel_booking_request.clipsToBounds = true
            btn_cancel_booking_request.setTitle("cancel request", for: .normal)
            btn_cancel_booking_request.setTitleColor(.black, for: .normal)
            btn_cancel_booking_request.isHidden = true
        }
    }
    
}
