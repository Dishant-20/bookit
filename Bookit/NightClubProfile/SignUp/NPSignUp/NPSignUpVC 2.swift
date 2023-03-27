//
//  NPSignUpVC.swift
//  Bookit
//
//  Created by Ranjan on 20/12/21.
//

import UIKit
import Alamofire
import SDWebImage

var clubName:String = ""
var clubEmail:String = ""
var clubPhone:String = ""
var clubPassword:String = ""

class NPSignUpVC: UIViewController {
    

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
    
    @objc func callBeforeContinue() {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        
        let cell = self.tablView.cellForRow(at: indexPath) as! NPSignUpTableViewCell
        
        if String(cell.txtName.text!) == "" {
            self.fieldShoulNotBeEmptyPopup(strTitle: "Name")
        } else if String(cell.txtEmailAddress.text!) == "" {
            self.fieldShoulNotBeEmptyPopup(strTitle: "Email")
        } else if String(cell.txtPassword.text!) == "" {
            self.fieldShoulNotBeEmptyPopup(strTitle: "Password")
        } else {
            btnSignUpTapped()
        }
        
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func fieldShoulNotBeEmptyPopup(strTitle:String) {
        
        let alert = UIAlertController(title: "Alert", message: String(strTitle)+" Field should not be empty", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true)
        
    }
    

}

//MARK:- TABLE VIEW -
extension NPSignUpVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NPSignUpTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NPSignUpTableCell") as! NPSignUpTableViewCell
        
        cell.backgroundColor = APP_BASIC_COLOR
      
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.btnSignUp.addTarget(self, action: #selector(callBeforeContinue), for: .touchUpInside)
        cell.btnDontHavAcount.addTarget(self, action: #selector(btnDontHavAcountTapped), for: .touchUpInside)
        
        
        return cell
    }

    @objc func btnSignUpTapped(){
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! NPSignUpTableViewCell
        
        clubName = cell.txtName.text!
        clubEmail = cell.txtEmailAddress.text!
        clubPhone = cell.txtPhone.text!
        clubPassword = cell.txtPassword.text!
        
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddressVC") as? AddressVC
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
        
        
        print(clubName)
        print(clubEmail)
    }
    
    @objc func btnDontHavAcountTapped(){
        
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
    
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 800
    }
    
    
}

extension NPSignUpVC: UITableViewDelegate {
    
}
