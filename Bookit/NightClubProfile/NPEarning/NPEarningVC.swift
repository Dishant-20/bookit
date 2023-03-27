//
//  NPEarningVC.swift
//  Bookit
//
//  Created by Ranjan on 28/12/21.
//

import UIKit
import Alamofire
import SDWebImage

class NPEarningVC: UIViewController {
    
    var start_date:String!
    var end_date:String!
    
    var arr_mut_booking_history:NSMutableArray! = []
    
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
            lblNavigationTitle.text = "Earnings"
            lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
            lblNavigationTitle.backgroundColor = .clear
        }
    }
    
    // ***************************************************************** // nav
    
    
    @IBOutlet weak var btnToday:UIButton!{
        didSet{
            btnToday.backgroundColor = BUTTON_DARK_APP_COLOR
            btnToday.tintColor = .white
            btnToday.addBottomBorder(with: .yellow, andWidth: 1.0)
            btnToday.setTitle("TODAY", for: .normal)
        }
    }
    
    @IBOutlet weak var btnWeekly:UIButton!{
        didSet{
            btnWeekly.backgroundColor = BUTTON_DARK_APP_COLOR
            btnWeekly.tintColor = .white
            btnWeekly.addBottomBorder(with: .yellow, andWidth: 1.0)
            btnWeekly.setTitle("WEEKLY", for: .normal)
        }
    }
    
    @IBOutlet weak var viwLeft:UIView!{
        didSet{
            viwLeft.backgroundColor = .white
            viwLeft.layer.cornerRadius = 10.0
            viwLeft.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var viwRight:UIView!{
        didSet{
            viwRight.backgroundColor = .white
            viwRight.layer.cornerRadius = 10.0
            viwRight.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var lblTotalEarnig:UILabel! {
        didSet {
            lblTotalEarnig.text = ""
            lblTotalBooking.textColor = .black
        }
    }
    @IBOutlet weak var lblTotalBooking:UILabel! {
        didSet {
            lblTotalBooking.text = ""
            lblTotalBooking.textColor = .black
        }
    }
    
    @IBOutlet weak var tablView:UITableView!{
        didSet {
            //tablView.delegate = self
            // tablView.dataSource = self
            tablView.backgroundColor =  APP_BASIC_COLOR
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = APP_BASIC_COLOR
        self.navigationController?.isNavigationBarHidden = true
        self.tablView.separatorColor = .clear
        
        self.btnBack.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        self.my_club_earning_wb()
        
        // // self.manage_profile()
        
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
        
        self.filter_earning_wb()
        
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
    
    @objc func my_club_earning_wb() {
        
        self.view.endEditing(true)
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            print(person as Any)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params = club_earning(action: "earning",
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
                        
                        // total amount
                        var strSuccess2_total_amount : String!
                        strSuccess2_total_amount = "\(JSON["totalAmount"]!)"
                        
                        // total booking
                        var strSuccess2_booking : String!
                        strSuccess2_booking = "\(JSON["totalOrder"]!)"
                        
                        // print(strSuccess2_total_amount as Any)
                        // print(strSuccess2_booking as Any)
                        
                        self.lblTotalEarnig.text = "$"+String(strSuccess2_total_amount)
                        self.lblTotalBooking.text = String(strSuccess2_booking)
                        
                        self.filter_earning_wb()
                        
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
    
    @objc func filter_earning_wb() {
        
        self.view.endEditing(true)
        
        // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            print(person as Any)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            /*let params = show_booking_history_via_dates(action: "bookinglist",
                                                        clubId: String(myString),
                                                        userType: "Club",
                                                        startDate: String(self.start_date),
                                                        endDate: String(self.end_date))*/
            
            let params = show_earnings_list(action: "bookinglistgroupby",
                                            userId: String(myString),
                                            completed: "Yes",
                                            startDate: String(self.start_date),
                                            endDate: String(self.end_date))
            
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
                        
                        self.arr_mut_booking_history.addObjects(from: ar as! [Any])
                        
                        // self.lbl_no_data_found.isHidden = true
                        self.tablView.isHidden = false
                        self.tablView.delegate = self
                        self.tablView.dataSource = self
                        self.tablView.reloadData()
                        
                        
                        
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
    
    
    
    // MARK: - SHOW BOOKING HISTORY VIA DATES -
    @objc func show_bookinG_history_via_dates() {
        
    }
    
}

//MARK:- TABLE VIEW -
extension NPEarningVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arr_mut_booking_history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NPEarningTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NPEarningTableCell") as! NPEarningTableViewCell
        
        cell.backgroundColor = APP_BASIC_COLOR
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        let item = self.arr_mut_booking_history[indexPath.row] as? [String:Any]
        
        cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
        cell.imgProfile.sd_setImage(with: URL(string: (item!["Userimage"] as! String)), placeholderImage: UIImage(named: "bar"))
        
        // cell.imgProfile.image = UIImage(named: "dan")
        cell.lblName.text = (item!["fullName"] as! String)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date_set = dateFormatter.date(from: (item!["bookingDate"] as! String))
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let resultString = dateFormatter.string(from: date_set!)
        
        cell.lblDate.text = String("Date : ")+resultString
        
        /*if "\(item!["fullPaymentStatus"]!)" == "2" { // advance payment
            
            cell.btnTotalAmount.setTitle("Payment not done yet", for: .normal)
            cell.lblAdvanceAmount.text = "Advance payment : $\(item!["advancePayment"]!)"
            
        } else {
            
            cell.btnTotalAmount.isHidden = true
            cell.lblAdvanceAmount.text = "Payment done"
            cell.lblAdvanceAmount.textColor = .systemGreen
        }*/
        
        cell.btnTotalAmount.setTitle("\(item!["COUNT"]!)", for: .normal)
        cell.lblAdvanceAmount.text = ""
        
        return cell
    }
    
    @objc func btnSignUpTapped() {
        
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddTableVC") as? AddTableVC
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            if (person["role"] as! String) == "Club" {
                
                let item = self.arr_mut_booking_history[indexPath.row] as? [String:Any]
                print(item as Any)
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BookingHistoryVC") as? BookingHistoryVC
                
                push!.str_push_status = "Yes"
                push!.dict_get_club_details = item! as NSDictionary
                
                self.navigationController?.pushViewController(push!, animated: true)
            }
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
}

extension NPEarningVC: UITableViewDelegate {
    
}
