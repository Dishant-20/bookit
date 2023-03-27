//
//  event_list.swift
//  Bookit
//
//  Created by Apple on 09/03/22.
//

import UIKit
import Alamofire
import SDWebImage

class event_list: UIViewController {

    var str_club_id:String!
    
    var page : Int! = 1
    var loadMore : Int! = 1;
    
    var arr_mut_event_list:NSMutableArray! = []
    var arr_mut_save_event_image:NSMutableArray! = []
    
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
                lblNavigationTitle.text = "My Events"
                lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
                lblNavigationTitle.backgroundColor = .clear
                lblNavigationTitle.numberOfLines = 0
            }
        }
                    
    // ***************************************************************** // nav
    
    @IBOutlet weak var lbl_no_event_found:UILabel! {
        didSet {
            lbl_no_event_found.textColor = .black
            lbl_no_event_found.textAlignment = .center
        }
    }
    
    @IBOutlet weak var tablView:UITableView!{
        didSet {
            // tablView.delegate = self
            // tablView.dataSource = self
            tablView.backgroundColor =  .clear
        }
    }
    
    @IBOutlet weak var btn_add_event:UIButton! {
        didSet {
            btn_add_event.isHidden = true
            btn_add_event.tintColor = .white
            btn_add_event.setImage(UIImage(systemName: "plus"), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        self.tablView.separatorColor = .clear
        self.btn_add_event.addTarget(self, action: #selector(add_event_click_method), for: .touchUpInside)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            print(person as Any)
            
            if (person["role"] as! String) == "Club" {
                
                self.lblNavigationTitle.text = "My Events"
                self.btnBack.isHidden = true
                self.btn_add_event.isHidden = false
                
            } else {
                
                self.lblNavigationTitle.text = "Events"
                
                self.btnBack.isHidden = false
                self.btnBack.setImage(UIImage(systemName: "arrow.left"), for: .normal)
                self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
                
                self.btn_add_event.isHidden = true
                
            }
            
        } else {
            
            // guest
            self.btn_add_event.isHidden = true
            self.lblNavigationTitle.text = "Events"
            self.btnBack.setImage(UIImage(systemName: "arrow.left"), for: .normal)
            self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
            
        }
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // self.manage_profile()
        
        self.event_listing_wb(pageNumber: 1)
    }
    
    @objc func back_click_method() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func add_event_click_method() {
    
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BookingVC") as? BookingVC
        push!.str_from_club_for_event = "yes"
        self.navigationController?.pushViewController(push!, animated: true)
        
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
        
        
        self.event_listing_wb(pageNumber: 1)
        
        
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
    
    
    
    // MARK: - EVENT LISTING -
    @objc func event_listing_wb(pageNumber:Int) {
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if pageNumber == 1 {
            self.arr_mut_event_list.removeAllObjects()  
        }
        //
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            print(person as Any)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            self.view.endEditing(true)
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
            
            let str_user_id:String!
            
            if (person["role"] as! String) == "Club" {
                str_user_id = myString
            } else {
                str_user_id = self.str_club_id
            }
            
            
            let params = events_listing(action: "eventlist",
                                        userId: String(str_user_id),
                                        pageNo: pageNumber,
                                        date: "")
            
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
                            
                            if pageNumber == 1 {
                                
                                self.lbl_no_event_found.isHidden = false
                                
                                if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
                                    print(person as Any)
                                    
                                    if (person["role"] as! String) != "Club" {
                                        self.lbl_no_event_found.text = "No event found."
                                    } else {
                                        self.lbl_no_event_found.text = "No event found. Please click on '+' icon to add event."
                                    }
                                } else {
                                    
                                    self.lbl_no_event_found.text = "No event found."
                                    
                                }
                                
                                self.tablView.isHidden = true
                                
                            }
                            
                            
                        } else {

                            self.arr_mut_event_list.addObjects(from: ar as! [Any])
                            
                            self.lbl_no_event_found.isHidden = true
                            
                            self.tablView.isHidden = false
                            self.tablView.delegate = self
                            self.tablView.dataSource = self
                            self.tablView.reloadData()
                            self.loadMore = 1
                            
                        }
                        
                        
                        
                        /*var dict: Dictionary<AnyHashable, Any>
                         dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                         
                         let defaults = UserDefaults.standard
                         defaults.setValue(dict, forKey: "keyLoginFullData")
                         
                         
                         let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NPHomeVC")
                         self.navigationController?.pushViewController(push, animated: true)
                         */
                        
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
        } else {
            
            // guest
            self.event_list_guest_wb(pageNumber: 1)
        }
    }
    
    @objc func event_list_guest_wb(pageNumber:Int) {
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if pageNumber == 1 {
            self.arr_mut_event_list.removeAllObjects()
        }
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        
        
        let params = events_listing(action: "eventlist",
                                    userId: String(self.str_club_id),
                                    pageNo: pageNumber,
                                    date: "")
        
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
                        
                        if pageNumber == 1 {
                            
                            self.lbl_no_event_found.isHidden = false
                            
                            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
                                print(person as Any)
                                
                                if (person["role"] as! String) != "Club" {
                                    self.lbl_no_event_found.text = "No event found."
                                } else {
                                    self.lbl_no_event_found.text = "No event found. Please click on '+' icon to add event."
                                }
                            } else {
                                
                                // self.btn_add_event.isHidden = true
                                self.lbl_no_event_found.text = "No event found."
                                
                            }
                            
                            self.tablView.isHidden = true
                            
                        }
                        
                        
                    } else {
                        
                        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
                            print(person as Any)
                            
                            self.arr_mut_event_list.addObjects(from: ar as! [Any])
                            
                            // self.lbl_no_event_found.isHidden = true
                            
                            self.lbl_no_event_found.isHidden = false
                            
                            self.tablView.isHidden = false
                            self.tablView.delegate = self
                            self.tablView.dataSource = self
                            self.tablView.reloadData()
                            self.loadMore = 1
                            
                        } else {
                            
                            // self.btn_add_event.isHidden = true
                            self.arr_mut_event_list.addObjects(from: ar as! [Any])
                            
                            self.lbl_no_event_found.isHidden = true
                            
                            self.tablView.isHidden = false
                            self.tablView.delegate = self
                            self.tablView.dataSource = self
                            self.tablView.reloadData()
                            self.loadMore = 1
                            
                        }
                    }
                    
                    /*var dict: Dictionary<AnyHashable, Any>
                     dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                     
                     let defaults = UserDefaults.standard
                     defaults.setValue(dict, forKey: "keyLoginFullData")
                     
                     
                     let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NPHomeVC")
                     self.navigationController?.pushViewController(push, animated: true)
                     */
                    
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
                
        if scrollView == self.tablView {
            let isReachingEnd = scrollView.contentOffset.y >= 0
                && scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)
            if(isReachingEnd) {
                if(loadMore == 1) {
                    loadMore = 0
                    page += 1
                    print(page as Any)
                    
                    if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
                        
                        print(person["role"] as! String)
                        
                        self.event_listing_wb(pageNumber: page)
                        
                    } else {
                        
                        self.event_list_guest_wb(pageNumber: page)
                    }
                    
                }
            }
        }
    }
    
    // MARK: - DELETE TABLE -
    @objc func delete_table_wb(str_club_id:String , str_event_id:String) {
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "deleting...")
         
        let params = delete_event(action: "deleteevent",
                                  clubId: String(str_club_id),
                                  eventId: String(str_event_id))
        
        
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
                        
                        self.event_listing_wb(pageNumber: 1)
                        
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
    
    
    
    
}


//MARK:- TABLE VIEW -
extension event_list: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_mut_event_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:event_list_table_cell = tableView.dequeueReusableCell(withIdentifier: "event_list_table_cell") as! event_list_table_cell
        
        cell.backgroundColor = .clear
      
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        let item = self.arr_mut_event_list[indexPath.row] as? [String:Any]
        print(item as Any)
        
        cell.lbl_event_name.text = (item!["eventName"] as! String)
        cell.lbl_event_time.text = (item!["EventTimeTo"] as! String)+" - "+(item!["EventTimeFrom"] as! String)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: (item!["EventDate"] as! String))
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let resultString = dateFormatter.string(from: date!)
        // print(resultString)
        cell.lbl_event_dates.text = String(resultString)
        
        
        cell.lbl_event_description.text = (item!["EventDescription"] as! String)
        
        cell.img_event_image.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.img_event_image.sd_setImage(with: URL(string: (item!["Eventimage"] as! String)), placeholderImage: UIImage(named: "event"))
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            print(person as Any)
            
            if (person["role"] as! String) == "Club" {
                
                cell.btn_delete_event.isHidden = false
                cell.btn_delete_event.setImage(UIImage(systemName: "trash"), for: .normal)
                cell.btn_delete_event.tintColor = .white
                
                cell.btn_edit_event.isHidden = false
                cell.btn_edit_event.setImage(UIImage(systemName: "pencil"), for: .normal)
                cell.btn_edit_event.tintColor = .white
                
                cell.btn_edit_event.tag = indexPath.row
                cell.btn_edit_event.addTarget(self, action: #selector(edit_table_click_method), for: .touchUpInside)
                
                cell.btn_delete_event.tag = indexPath.row
                cell.btn_delete_event.addTarget(self, action: #selector(delete_table_click_method), for: .touchUpInside)
                
            } else {
                
                cell.btn_delete_event.isHidden = true
                cell.btn_edit_event.isHidden = true
                
            }
            
        } else {
            
            cell.btn_delete_event.isHidden = true
            cell.btn_edit_event.isHidden = true
            
        }
        
        return cell
    }

    @objc func edit_table_click_method(_ sender:UIButton) {
        
        let btn:UIButton! = sender
        print(btn.tag as Any)
        
        let item = self.arr_mut_event_list[btn.tag] as? [String:Any]
        print(item as Any)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            print(person as Any)
            
            if (person["role"] as! String) == "Club" {
                
                let item = self.arr_mut_event_list[btn.tag] as? [String:Any]
                print(item as Any)
                
                if "\(item!["clubId"]!)" == "\(person["userId"]!)" {
                    
                    print(" Club click ")
                    
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "edit_event_creator_id") as? edit_event_creator
                    push!.dict_get_event_details = item as NSDictionary?
                    self.navigationController?.pushViewController(push!, animated: true)
                    
                } else {
                    
                    print("customer")
                }
                
            } else {
                
                print("customer")
                
            }
            
        }
        
    }
    
    @objc func delete_table_click_method(_ sender:UIButton) {
        
        let btn:UIButton! = sender
        print(btn.tag as Any)
        
        let item = self.arr_mut_event_list[btn.tag] as? [String:Any]
        print(item as Any)
        
        let alert = NewYorkAlertController(title: String("Delete"), message: "Are you sure you want to delete '"+(item!["eventName"] as! String)+"' event ?", style: .alert)
        
        alert.addImage(UIImage.gif(name: "gif_bin"))
        
        let yes_Delete = NewYorkButton(title: "Yes, delete", style: .destructive) {
            _ in
            
             self.delete_table_wb(str_club_id: "\(item!["clubId"]!)",
                                  str_event_id: "\(item!["eventId"]!)")
        }
        
        let dismiss = NewYorkButton(title: "dismiss", style: .cancel)
        
        alert.addButtons([yes_Delete,dismiss])
        
        self.present(alert, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            print(person as Any)
            
            if (person["role"] as! String) == "Club" {
                
                let item = self.arr_mut_event_list[indexPath.row] as? [String:Any]
                print(item as Any)
                
                if "\(item!["clubId"]!)" == "\(person["userId"]!)" {
                    
                    print(" Club click ")
                    
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "edit_event_creator_id") as? edit_event_creator
                    push!.dict_get_event_details = item as NSDictionary?
                    self.navigationController?.pushViewController(push!, animated: true)
                    
                }
                
            } else {
                
                print("customer")
                
                
                
                let item = self.arr_mut_event_list[indexPath.row] as? [String:Any]
                
                self.arr_mut_save_event_image.add(item!["image"] as! String)
                
                let vc = ImagePreviewVC()
                // vc.PhotoArray = self.arr_mut_save_event_image.add(item!["image"] as! String)
                // vc.passedContentOffset = indexPath
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

class event_list_table_cell : UITableViewCell {
 
    @IBOutlet weak var img_event_image:UIImageView! {
        didSet {
            /*img_event_image.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            img_event_image.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            img_event_image.layer.shadowOpacity = 1.0
            img_event_image.layer.shadowRadius = 15.0
            img_event_image.layer.masksToBounds = false
            img_event_image.layer.cornerRadius = 14
            img_event_image.backgroundColor = .white
            img_event_image.isUserInteractionEnabled = true*/
        }
    }
    
    @IBOutlet weak var view_bg:UIView! {
        didSet {
            view_bg.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_bg.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            view_bg.layer.shadowOpacity = 1.0
            view_bg.layer.shadowRadius = 15.0
            view_bg.layer.masksToBounds = false
            view_bg.layer.cornerRadius = 15
            view_bg.backgroundColor = .white
            view_bg.isUserInteractionEnabled = true
        }
    }
    
    @IBOutlet weak var lbl_event_name:UILabel! {
        didSet {
            lbl_event_name.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_event_dates:UILabel! {
        didSet {
            lbl_event_dates.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_event_time:UILabel! {
        didSet {
            lbl_event_time.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_event_description:UILabel! {
        didSet {
            lbl_event_description.textColor = .black
        }
    }
    
    @IBOutlet weak var btn_delete_event:UIButton! {
        didSet {
            btn_delete_event.backgroundColor = .systemRed
            btn_delete_event.layer.cornerRadius = 20
            btn_delete_event.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var btn_edit_event:UIButton! {
        didSet {
            btn_edit_event.backgroundColor = .systemOrange
            btn_edit_event.layer.cornerRadius = 20
            btn_edit_event.clipsToBounds = true
        }
    }
    
}
