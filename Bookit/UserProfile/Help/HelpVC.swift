//
//  HelpVC.swift
//  Bookit
//
//  Created by Ranjan on 20/12/21.
//

import UIKit
import Alamofire
import MessageUI

class HelpVC: UIViewController , MFMailComposeViewControllerDelegate {
    
    var dict: Dictionary<AnyHashable, Any> = [:]
    
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
            lblNavigationTitle.text = "Help"
            lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
            lblNavigationTitle.backgroundColor = .clear
        }
    }
    
    // ***************************************************************** // nav
    
    @IBOutlet weak var viw:UIView!{
        didSet{
            viw.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var btnPhone:UIButton! {
        didSet {
            //btnPhone.layer.cornerRadius = 27.5
            //btnPhone.clipsToBounds = true
            btnPhone.setTitle("1800-234-5678", for: .normal)
            btnPhone.backgroundColor =  .clear
            btnPhone.tintColor = .white
            btnPhone.setTitleColor(.white, for: .normal)
            btnPhone.setImage(UIImage(systemName: "phone.fill"), for: .normal)
        }
    }
    
    @IBOutlet weak var btnEmail:UIButton! {
        didSet {
            btnEmail.layer.cornerRadius = 27.5
            btnEmail.clipsToBounds = true
            btnEmail.setTitle("support@bookit.com", for: .normal)
            btnEmail.backgroundColor =  .clear
            btnEmail.tintColor = .white
            btnEmail.setTitleColor(.white, for: .normal)
            btnEmail.setImage(UIImage(systemName: "envelope.fill"), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = APP_BASIC_COLOR
        self.navigationController?.isNavigationBarHidden = true
        // self.sideBarMenuClick()
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
        
            if (person["role"] as! String) == "Club" {
                
                self.btnBack.isHidden = false
                self.btnBack.setImage(UIImage(systemName: "arrow.left"), for: .normal)
                self.btnBack.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
                
            } else {
                self.btnBack.isHidden = true
            }
            
        }
        
        self.help_wb()
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
    
    
    
    @objc func help_wb() {
        
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        
        
        let params = help_wb_call(action:"help")
        
        print(params as Any)
        
        AF.request(APPLICATION_BASE_URL,
                   method: .post,
                   parameters: params,
                   encoder: JSONParameterEncoder.default).responseJSON { [self] response in
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
                    
                    
                    self.dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                    
                    self.btnEmail.setTitle((dict["eamil"] as! String), for: .normal)
                    self.btnPhone.setTitle((dict["phone"] as! String), for: .normal)
                    
                    self.btnPhone.addTarget(self, action: #selector(phone_call_click_method), for: .touchUpInside)
                    self.btnEmail.addTarget(self, action: #selector(send_mail_click_method), for: .touchUpInside)
                    
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
    
    // MARK: - PHONE CALL -
    @objc func phone_call_click_method() {
        
        if let url = URL(string: "tel://\(dict["phone"] as! String)"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        }
    }
    
    // MARK: - SEND EMAIL -
    @objc func send_mail_click_method() {
        self.sendEmail()
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([(dict["eamil"] as! String)])
            mail.setMessageBody("<p>Type your message here</p>", isHTML: true)

            present(mail, animated: true)
        } else {
            // show failure alert
            
            let alert = NewYorkAlertController(title: "Error", message: String("Can't send email"), style: .alert)
                        
            let cancel = NewYorkButton(title: "Ok", style: .cancel)
            alert.addButtons([cancel])
            
            self.present(alert, animated: true)
            
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}
