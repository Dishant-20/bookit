//
//  MenuControllerVC.swift
//  SidebarMenu
//
//  Created by Apple  on 16/10/19.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class MenuControllerVC: UIViewController {
    
    

    let cellReuseIdentifier = "menuControllerVCTableCell"
    
    var bgImage: UIImageView?
    
    var roleIs:String!
    
    @IBOutlet weak var navigationBar:UIView!{
        didSet{
            navigationBar.backgroundColor = NAVIGATION_COLOR
        }
    }
    
    @IBOutlet weak var viewUnderNavigation:UIView! {
        didSet {
            
            viewUnderNavigation.backgroundColor = BUTTON_DARK_APP_COLOR
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "DASHBOARD"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var imgSidebarMenuImage:UIImageView! {
        didSet {
           
            //imgSidebarMenuImage.layer.borderWidth = 5.0
            //imgSidebarMenuImage.layer.borderColor = UIColor.white.cgColor
            imgSidebarMenuImage.image = UIImage(named: "logo")
            
            imgSidebarMenuImage.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            imgSidebarMenuImage.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            imgSidebarMenuImage.layer.shadowOpacity = 1.0
            imgSidebarMenuImage.layer.shadowRadius = 15.0
            imgSidebarMenuImage.layer.masksToBounds = false
            imgSidebarMenuImage.layer.cornerRadius = 15
            imgSidebarMenuImage.backgroundColor = .white
            
        }
    }
    
    
    // Customer
    var arrCustomerTitle = ["Dashboard",
                            "Edit Profile",
                            "Booking History",
                            "Help",
                            "Change Password",
                            "Logout"]
    
    // CustomerImage
    var arrCustomerImage = ["home",
                            "edit",
                            "booking",
                            "help",
                            "lock",
                            "logout"]
    
    //Club
    
    var arrClubTitle = ["Dashboard",
                        "Edit Profile",
                        "Booking History",
                        "Review",
                        "My Events",
                        "Manage Table/Price" ,
                        "Earnings",
                        "Cashout",
                        "Cashout history" ,
                        "Change Password",
                        "Help",
                        "Logout"]
    
    var arrClubImage = ["home" ,
                        "edit" ,
                        "booking" ,
                        "reviews" ,
                        "event" ,
                        "how" ,
                        "earning" ,
                        "earning" ,
                        "privacy" ,
                        "lock" ,
                        "help" ,
                        "logout"]
    
   @IBOutlet weak var lblUserName:UILabel! {
       
        didSet {
            
            lblUserName.text = "Dance Club"
            lblUserName.textColor = .white
            
        }
    }
    
    
    @IBOutlet weak var imgClub:UIImageView!{
        
        didSet{
            
            imgClub.clipsToBounds = true
            imgClub.layer.cornerRadius = 10.0
            imgClub.layer.borderWidth = 5
            imgClub.layer.borderColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1).cgColor
        }
        
    }
   
    
    @IBOutlet weak var lblPhoneNumber:UILabel! {
        didSet {
            lblPhoneNumber.textColor = .white
            //lblPhoneNumber.text = "1800-4267-3923"
            
            lblPhoneNumber.isHidden = true
        }
    }
    
    @IBOutlet var btnLocation:UIButton!{
        didSet{
            btnLocation.tintColor = .white
        }
        
    }
    
    @IBOutlet var menuButton:UIButton!
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            tbleView.delegate = self
            tbleView.dataSource = self
            tbleView.tableFooterView = UIView.init()
            tbleView.backgroundColor = BUTTON_DARK_APP_COLOR
            // tbleView.separatorInset = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50)
            tbleView.separatorColor = .systemGray6
        }
    }
    
    @IBOutlet weak var lblMainTitle:UILabel!
    @IBOutlet weak var lblAddress:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideBarMenuClick()
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        self.tbleView.separatorColor = .white // UIColor.init(red: 60.0/255.0, green: 110.0/255.0, blue: 160.0/255.0, alpha: 1)
        
        //self.tbleView.backgroundColor = UIColor.init(red: 71.0/256.0, green: 119.0/256.0, blue: 81.0/256.0, alpha: 1)
        
        self.view.backgroundColor = BUTTON_DARK_APP_COLOR // NAVIGATION_BACKGROUND_COLOR
        
        // self.sideBarMenuClick()
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
        // print(person as Any)
            
            if (person["role"] as! String) == "Customer" {
                
                imgClub.isHidden = true
                lblUserName.isHidden = true
                btnLocation.isHidden = true
            }
            
            else{
                
                imgSidebarMenuImage.isHidden = true
                imgClub.image = UIImage(named: "bar")
                lblUserName.text = "Dance Again Club"
                btnLocation.setTitle("Brooklyn, New York, USA", for: .normal)
               // btnLocation.isEnabled = false
            }
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            if person["role"] as! String == "Customer" {
               
                print(person as Any)
                
               self.lblUserName.text = (person["fullName"] as! String)
                self.btnLocation.setTitle((person["address"] as! String), for: .normal)
               
               self.imgSidebarMenuImage.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
               self.imgSidebarMenuImage.sd_setImage(with: URL(string: (person["image"] as! String)), placeholderImage: UIImage(named: "logo"))
               
            }
             
             else {
                 
                 print(person as Any)
                 
                 self.lblUserName.text = (person["fullName"] as! String)
                 // self.lblAddress.text = (person["address"] as! String)
                 self.btnLocation.setTitle((person["address"] as! String), for: .normal)
                 
                self.imgClub.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
                self.imgClub.sd_setImage(with: URL(string: (person["image"] as! String)), placeholderImage: UIImage(named: "logo"))
                 
            }
             
        }
        
    }
    
    
   
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    @objc func sideBarMenuClick() {
        
        if revealViewController() != nil {
        menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
          }
    }
    
    @objc func yesLogout() {
        
        UserDefaults.standard.set("", forKey: "keyLoginFullData")
        UserDefaults.standard.set(nil, forKey: "keyLoginFullData")
        
        UserDefaults.standard.set("", forKey: "keySetToBackOrMenu")
        UserDefaults.standard.set(nil, forKey: "keySetToBackOrMenu")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
        self.view.window?.rootViewController = sw
        let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeVC")
        let navigationController = UINavigationController(rootViewController: destinationController!)
        sw.setFront(navigationController, animated: true)
        
    }
    
}

extension MenuControllerVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
            
            if (person["role"] as! String) == "Customer" {
                
                return arrCustomerTitle.count
                
            } else if (person["role"] as! String) == "Club" {
                
                return arrClubTitle.count
                
            } else {
                return 0
            }
            
        }
        
        else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MenuControllerVCTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! MenuControllerVCTableCell
        
        cell.backgroundColor = BUTTON_DARK_APP_COLOR
      
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            if (person["role"] as! String) == "Customer" {
                
                cell.lblName.text = arrCustomerTitle[indexPath.row]
                cell.imgProfile.image = UIImage(named: arrCustomerImage[indexPath.row])
                
            }
                else if (person["role"] as! String) == "Club" {
                
                cell.lblName.text = arrClubTitle[indexPath.row]
                cell.imgProfile.image = UIImage(named: arrClubImage[indexPath.row])
            }
            
        }
        return cell
            
            
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            print(person as Any)
            
            if (person["role"] as! String) == "Customer" {
                
                if arrCustomerTitle[indexPath.row] == "Change Password" {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                }
                
                else if arrCustomerTitle[indexPath.row] == "Edit Profile" {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "REditProfileId")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                }
                else if arrCustomerTitle[indexPath.row] == "Booking History"
                    
                {
                   
                   let storyboard = UIStoryboard(name: "Main", bundle: nil)
                   let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                   self.view.window?.rootViewController = sw
                   let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "BookingHistoryVC")
                   let navigationController = UINavigationController(rootViewController: destinationController!)
                   sw.setFront(navigationController, animated: true)
                   
               }
                else if arrCustomerTitle[indexPath.row] == "Help"
                    
                {
                   
                   let storyboard = UIStoryboard(name: "Main", bundle: nil)
                   let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                   self.view.window?.rootViewController = sw
                   let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "HelpVC")
                   let navigationController = UINavigationController(rootViewController: destinationController!)
                   sw.setFront(navigationController, animated: true)
                   
               }
                
                else if arrCustomerTitle[indexPath.row] == "Dashboard"
                    
                {
                   
                   let storyboard = UIStoryboard(name: "Main", bundle: nil)
                   let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                   self.view.window?.rootViewController = sw
                   let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "NPHomeVC")
                   let navigationController = UINavigationController(rootViewController: destinationController!)
                   sw.setFront(navigationController, animated: true)
                   
               }
                
                else if arrCustomerTitle[indexPath.row] == "Logout"
                {
                    
                    let alert = UIAlertController(title: String("Logout"), message: String("Are you sure your want to logout ?"), preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "Yes, Logout", style: .default, handler: { action in
                        self.yesLogout()
                        
                    }))
                    
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    
                    
                }
                
                
            }
            else if (person["role"] as! String) == "Club"
                        
            {
             
                if arrClubTitle[indexPath.row] == "Change Password" {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                }
                
                
                
                else if arrClubTitle[indexPath.row] == "Cashout history" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "cashout_list_id")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                }
                
                else if arrClubTitle[indexPath.row] == "My Events" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "event_list_id")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                }
                
                else if arrClubTitle[indexPath.row] == "Edit Profile" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "club_edit_profile_id")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                }
                
                else if arrClubTitle[indexPath.row] == "Earnings" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "earnings_new_id")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                }
                
                else if arrClubTitle[indexPath.row] == "Cashout" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "CashOutVC")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                }
                
                else if arrClubTitle[indexPath.row] == "Booking History"
                    
                {
                   
                   let storyboard = UIStoryboard(name: "Main", bundle: nil)
                   let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                   self.view.window?.rootViewController = sw
                   let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "pre_booking_history_id")
                   let navigationController = UINavigationController(rootViewController: destinationController!)
                   sw.setFront(navigationController, animated: true)
                   
               }
                
                else if arrClubTitle[indexPath.row] == "Review" {
                   
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                   let storyboard = UIStoryboard(name: "Main", bundle: nil)
                   let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                   self.view.window?.rootViewController = sw
                   let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "NPClubReviewVC") as? NPClubReviewVC
                    
                    destinationController!.str_check_review_online_Status = "yes"
                    
                   let navigationController = UINavigationController(rootViewController: destinationController!)
                   sw.setFront(navigationController, animated: true)
                   
               }
                
                else if arrClubTitle[indexPath.row] == "Manage Table/Price" {
                   
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
                        
                        if (person["role"] as! String) == "Club" {
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                            self.view.window?.rootViewController = sw
                            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "NPClubTableDetailVC") as? NPClubTableDetailVC
                            
                            let item :NSDictionary = person as NSDictionary
                            
                            destinationController!.club_Details = item
                            
                            let navigationController = UINavigationController(rootViewController: destinationController!)
                            sw.setFront(navigationController, animated: true)
 
                        }
                    }
                    
                    
                   
                   
               }
                
                else if arrClubTitle[indexPath.row] == "Help"
                    
                {
                   
                   let storyboard = UIStoryboard(name: "Main", bundle: nil)
                   let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                   self.view.window?.rootViewController = sw
                   let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "HelpVC")
                   let navigationController = UINavigationController(rootViewController: destinationController!)
                   sw.setFront(navigationController, animated: true)
                   
               }
                
                else if arrClubTitle[indexPath.row] == "Dashboard"
                    
                {
                   
                   let storyboard = UIStoryboard(name: "Main", bundle: nil)
                   let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                   self.view.window?.rootViewController = sw
                   let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "NPClubDetailVC")
                   let navigationController = UINavigationController(rootViewController: destinationController!)
                   sw.setFront(navigationController, animated: true)
                   
               }
                
                else if arrClubTitle[indexPath.row] == "Logout"
                    
                {
                    
                    let alert = UIAlertController(title: String("Logout"), message: String("Are you sure your want to logout ?"), preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "Yes, Logout", style: .default, handler: { action in
                        self.yesLogout()
                        
                    }))
                    
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    
                    
                }
                
            }
            
        }
        
        /*if arrCustomerTitle[indexPath.row] == "Change Password" {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
            self.view.window?.rootViewController = sw
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC")
            let navigationController = UINavigationController(rootViewController: destinationController!)
            sw.setFront(navigationController, animated: true)
            
        }
        
        else if arrCustomerTitle[indexPath.row] == "Booking History"
            
        {
           
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
           self.view.window?.rootViewController = sw
           let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "BookingHistoryVC")
           let navigationController = UINavigationController(rootViewController: destinationController!)
           sw.setFront(navigationController, animated: true)
           
       }
        else if arrCustomerTitle[indexPath.row] == "Help"
            
        {
           
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
           self.view.window?.rootViewController = sw
           let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "HelpVC")
           let navigationController = UINavigationController(rootViewController: destinationController!)
           sw.setFront(navigationController, animated: true)
           
       }
        
        else if arrCustomerTitle[indexPath.row] == "Dashboard"
            
        {
           
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
           self.view.window?.rootViewController = sw
           let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "NPHomeVC")
           let navigationController = UINavigationController(rootViewController: destinationController!)
           sw.setFront(navigationController, animated: true)
           
       }*/
            
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension MenuControllerVC: UITableViewDelegate {
    
}
