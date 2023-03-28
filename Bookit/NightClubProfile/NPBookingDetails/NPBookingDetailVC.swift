//
//  NPBookingDetailVC.swift
//  Bookit
//
//  Created by Ranjan on 28/12/21.
//

import UIKit
import Alamofire
import SDWebImage

class NPBookingDetailVC: UIViewController {
    
    var dict_get_club_booking_details:NSDictionary!
    
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
                lblNavigationTitle.text = "Booking Details"
                lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
                lblNavigationTitle.backgroundColor = .clear
            }
        }
                    
    // ***************************************************************** // nav
   
    @IBOutlet weak var tablView:UITableView!{
        didSet {
            tablView.delegate = self
            tablView.dataSource = self
            tablView.backgroundColor =  .white
        }
    }
    
    @IBOutlet weak var btnReport:UIButton!{
        didSet{
            
            btnReport.backgroundColor = .systemYellow
            btnReport.tintColor = .black
            btnReport.layer.cornerRadius = 15.0
            btnReport.clipsToBounds = true
        }
    }

    
    @IBOutlet weak var btnPay:UIButton!{
        didSet{
            
            btnPay.backgroundColor = BUTTON_DARK_APP_COLOR
            btnPay.tintColor = .white
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        self.tablView.separatorColor = .clear
        
        
        self.btnBack.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
    }
    
    @objc func back_click_method() {
        self.navigationController?.popViewController(animated: true)
    }
    
}


//MARK:- TABLE VIEW -
extension NPBookingDetailVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell:NPBookingDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NPBookingDetailTableViewCell") as! NPBookingDetailTableViewCell
        
        cell.backgroundColor = .white
      
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        // cell.imgBG.image = UIImage(named: "bar")
        
       // cell.btnSignUp.addTarget(self, action: #selector(btnSignUpTapped), for: .touchUpInside)
        
        
        cell.lblName.text = (self.dict_get_club_booking_details["fullName"] as! String)
        //cell.btnPhone.setTitle((self.dict_get_booking_details["ClubcontactNumber"] as! String), for: .normal)
        cell.btnLocation.setTitle("N.A.", for: .normal)
        
        let x_3 : Int = self.dict_get_club_booking_details["totalAmount"] as! Int
        let myString_3 = String(x_3)
        
        let x_4 : Int = self.dict_get_club_booking_details["TabletotalSeat"] as! Int
        let myString_4 = String(x_4)
        
        // let totalAmount = myString_2
        
        // let advance:Double = myString_3
        
        // let x : Int = self.dict_get_booking_details["userId"] as! Int
        // let myString = String(x)
        
    
        
        if (self.dict_get_club_booking_details["contactNumber"] as! String) == "" {
            cell.lblPhone.text       = "N.A."
        } else {
            
            cell.lblPhone.text = (self.dict_get_club_booking_details["contactNumber"] as! String)
        }
        
        
        let add_booking_fee_to_total = Double("\(self.dict_get_club_booking_details["processingFee"]!)")
        let total_amount_after_percent_calulate: String = String(format: "%.2f", add_booking_fee_to_total!)
        cell.lbl_booking_fee.text = "$"+String(total_amount_after_percent_calulate)
        
        
        cell.lblBookitFee.text = "$\(self.dict_get_club_booking_details["adminFee"]!)"
        
        if (self.dict_get_club_booking_details["bookingDate"] as! String) == "" {
            cell.lblDate.text       = "N.A."
        } else {
            cell.lblDate.text       = (self.dict_get_club_booking_details["bookingDate"] as! String)
        }
        
        
        cell.lblTableNum.text   = (self.dict_get_club_booking_details["tableName"] as! String)
        
        // print(self.dict_get_booking_details as Any)
        
        // print(self.dict_get_booking_details["bookingDate"])
        
        
        if (self.dict_get_club_booking_details["bookingDate"] as! String) == "" {
            cell.lblDate.text       = "N.A."
        } else {
            cell.lblDate.text       = (self.dict_get_club_booking_details["bookingDate"] as! String)
        }
        
        
        
        // cell.lblTime.text       = "N.A."
        cell.lblTotalSeat.text  = "\(self.dict_get_club_booking_details["TabletotalSeat"]!)"// myString_4
        cell.lblTotalAmount.text = "$"+myString_3
        
        // let x_2 : Int = self.dict_get_booking_details["advancePayment"] as! Int
        // let myString_2 = String(x_2)
        
        if self.dict_get_club_booking_details["advancePayment"] is String {
            print("Yes, it's a String")

            cell.lblAdvancedPay.text = "$"+(self.dict_get_club_booking_details["advancePayment"] as! String)
            
        } else if self.dict_get_club_booking_details["advancePayment"] is Int {
            print("It is Integer")
                        
            let x2 : Int = (self.dict_get_club_booking_details["advancePayment"] as! Int)
            let myString2 = String(x2)
            // self.lblPayableAmount.text = "Membership Amount : $ "+myString2
                        
             
            cell.lblAdvancedPay.text = "$"+String(myString2)
            
        } else {
            print("i am number")
                        
            let temp:NSNumber = self.dict_get_club_booking_details["advancePayment"] as! NSNumber
            let tempString = temp.stringValue
            
            cell.lblAdvancedPay.text = "$"+String(tempString)
        }
        
        
        cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
        cell.imgProfile.sd_setImage(with: URL(string: (self.dict_get_club_booking_details["Userimage"] as! String)), placeholderImage: UIImage(named: "bar"))
        
        
        if (self.dict_get_club_booking_details["fullPaymentStatus"] as! Int) == 1 {
            
            self.btnPay.setTitle("PAYMENT DONE", for: .normal)
        } else {
            
            let temp:NSNumber = self.dict_get_club_booking_details["advancePayment"] as! NSNumber
            let tempString = temp.stringValue
            
            // total - advance
            let total_amount = "\(self.dict_get_club_booking_details["totalAmount"]!)"
            let advance_amount = "\(self.dict_get_club_booking_details["advancePayment"]!)"
            let calculate_price = Double(total_amount)! - Double(advance_amount)!
            print(calculate_price)
            
            self.btnPay.setTitle("PENDING AMOUNT: $\(calculate_price)", for: .normal)
            
        }
        
        
        //self.btnPay.addTarget(self, action: #selector(pending_amount_payment_click_method), for: .touchUpInside)
        // let remainingAmount:Double = totalAmount - advance
        
        // btnPay.setTitle("PAY REST AMOUNT- $"+String(remainingAmount), for: .normal)
        
        return cell
    }

    @objc func btnSignUpTapped(){
        
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddTableVC") as? AddTableVC
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 660
    }
    
    
}

extension NPBookingDetailVC: UITableViewDelegate {
    
}
