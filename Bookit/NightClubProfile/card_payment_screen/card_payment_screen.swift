//
//  card_payment_screen.swift
//  Bookit
//
//  Created by Dishant Rajput on 29/03/23.
//

import UIKit

class card_payment_screen: UIViewController ,  UITextFieldDelegate {

    var str_price:String!
    
    let paddingFromLeftIs:CGFloat = 40
    
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
                lblNavigationTitle.text = "Card Information"
                lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
                lblNavigationTitle.backgroundColor = .clear
            }
        }
                    
    // ***************************************************************** // nav
    
    @IBOutlet weak var txt_card_name:UITextField! {
        didSet {
            txt_card_name.setLeftPaddingPoints(40)
            txt_card_name.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            txt_card_name.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            txt_card_name.layer.shadowOpacity = 1.0
            txt_card_name.layer.shadowRadius = 15.0
            txt_card_name.layer.masksToBounds = false
            txt_card_name.layer.cornerRadius = 15
            txt_card_name.backgroundColor = .white
            txt_card_name.textColor = .black
            txt_card_name.placeholder = "Card name"
        }
    }
    
    @IBOutlet weak var txt_card_number:UITextField! {
        didSet {
            txt_card_number.setLeftPaddingPoints(40)
            txt_card_number.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            txt_card_number.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            txt_card_number.layer.shadowOpacity = 1.0
            txt_card_number.layer.shadowRadius = 15.0
            txt_card_number.layer.masksToBounds = false
            txt_card_number.layer.cornerRadius = 15
            txt_card_number.backgroundColor = .white
            txt_card_number.textColor = .black
            txt_card_number.placeholder = "Card number"
            txt_card_number.keyboardType = . numberPad
        }
    }
    
    @IBOutlet weak var txt_exp_month:UITextField! {
        didSet {
            txt_exp_month.setLeftPaddingPoints(40)
            txt_exp_month.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            txt_exp_month.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            txt_exp_month.layer.shadowOpacity = 1.0
            txt_exp_month.layer.shadowRadius = 15.0
            txt_exp_month.layer.masksToBounds = false
            txt_exp_month.layer.cornerRadius = 15
            txt_exp_month.backgroundColor = .white
            txt_exp_month.textColor = .black
            txt_exp_month.placeholder = "month ( 12 )"
            txt_exp_month.keyboardType = . numberPad
        }
    }
    
    @IBOutlet weak var txt_exp_year:UITextField! {
        didSet {
            txt_exp_year.setLeftPaddingPoints(40)
            txt_exp_year.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            txt_exp_year.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            txt_exp_year.layer.shadowOpacity = 1.0
            txt_exp_year.layer.shadowRadius = 15.0
            txt_exp_year.layer.masksToBounds = false
            txt_exp_year.layer.cornerRadius = 15
            txt_exp_year.backgroundColor = .white
            txt_exp_year.textColor = .black
            txt_exp_year.placeholder = "year ( 25 )"
            txt_exp_year.keyboardType = . numberPad
        }
    }
    
    @IBOutlet weak var txt_cvv:UITextField! {
        didSet {
            txt_cvv.setLeftPaddingPoints(40)
            txt_cvv.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            txt_cvv.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            txt_cvv.layer.shadowOpacity = 1.0
            txt_cvv.layer.shadowRadius = 15.0
            txt_cvv.layer.masksToBounds = false
            txt_cvv.layer.cornerRadius = 15
            txt_cvv.backgroundColor = .white
            txt_cvv.textColor = .black
            txt_cvv.keyboardType = . numberPad
            txt_cvv.placeholder = "cvv"
        }
    }
    
    @IBOutlet weak var btn_submit:UIButton! {
        didSet {
            btn_submit.layer.cornerRadius = 27.5
            btn_submit.clipsToBounds = true
            btn_submit.setTitle("Submit", for: .normal)
            btn_submit.backgroundColor =  BUTTON_DARK_APP_COLOR
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white//APP_BASIC_COLOR
        self.navigationController?.isNavigationBarHidden = true
        
        self.txt_card_name.delegate = self
        self.txt_card_number.delegate = self
        self.txt_exp_year.delegate = self
        self.txt_exp_month.delegate = self
        self.txt_cvv.delegate = self
        
        // back
        self.btnBack.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        
        //
        self.btn_submit.addTarget(self, action: #selector(validation_before), for: .touchUpInside)
    }
    
    @objc func back_click_method() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //
    @objc func validation_before() {
        
        if (self.txt_card_name.text!) == "" {
            
            let alert = UIAlertController(title: String("Alert").uppercased(), message: String("Card name should not be empty."), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            
        } else if (self.txt_card_number.text!) == "" {
            
            let alert = UIAlertController(title: String("Alert").uppercased(), message: String("Card number should not be empty."), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            
        } else if (self.txt_exp_month.text!) == "" {
            
            let alert = UIAlertController(title: String("Alert").uppercased(), message: String("Exp month should not be empty."), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            
        } else if (self.txt_exp_year.text!) == "" {
            
            let alert = UIAlertController(title: String("Alert").uppercased(), message: String("Exp year should not be empty."), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            
        } else if (self.txt_cvv.text!) == "" {
            
            let alert = UIAlertController(title: String("Alert").uppercased(), message: String("CVV should not be empty."), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            
        } else {
            
            self.submit_click_method()
            
        }

    }
    
    @objc func submit_click_method() {

        let custom_save_card_details = [
            "card_name"     : String(self.txt_card_name.text!),
            "card_number"   : String(self.txt_card_number.text!),
            "card_month"    : String(self.txt_exp_month.text!),
            "card_year"     : String(self.txt_exp_year.text!),
            "card_cvv"      : String(self.txt_cvv.text!),
            "card_amount"   : String(self.str_price)
        ]
        
        let defaults = UserDefaults.standard
        defaults.setValue(custom_save_card_details, forKey: "key_save_card_details")
        
        self.navigationController?.popViewController(animated: true)
        
        
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.txt_card_number {
            let maxLength = 16
            let currentString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)

            return newString.count <= maxLength
            
        } else if textField == self.txt_exp_month {
            let maxLength = 2
            let currentString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)

            return newString.count <= maxLength
            
        } else if textField == self.txt_exp_year {
            let maxLength = 2
            let currentString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)

            return newString.count <= maxLength
            
        }  else if textField == self.txt_cvv {
            let maxLength = 3
            let currentString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)

            return newString.count <= maxLength
        }
        
        
        
        
        return true
        
    }

}
