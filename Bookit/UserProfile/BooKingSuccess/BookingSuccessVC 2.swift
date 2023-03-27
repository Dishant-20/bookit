//
//  BookingSuccessVC.swift
//  Bookit
//
//  Created by Ranjan on 18/12/21.
//

import UIKit
import SPConfetti

class BookingSuccessVC: UIViewController {
    
    var str_booked_price:String!
    
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
            lblNavigationTitle.text = "BOOKING SUCCESS"
            lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
            lblNavigationTitle.backgroundColor = .clear
        }
    }
    
    // ***************************************************************** // nav
    
    @IBOutlet weak var lblPaymentAmount:UILabel!{
        didSet{
            lblPaymentAmount.text =
            """
            
            """
            lblPaymentAmount.textColor = .black
        }
    }
    
    @IBOutlet weak var lblDetails:UILabel!{
        didSet{
            lblDetails.text =
            """
            Please find booking details info.\nof the night club below.
            """
            lblDetails.textColor = .black
        }
    }
    
    @IBOutlet weak var btnDetails:UIButton! {
        didSet {
            btnDetails.backgroundColor = NAVIGATION_COLOR
            btnDetails.setTitle("DETAILS", for: .normal)
            btnDetails.layer.cornerRadius = 27.5
            btnDetails.clipsToBounds = true
            btnDetails.tintColor = .white
            
            // btnSignIn.addTarget(self, action: #selector(btnSignInTapped), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var btnCancel:UIButton! {
        didSet {
            btnCancel.backgroundColor = BUTTON_DARK_APP_COLOR
            btnCancel.setTitle("CANCEL", for: .normal)
            btnCancel.layer.cornerRadius = 27.5
            btnCancel.clipsToBounds = true
            btnCancel.tintColor = .white
        }
    }
    
    @IBOutlet weak var btnBookAnotherTable:UIButton! {
        didSet {
            btnBookAnotherTable.backgroundColor = NAVIGATION_COLOR
            btnBookAnotherTable.setTitle("BOOK ANOTHER TABLE", for: .normal)
            //btnBookAnotherTable.layer.cornerRadius = 27.5
            //btnBookAnotherTable.clipsToBounds = true
            btnBookAnotherTable.tintColor = .white
        }
    }
    
    @IBOutlet weak var viw:UIView! {
        didSet {
            viw.backgroundColor = .clear
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        // print(self.get_booked_table_result as Any)
        
        SPConfetti.startAnimating(.centerWidthToDown, particles: [.triangle, .arc ,.star])
        
        self.lblPaymentAmount.text = "Your payment of $"+String(self.str_booked_price)+"  has been confirmned!"
        
        self.btnBookAnotherTable.addTarget(self, action: #selector(book_another_table_click_method), for: .touchUpInside)
        
        self.btnCancel.addTarget(self, action: #selector(book_another_table_click_method), for: .touchUpInside)
        
    }
    
    @objc func book_another_table_click_method() {
        
        SPConfetti.stopAnimating()
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NPHomeVC")
        self.navigationController?.pushViewController(push, animated: true)
        
    }
    
    
    
}
