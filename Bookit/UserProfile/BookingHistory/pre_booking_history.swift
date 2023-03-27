//
//  pre_booking_history.swift
//  Bookit
//
//  Created by Apple on 08/03/22.
//

import UIKit
import Alamofire
import SDWebImage

class pre_booking_history: UIViewController {
    
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
            btnBack.isHidden = true
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = APP_BASIC_COLOR
        self.navigationController?.isNavigationBarHidden = true
        self.tablView.separatorColor = .white
          
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
            
            if (person["role"] as! String) == "Club" {
                
                self.arr_mut_booking_history.removeAllObjects()
                self.booking_history_new_wb(pageNumber: 1)
                
            } else {
                
                self.booking_history_wb(pageNumber: 1)
                
            }
            
        }
    }
    
    @objc func manage_profile() {
        
        self.btnBack.setImage(UIImage(systemName: "list.dash"), for: .normal)
        // self.sideBarMenuClick()
        
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
                            
                            self.booking_history_new_wb(pageNumber: page)
                            
                        }
                    }
                }
                
            } else {
                
            }
            
        }
        
    }
    
    
    // MARK: - BOOKING HISTORY -
    @objc func booking_history_new_wb(pageNumber: Int) {
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            print(person as Any)
            
            print((person["role"] as! String))
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params = customer_booking_history_new(action: "bookinglistgroupby",
                                                      userId: myString,
                                                      clubId: myString,
                                                      pageNo:pageNumber)
            
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
                            
                            // print(self.arr_mut_booking_history.count)
                            
                            if self.arr_mut_booking_history.count == 0 {
                                
                                self.tablView.isHidden = true
                                self.lbl_no_data_found.text = "No data found"
                                self.lbl_no_data_found.textColor = .white
                                self.lbl_no_data_found.textAlignment = .center
                                
                            } else {
                                
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
    
}

//MARK:- TABLE VIEW -
extension pre_booking_history: UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_mut_booking_history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:pre_booking_history_table_cell = tableView.dequeueReusableCell(withIdentifier: "pre_booking_history_table_cell") as! pre_booking_history_table_cell
        
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
                
                cell.lblDate.text = String("Date : ")+(item!["bookingDate"] as! String)
                
                cell.btnLocation.setTitle((item!["ClubAddress"] as! String), for: .normal)
                
                cell.btnSeats.setTitle("\(item!["COUNT"]!)", for: .normal)
                
                
            }
            
            else {
                
                cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
                cell.imgProfile.sd_setImage(with: URL(string: (item!["Clubimage"] as! String)), placeholderImage: UIImage(named: "bar"))
                
                // cell.imgProfile.image = UIImage(named: "dan")
                cell.lblName.text = (item!["ClubfullName"] as! String)
                
                cell.lblDate.text = String("Date : ")+(item!["bookingDate"] as! String)
                
                cell.btnLocation.setTitle((item!["ClubAddress"] as! String), for: .normal)
                
                /*let x : Int = (item!["TabletotalSeat"] as! Int)
                 let myString = String(x)
                 
                 if myString == "1" {
                 
                 cell.btnSeats.setTitle(myString+" seat", for: .normal)
                 
                 } else if myString == "2" {
                 
                 cell.btnSeats.setTitle(myString+" seat", for: .normal)
                 
                 } else {
                 
                 cell.btnSeats.setTitle(myString+" seats", for: .normal)
                 
                 }*/
                
                cell.btnSeats.setTitle("Guest", for: .normal)
                
                
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
            
            if (person["role"] as! String) == "Club" {
                
                let item = self.arr_mut_booking_history[indexPath.row] as? [String:Any]
                print(item as Any)
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BookingHistoryVC") as? BookingHistoryVC
                
                push!.dict_get_club_details = item! as NSDictionary
                
                self.navigationController?.pushViewController(push!, animated: true)
                
                //
                /*let item = self.arr_mut_booking_history[indexPath.row] as? [String:Any]
                
                print(item as Any)
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NPBookingDetailVC") as? NPBookingDetailVC
                
                push!.dict_get_club_booking_details = item! as NSDictionary
                //print(dict_get_club_booking_details)
                
                self.navigationController?.pushViewController(push!, animated: true)*/
                
            }
            
            else {
                
                /*let item = self.arr_mut_booking_history[indexPath.row] as? [String:Any]
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BookingDetailsVC") as? BookingDetailsVC
                
                push!.dict_get_booking_details = item! as NSDictionary
                
                self.navigationController?.pushViewController(push!, animated: true)*/
                
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}

class pre_booking_history_table_cell:UITableViewCell {
    
    @IBOutlet weak var viw:UIView!{
        didSet{
            viw.backgroundColor = APP_BASIC_COLOR
        }
    }
    
    @IBOutlet weak var imgProfile:UIImageView!{
        didSet{
            
            imgProfile.clipsToBounds = true
            imgProfile.layer.cornerRadius = 30.0
            imgProfile.layer.borderWidth = 5
            imgProfile.layer.borderColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1).cgColor
            
        }
    }
    
    @IBOutlet weak var lblName:UILabel!
    
    @IBOutlet weak var lblDate:UILabel!
    
    @IBOutlet weak var btnLocation:UIButton!{
        didSet{
            btnLocation.tintColor = .white
        }
    }
    
    @IBOutlet weak var btnSeats:UIButton!{
        didSet{
            
            btnSeats.layer.cornerRadius = 20.0
            btnSeats.clipsToBounds = true
            btnSeats.backgroundColor = BUTTON_DARK_APP_COLOR
            btnSeats.tintColor = .white
        }
    }
    
}
