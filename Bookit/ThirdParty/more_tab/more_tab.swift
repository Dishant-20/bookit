//
//  more_tab.swift
//  Bookit
//
//  Created by Apple on 05/04/22.
//

import UIKit
import SDWebImage
import Alamofire

class more_tab: UIViewController {

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
            lblNavigationTitle.text = "Home"
            lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
            lblNavigationTitle.backgroundColor = .clear
        }
    }
    
    // ***************************************************************** // nav
    
    @IBOutlet weak var tablView:UITableView!{
        didSet {
            
            tablView.backgroundColor =  .clear
            tablView.isHidden = false
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
        
        tablView.delegate = self
        tablView.dataSource = self
        tablView.reloadData()
    }
    
    @objc func privacy_click_method() {
        
        guard let url = URL(string: bookit_privacy) else {
             return
        }

        if UIApplication.shared.canOpenURL(url) {
             UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
    }
    
    @objc func terms_click_method() {
        
        guard let url = URL(string: bookit_terms) else {
             return
        }

        if UIApplication.shared.canOpenURL(url) {
             UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
    }
}

//MARK:- TABLE VIEW -
extension more_tab: UITableViewDataSource , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0 {
            
            let cell:more_tab_table_cell = tableView.dequeueReusableCell(withIdentifier: "more_tab_table_cell_one") as! more_tab_table_cell
            
            cell.backgroundColor = .clear //APP_BASIC_COLOR
            
             cell.preservesSuperviewLayoutMargins = false
             cell.separatorInset = UIEdgeInsets.zero
             cell.layoutMargins = UIEdgeInsets.zero
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
             // print(person as Any)
                
                cell.lbl_username.text = (person["fullName"] as! String)
                
                cell.img_profile.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
                cell.img_profile.sd_setImage(with: URL(string: (person["image"] as! String)), placeholderImage: UIImage(named: "logo"))
                
                cell.btn_phone.isUserInteractionEnabled = false
                
                if (person["contactNumber"] as! String) == "" {
                    cell.btn_phone.setTitle("N.A.", for: .normal)
                } else {
                    cell.btn_phone.setTitle((person["contactNumber"] as! String), for: .normal)
                }
                
            }
            
            return cell
            
        } else if indexPath.row == 1 {
            
            let cell:more_tab_table_cell = tableView.dequeueReusableCell(withIdentifier: "more_tab_table_cell_two") as! more_tab_table_cell
            
            cell.backgroundColor = .clear //APP_BASIC_COLOR
            
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.accessoryType = .none
            
            return cell
            
        } else if indexPath.row == 2 {
            
            let cell:more_tab_table_cell = tableView.dequeueReusableCell(withIdentifier: "more_tab_table_cell_three") as! more_tab_table_cell
            
            cell.backgroundColor = .clear //APP_BASIC_COLOR
            
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            return cell
            
        } else if indexPath.row == 3 {
            
            let cell:more_tab_table_cell = tableView.dequeueReusableCell(withIdentifier: "more_tab_table_cell_four") as! more_tab_table_cell
            
            cell.backgroundColor = .clear //APP_BASIC_COLOR
            
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            return cell
            
        } else {
            
            let cell:more_tab_table_cell = tableView.dequeueReusableCell(withIdentifier: "more_tab_table_cell_five") as! more_tab_table_cell
            
            cell.backgroundColor = .clear //APP_BASIC_COLOR
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.btn_terms.addTarget(self, action: #selector(terms_click_method), for: .touchUpInside)
            cell.btn_privacy.addTarget(self, action: #selector(privacy_click_method), for: .touchUpInside)
            
            
            return cell
            
        }
        
        

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 1 {
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "REditProfileId")
            self.navigationController?.pushViewController(push, animated: true)
            
        } else if indexPath.row == 2 {
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChangePasswordVC")
            self.navigationController?.pushViewController(push, animated: true)
            
        } else if indexPath.row == 3 {
            
            let alert = NewYorkAlertController(title: "Logout", message: String("Are your sure you want to logout ?"), style: .alert)
            
            let yes_logout = NewYorkButton(title: "yes, logout", style: .destructive) {
                _ in
                
                
                self.logout_my_app()
            }

            
            let cancel = NewYorkButton(title: "dismiss", style: .cancel)
            alert.addButtons([cancel,yes_logout])
            
            self.present(alert, animated: true)
            
        }
    }
    
    
    
    @objc func logout_my_app() {
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // let str:String = person["role"] as! String
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params = Bookit.logout_my_app(action: "logout",
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
                        
                        ERProgressHud.sharedInstance.hide()
                        
                        self.yesLogout()
                        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 300
        } else {
            return 80
        }
    }
    
    
    
}

class more_tab_table_cell:UITableViewCell {
    
    @IBOutlet weak var view_cell_1_bg:UIView! {
        didSet {
            view_cell_1_bg.backgroundColor = .clear
        }
    }
    
    // 18 46 138
    @IBOutlet weak var img_profile:UIImageView! {
        didSet {
            img_profile.layer.cornerRadius = 80
            img_profile.clipsToBounds = true
            img_profile.layer.borderColor = UIColor.init(red: 18.0/255.0, green: 46.0/255.0, blue: 138.0/255.0, alpha: 1).cgColor
            img_profile.layer.borderWidth = 5
        }
    }
    
    @IBOutlet weak var lbl_username:UILabel! {
        didSet {
            lbl_username.textColor = .white
        }
    }
    
    @IBOutlet weak var btn_phone:UIButton! {
        didSet {
            btn_phone.setTitleColor(.white, for: .normal)
        }
    }
    
    @IBOutlet weak var btn_terms:UIButton! {
        didSet {
            btn_terms.setTitleColor(.systemOrange, for: .normal)
            btn_terms.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var btn_dash:UIButton! {
        didSet {
            btn_dash.setTitleColor(.white, for: .normal)
            btn_dash.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var btn_privacy:UIButton! {
        didSet {
            btn_privacy.setTitleColor(.systemOrange, for: .normal)
            btn_privacy.backgroundColor = .clear
        }
    }
    
    
    @IBOutlet weak var lbl_edit_profile:UILabel! {
        didSet {
            lbl_edit_profile.textColor = .white
        }
    }
    
    @IBOutlet weak var lbl_change_password:UILabel! {
        didSet {
            lbl_change_password.textColor = .white
        }
    }
    
    @IBOutlet weak var lbl_logout:UILabel! {
        didSet {
            lbl_logout.textColor = .systemRed
        }
    }
    
    
}
