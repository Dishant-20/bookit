//
//  CashOutVC.swift
//  Bookit
//
//  Created by Ranjan on 21/12/21.
//

import UIKit

class CashOutVC: UIViewController {
    
    let paddingFromLeftIs:CGFloat = 0
    
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
                lblNavigationTitle.text = "CASHOUT"
                lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
                lblNavigationTitle.backgroundColor = .clear
            }
        }
                    
    // ***************************************************************** // nav
    
    @IBOutlet weak var viwTop:UIView!{
        didSet{
            viwTop.backgroundColor = BUTTON_DARK_APP_COLOR
        }
    }
    
    @IBOutlet weak var viw:UIView!{
        didSet{
            viw.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var lblWithdrawableAmount:UILabel!{
        didSet{
            lblWithdrawableAmount.text = "Withdrawable Balance: " + "$200.99"
            lblWithdrawableAmount.textColor = .white
        }
    }
    
    @IBOutlet weak var lblTotalEarning:UILabel!{
        didSet{
            lblTotalEarning.text = "$200.99"
            lblTotalEarning.textColor = .white
        }
    }
    
    @IBOutlet weak var txtAmount:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txtAmount,
                              tfName: txtAmount.text!,
                              tfCornerRadius: 10.0,
                              tfpadding: paddingFromLeftIs,
                              tfBorderWidth: 0.8,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "ENTER AMOUNT")
        }
    }
    
    @IBOutlet weak var btnSubmit:UIButton!{
        
        didSet{
            btnSubmit.layer.cornerRadius = 10.0
            btnSubmit.clipsToBounds = true
            btnSubmit.setTitle("SUBMIT REQUEST", for: .normal)
            btnSubmit.backgroundColor =  BUTTON_DARK_APP_COLOR
            btnSubmit.tintColor = .white
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = APP_BASIC_COLOR
        self.navigationController?.isNavigationBarHidden = true
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    

}
