//
//  SignUpVC.swift
//  Bookit
//
//  Created by Ranjan on 18/12/21.
//

import UIKit
import Alamofire

class SignUpVC: UIViewController {
    
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
                lblNavigationTitle.text = "REGISTER AS NIGHT CLUB"
                lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
                lblNavigationTitle.backgroundColor = .clear
            }
        }
                    
    // ***************************************************************** // nav
   
    @IBOutlet weak var tablView:UITableView!{
        didSet {
            tablView.delegate = self
            tablView.dataSource = self
            tablView.backgroundColor =  APP_BASIC_COLOR
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = APP_BASIC_COLOR
        self.navigationController?.isNavigationBarHidden = true
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func callBeforeRegister() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! SignUpTableViewCell
        
        
        if String(cell.txtName.text!) == "" {
            self.fieldShoulNotBeEmptyPopup(strTitle: "Name")
        } else if String(cell.txtEmailAddress.text!) == "" {
            self.fieldShoulNotBeEmptyPopup(strTitle: "Email")
        } else if String(cell.txtPassword.text!) == "" {
            self.fieldShoulNotBeEmptyPopup(strTitle: "Password")
        } else {
            self.registerCustomerWB()
        }
        
        
        
    }
    
    @objc func fieldShoulNotBeEmptyPopup(strTitle:String) {
        
        let alert = UIAlertController(title: "Alert", message: String(strTitle)+" Field should not be empty", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true)
        
    }
    
    @objc func registerCustomerWB() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! SignUpTableViewCell
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        
        // if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
        
        // let x : Int = person["userId"] as! Int
        // let myString = String(x)
        
        let params = CustomerRegister(action: "registration",
                                      banner:"",
                                      fullName: String(cell.txtName.text!),
                                      email: String(cell.txtEmailAddress.text!),
                                      password: String(cell.txtPassword.text!),
                                      contactNumber: String(cell.txtPhone.text!),
                                      address:"",
                                      device: "iOS",
                                      role: "Customer",
                                      latitude: "",
                                      longitude:"",
                                      deviceToken:"",
                                      countryId:"",
                                      image: "",
                                      state: "",
                                      openTime: "",
                                      closeTime: ""
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
                            
                            let alert = UIAlertController(title: String(strSuccess).uppercased(), message: String(strSuccess2), preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                                self.backClickMethod()
                            }))
                            
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
extension SignUpVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SignUpTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SignUpTableCell") as! SignUpTableViewCell
        
        cell.backgroundColor = APP_BASIC_COLOR
      
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.btnSignUp.addTarget(self, action: #selector(callBeforeRegister), for: .touchUpInside)
        
        return cell
    }

    
    @objc func btnSignUpTapped(){
        
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NPHomeVC") as? NPHomeVC
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1000
    }
    
    
}

extension SignUpVC: UITableViewDelegate {
    
}
