//
//  BookingHistoryVC.swift
//  Bookit
//
//  Created by Ranjan on 27/12/21.
//

import UIKit
import Alamofire
import SDWebImage

class BookingHistoryVC: UIViewController {
    
    var dict_get_club_details:NSDictionary!
    
    var arr_mut_booking_history:NSMutableArray! = []
    
    var page : Int! = 1
    var loadMore : Int! = 1;
    
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
            lblNavigationTitle.text = "Booking history"
            lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
            lblNavigationTitle.backgroundColor = .clear
        }
    }
    
    // ***************************************************************** // nav
    
    @IBOutlet weak var tablView:UITableView! {
        didSet {
            tablView.delegate = self
            // tablView.dataSource = self
            tablView.backgroundColor =  APP_BASIC_COLOR
        }
    }
    
    @IBOutlet weak var lbl_no_data_found:UILabel! {
        didSet {
            lbl_no_data_found.textColor = .black
        }
    }
    
    var str_push_status:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = APP_BASIC_COLOR
        self.navigationController?.isNavigationBarHidden = true
        self.tablView.separatorColor = .white
        // self.sideBarMenuClick()
        
        // // self.manage_profile()
        
        // print(self.dict_get_club_details as Any)
        
        /*
         ClubAddress = "Ramprastha c23";
         ClubCity = "";
         ClubZipcode = 201011;
         Clubbanner = "";
         ClubcontactNumber = 4534244456;
         Clubemail = "n200@mailinator.com";
         ClubfullName = N200;
         Clubimage = "";
         ClublastName = "";
         Tableimage = "";
         TableseatPrice = 5000;
         TabletotalSeat = 5;
         Userimage = "";
         advancePayment = 2500;
         bookingDate = "2022-03-02";
         bookingId = 102;
         clubId = 72;
         clubTableId = 43;
         contactNumber = "+919812123454";
         created = "2022-03-02 18:18:00";
         email = "pandey@mailinator.com";
         fullName = Purnima;
         fullPaymentStatus = 2;
         lastName = "";
         seatPrice = 5000;
         tableName = "family ";
         totalAmount = 5000;
         totalSeat = 5;
         userId = 35;
         */
        
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
            
            if (person["role"] as! String) == "Club" {
                
                self.btnBack.isHidden = false
                self.btnBack.setImage(UIImage(systemName: "arrow.left"), for: .normal)
                self.btnBack.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
                
                if self.str_push_status == "Yes" {
                    
                    self.arr_mut_booking_history.removeAllObjects()
                    self.lblNavigationTitle.text = "Earning history"
                    self.booking_history_earning_new_wb(str_user_id: "\(self.dict_get_club_details["userId"]!)",
                                                        str_club_id: "\(self.dict_get_club_details["clubId"]!)", pageNumber: 1)
                    
                } else {
                    
                    self.arr_mut_booking_history.removeAllObjects()
                    self.booking_history_new_wb(str_user_id: "\(self.dict_get_club_details["userId"]!)",
                                                str_club_id: "\(self.dict_get_club_details["clubId"]!)", str_loader_status: "yes",
                                                pageNumber: 1)
                }
                
                
            } else {
                
                self.arr_mut_booking_history.removeAllObjects()
                self.btnBack.isHidden = true
                self.booking_history_wb(pageNumber: 1)
                
            }
            
        }
        
    }
    
    @objc func manage_profile() {
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
            
            if (person["role"] as! String) == "Club" {
                
                self.btnBack.setImage(UIImage(systemName: "arrow.left"), for: .normal)
                self.btnBack.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
                
            } else {
                
                self.btnBack.setImage(UIImage(systemName: "list.dash"), for: .normal)
                // self.sideBarMenuClick()
                
            }
        }
        
        
        
        /*if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
         
         if (person["role"] as! String) == "Club" {
         
         self.btnBack.setImage(UIImage(systemName: "menucard"), for: .normal)
         // self.sideBarMenuClick()
         
         } else {
         
         self.btnBack.setImage(UIImage(systemName: "arrow.left"), for: .normal)
         self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
         
         }
         }*/
    }
    
    @objc func back_click_method() {
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
            
            if (person["role"] as! String) == "Club" {
                
                if scrollView == self.tablView {
                    let isReachingEnd = scrollView.contentOffset.y >= 0
                        && scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)
                    if(isReachingEnd) {
                        if(loadMore == 1) {
                            loadMore = 0
                            page += 1
                            print(page as Any)
                            
                            if self.str_push_status == "Yes" {
                                
                                self.booking_history_earning_new_wb(str_user_id: "\(self.dict_get_club_details["userId"]!)",
                                                                    str_club_id: "\(self.dict_get_club_details["clubId"]!)", pageNumber: page)
                                
                            } else {
                            
                                self.booking_history_new_wb(str_user_id: "\(self.dict_get_club_details["userId"]!)",
                                                            str_club_id: "\(self.dict_get_club_details["clubId"]!)",
                                                            str_loader_status: "yes",
                                                            pageNumber: page)
                                
                            }
                            
                            
                            
                            
                            
                        }
                    }
                }
                
            } else {
                // customer
                
                if scrollView == self.tablView {
                    let isReachingEnd = scrollView.contentOffset.y >= 0
                        && scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)
                    if(isReachingEnd) {
                        if(loadMore == 1) {
                            loadMore = 0
                            page += 1
                            print(page as Any)
                            
                            self.booking_history_wb(pageNumber: page)
                            
                        }
                    }
                }
                
                
            }
            
        }
        
    }
    
    // MARK: - BOOKING HISTORY -
    @objc func booking_history_wb(pageNumber: Int) {
        
        
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            print(person as Any)
            
            print((person["role"] as! String))
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            // action:bookinglistgroupby
            
            let params = customer_booking_history(action: "bookinglist",
                                                  userId: String(myString),
                                                  userType: (person["role"] as! String),
                                                  pageNo: pageNumber)
            
            
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
                            
                            if self.arr_mut_booking_history.count == 0 {
                                
                                self.tablView.isHidden = true
                                self.lbl_no_data_found.text = "No data found"
                                self.lbl_no_data_found.textColor = .white
                                self.lbl_no_data_found.textAlignment = .center
                                
                            } else {
                                
                                self.arr_mut_booking_history.addObjects(from: ar as! [Any])
                                
                                self.lbl_no_data_found.isHidden = true
                                self.tablView.isHidden = false
                                self.tablView.delegate = self
                                self.tablView.dataSource = self
                                self.tablView.reloadData()
                                
                            }
                            
                            
                        } else {
                            
                            self.arr_mut_booking_history.addObjects(from: ar as! [Any])
                            
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
    
    
    
    
    // MARK: - BOOKING HISTORY -
    @objc func booking_history_new_wb(str_user_id:String ,
                                      str_club_id:String ,
                                      str_loader_status:String ,
                                      pageNumber: Int) {
        
        //
        
        self.view.endEditing(true)
        
        if str_loader_status == "yes" {
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        }
        
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // print(person as Any)
            
            // print((person["role"] as! String))
            
            // let x : Int = person["userId"] as! Int
            // let myString = String(x)
            
            let params = customer_booking_history_for_club(action: "bookinglist",
                                                           userId: String(str_user_id),
                                                           clubId:String(str_club_id),
                                                           userType: (person["role"] as! String),
                                                           pageNo: pageNumber)
            
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
                           
                            if self.arr_mut_booking_history.count == 0 {
                                
                                self.tablView.isHidden = true
                                self.lbl_no_data_found.text = "No data found"
                                self.lbl_no_data_found.textColor = .white
                                self.lbl_no_data_found.textAlignment = .center
                                
                            } else {
                                
                                self.arr_mut_booking_history.addObjects(from: ar as! [Any])
                                
                                self.lbl_no_data_found.isHidden = true
                                self.tablView.isHidden = false
                                self.tablView.delegate = self
                                self.tablView.dataSource = self
                                self.tablView.reloadData()
                                self.loadMore = 1
                                
                            }
                            
                            
                        } else {
                            
                            self.arr_mut_booking_history.addObjects(from: ar as! [Any])
                            
                            self.lbl_no_data_found.isHidden = true
                            self.tablView.isHidden = false
                            self.tablView.delegate = self
                            self.tablView.dataSource = self
                            self.tablView.reloadData()
                            self.loadMore = 1
                            
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
    
    
    
    // MARK: - BOOKING HISTORY EARNING -
    @objc func booking_history_earning_new_wb(str_user_id:String ,
                                              str_club_id:String ,
                                              pageNumber: Int) {
        
        
        
        self.view.endEditing(true)
        
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // print(person as Any)
            
            // print((person["role"] as! String))
            
            // let x : Int = person["userId"] as! Int
            // let myString = String(x)
            
            let params = customer_booking_history_earnings_for_club(action: "bookinglist",
                                                                    userId: String(str_user_id),
                                                                    clubId:String(str_club_id),
                                                                    userType: (person["role"] as! String),
                                                                    pageNo: pageNumber,
                                                                    completed:"Yes")
            
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
                            
                            if self.arr_mut_booking_history.count == 0 {
                                
                                self.tablView.isHidden = true
                                self.lbl_no_data_found.text = "No data found"
                                self.lbl_no_data_found.textColor = .white
                                self.lbl_no_data_found.textAlignment = .center
                                
                            } else {
                            
                                self.arr_mut_booking_history.addObjects(from: ar as! [Any])
                                
                                self.lbl_no_data_found.isHidden = true
                                self.tablView.isHidden = false
                                self.tablView.delegate = self
                                self.tablView.dataSource = self
                                self.tablView.reloadData()
                                self.loadMore = 1
                                
                            }
                            
                            
                        } else {
                            
                            self.arr_mut_booking_history.addObjects(from: ar as! [Any])
                            
                            self.lbl_no_data_found.isHidden = true
                            self.tablView.isHidden = false
                            self.tablView.delegate = self
                            self.tablView.dataSource = self
                            self.tablView.reloadData()
                            self.loadMore = 1
                            
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
        
        let item = self.arr_mut_booking_history[sender.tag] as? [String:Any]
        
        let alert = NewYorkAlertController(title: "Cancel request", message: String("Confirm cancel this request ?"), style: .alert)
        
        let yes_logout = NewYorkButton(title: "cancel booking", style: .destructive) {
            _ in
            
            self.cance_booking_request_wb(str_booking_id: "\(item!["bookingId"]!)", str_status: "2")
            
        }
        
        /*let decline_booking = NewYorkButton(title: "decline booking", style: .default) {
         _ in
         
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
                            
                            
                            
                            
                            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
                                
                                if (person["role"] as! String) == "Club" {
                                    
                                    self.booking_history_new_wb(str_user_id: "\(self.dict_get_club_details["userId"]!)",
                                                                str_club_id: "\(self.dict_get_club_details["clubId"]!)", str_loader_status: "no", pageNumber: 1)
                                    
                                } else {
                                    self.booking_history_wb(pageNumber: 1)
                                    
                                }
                                
                            }
                            
                            
                            
                            
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
extension BookingHistoryVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_mut_booking_history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:BookingHistoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "BookingHistoryTableCell") as! BookingHistoryTableViewCell
        
        cell.backgroundColor = APP_BASIC_COLOR
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        let item = self.arr_mut_booking_history[indexPath.row] as? [String:Any]
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]{
            
            if (person["role"] as! String) == "Club" {
                
                cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
                cell.imgProfile.sd_setImage(with: URL(string: (item!["Userimage"] as! String)), placeholderImage: UIImage(named: "bar"))
                
                // cell.imgProfile.image = UIImage(named: "dan")
                cell.lblName.text = (item!["fullName"] as! String)
                
                cell.lblDate.text = (item!["bookingDate"] as! String)
                
                cell.btnLocation.setTitle((item!["ClubAddress"] as! String), for: .normal)
                
                // cell.btnSeats.setTitle("Booked", for: .normal)
                
                if self.str_push_status == "Yes" {
                    
                    cell.btnSeats.isHidden = true
                    
                } else {
                
                    if "\(item!["cancelRequest"]!)" == "0" {
                        
                        cell.btnSeats.backgroundColor = NAVIGATION_COLOR
                        cell.btnSeats.setTitle("Booked", for: .normal)
                        cell.btnSeats.setTitleColor(.white, for: .normal)
                        cell.btnSeats.isUserInteractionEnabled = false
                        
                    } else if "\(item!["cancelRequest"]!)" == "1" {
                        
                        cell.btnSeats.backgroundColor = .systemOrange
                        cell.btnSeats.setTitle("Cancel request", for: .normal)
                        cell.btnSeats.setTitleColor(.black, for: .normal)
                        cell.btnSeats.tag = indexPath.row
                        cell.btnSeats.addTarget(self, action: #selector(cancel_booking_request_click_method), for: .touchUpInside)
                        cell.btnSeats.isUserInteractionEnabled = true
                        
                    } else {
                        
                        cell.btnSeats.backgroundColor = .systemRed
                        cell.btnSeats.setTitle("Cancelled", for: .normal)
                        cell.btnSeats.setTitleColor(.white, for: .normal)
                        cell.btnSeats.isUserInteractionEnabled = false
                    }
                    
                }
                // print(item as Any)
                
                
            }
            
            else {
                
                cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
                cell.imgProfile.sd_setImage(with: URL(string: (item!["Clubimage"] as! String)), placeholderImage: UIImage(named: "bar"))
                
                // cell.imgProfile.image = UIImage(named: "dan")
                cell.lblName.text = (item!["ClubfullName"] as! String)
                
                cell.lblDate.text = (item!["bookingDate"] as! String)
                
                cell.btnLocation.setTitle((item!["ClubAddress"] as! String), for: .normal)
                
                
                // print(item as Any)
                if "\(item!["cancelRequest"]!)" == "0" {
                    
                    cell.btnSeats.backgroundColor = NAVIGATION_COLOR
                    cell.btnSeats.setTitle("Booked", for: .normal)
                    
                } else if "\(item!["cancelRequest"]!)" == "1" {
                    
                    cell.btnSeats.backgroundColor = .systemOrange
                    cell.btnSeats.setTitle("Cancel Request Initiated", for: .normal)
                    
                } else {
                    
                    cell.btnSeats.backgroundColor = .systemRed
                    cell.btnSeats.setTitle("Cancelled", for: .normal)
                    
                }
                
                
                
                
            }
            
            
        }
        
        
        // (item!["ClubfullName"] as! String)
        
        // cell.btnSignUp.addTarget(self, action: #selector(btnSignUpTapped), for: .touchUpInside)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //        let item = self.arr_mut_booking_history[indexPath.row] as? [String:Any]
        //
        //                        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BookingDetailsVC") as? BookingDetailsVC
        //
        //                        push!.dict_get_booking_details = item! as NSDictionary
        //
        //                                self.navigationController?.pushViewController(push!, animated: true)
        
        
        
        // dict_get_booking_details
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]{
            
            if (person["role"] as! String) == "Club"{
                
                
                let item = self.arr_mut_booking_history[indexPath.row] as? [String:Any]
                
                print(item as Any)
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NPBookingDetailVC") as? NPBookingDetailVC
                
                push!.dict_get_club_booking_details = item! as NSDictionary
                //print(dict_get_club_booking_details)
                
                self.navigationController?.pushViewController(push!, animated: true)
                
            } else {
                
                let item = self.arr_mut_booking_history[indexPath.row] as? [String:Any]
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BookingDetailsVC") as? BookingDetailsVC
                
                push!.dict_get_booking_details = item! as NSDictionary
                
                self.navigationController?.pushViewController(push!, animated: true)
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}

extension BookingHistoryVC: UITableViewDelegate {
    
}
