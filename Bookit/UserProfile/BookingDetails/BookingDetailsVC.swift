//
//  BookingDetailsVC.swift
//  Bookit
//
//  Created by Ranjan on 27/12/21.
//

import UIKit
import SDWebImage
import Alamofire

class BookingDetailsVC: UIViewController {
    
    var dict_get_booking_details:NSDictionary!
    
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
                lblNavigationTitle.text = "Details"
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

    @IBOutlet weak var btn_cancel_booking:UIButton! {
        didSet {
            btn_cancel_booking.tintColor = .white
            btn_cancel_booking.isHidden = true
        }
    }
    
    @IBOutlet weak var btnPay:UIButton! {
        didSet {
            
            btnPay.backgroundColor = BUTTON_DARK_APP_COLOR
            btnPay.tintColor = .white
            
            // btnPay.titleLabel?.font = UIFont.systemFont(ofSize: 22.0, weight: .bold)
            
        }
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        self.tablView.separatorColor = .clear
        
        self.btnBack.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        // print(self.dict_get_booking_details as Any)
        self.btn_cancel_booking.addTarget(self, action: #selector(cancel_booking_click_method), for: .touchUpInside)
        
        /*
         Clubbanner = "";
         ClubcontactNumber = 7428171872;
         Clubemail = "raushan@mailinator.com";
         ClubfullName = "Raushan Kumar";
         Clubimage = "https://demo4.evirtualservices.net/bookit/img/uploads/users/16400815972.jpg";
         ClublastName = "";
         Tableimage = "https://demo4.evirtualservices.net/bookit/img/uploads/table/16400820692.jpg";
         TableseatPrice = 75;
         TabletotalSeat = 5;
         Userimage = "";
         advancePayment = 75;
         bokingDate = "";
         bookingId = 7;
         clubId = 2;
         clubTableId = 2;
         contactNumber = 1232142314;
         created = "2022-01-18 18:15:00";
         email = "ios@gmail.com";
         fullName = ios;
         fullPaymentStatus = 2;
         lastName = "";
         seatPrice = 75;
         tableName = Xyz;
         totalAmount = 75;
         totalSeat = 5;
         userId = 6;
         */
        
        
        
        
        
        
        
        
        print(self.dict_get_booking_details as Any)
        
        
        
        
        
        let x : Int = self.dict_get_booking_details["fullPaymentStatus"] as! Int
        let myString = String(x)
        
        if myString == "2" {
            // advance
            
            // let x : Int = self.dict_get_booking_details["totalAmount"] as! Int
            // let myString = String(x)
            
            // let x_2 : Int = self.dict_get_booking_details["advancePayment"] as! Int
            // let myString_2 = String(x_2)
            
            // total amount
            let total_amount_get:String!
            
            if self.dict_get_booking_details["totalAmount"] is String {
                print("Yes, it's a String")

                total_amount_get = (self.dict_get_booking_details["totalAmount"] as! String)
                
            } else if self.dict_get_booking_details["totalAmount"] is Int {
                print("It is Integer")
                            
                let x2 : Int = (self.dict_get_booking_details["totalAmount"] as! Int)
                let myString2 = String(x2)
                
                total_amount_get = String(myString2)
                
            } else {
                print("i am number")
                            
                let temp:NSNumber = self.dict_get_booking_details["totalAmount"] as! NSNumber
                let tempString = temp.stringValue
                
                total_amount_get = String(tempString)
            }
            
            
            // advance payment
            let advance_payment_get:String!
            
            if "\(self.dict_get_booking_details["advancePayment"]!)" == "" {
                
                advance_payment_get = "0"
                
            } else {
                
                if self.dict_get_booking_details["advancePayment"] is String {
                    print("Yes, it's a String")

                    advance_payment_get = (self.dict_get_booking_details["advancePayment"] as! String)
                    
                } else if self.dict_get_booking_details["advancePayment"] is Int {
                    print("It is Integer")
                                
                    let x2 : Int = (self.dict_get_booking_details["advancePayment"] as! Int)
                    let myString2 = String(x2)
                    
                    advance_payment_get = String(myString2)
                    
                } else {
                    print("i am number")
                                
                    let temp:NSNumber = self.dict_get_booking_details["advancePayment"] as! NSNumber
                    let tempString = temp.stringValue
                    
                    advance_payment_get = String(tempString)
                }
                
            }
            
            
            
            
            
            
            let get_pending_amount = Double(total_amount_get)!-Double("\(advance_payment_get!)")!
            print(get_pending_amount as Any)
            
            self.btnPay.setTitle("Pending Amount : $\(get_pending_amount)", for: .normal)
            self.btnPay.isUserInteractionEnabled = true
            
            
            
        } else {
            // full payment
            
            
            
            self.btnPay.setTitle("Payment Done", for: .normal)
            self.btnPay.backgroundColor = .systemGreen
            self.btnPay.isUserInteractionEnabled = false
        }
        
        
        if "\(self.dict_get_booking_details["cancelRequest"]!)" == "1" {
            
            self.btn_cancel_booking.isHidden = true
            self.btnPay.setTitle("Cancel Request Initiated", for: .normal)
            self.btnPay.isUserInteractionEnabled = false
            self.btnPay.backgroundColor = .systemOrange
            
        } else if "\(self.dict_get_booking_details["cancelRequest"]!)" == "2" {
            
            
            self.btn_cancel_booking.isHidden = true
            self.btnPay.setTitle("Cancelled", for: .normal)
            self.btnPay.isUserInteractionEnabled = false
            self.btnPay.backgroundColor = .systemRed
            self.btnPay.isHidden = true
            
            
        } else {
            
            let dateString = (self.dict_get_booking_details["bookingDate"] as! String)

            // Setup a date formatter to match the format of your string
            let dateFormatter = DateFormatter()
            // dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd"

            // Create a date object from the string
            if let date = dateFormatter.date(from: dateString) {
                print(date as Any)
                if date < Date() {
                    
                    print("Before now")
                    self.btn_cancel_booking.isHidden = true
                    
                } else if date == Date() {
                    
                    self.btn_cancel_booking.isHidden = true
                    
                } else {
                    
                    self.btn_cancel_booking.isHidden = true
                    print("After now")
                    
                }
            }
            
        }
        
    }
    
    @objc func cancel_booking_click_method() {
        
        let alert = NewYorkAlertController(title: "Cancel booking", message: String("Are you sure you want to cancel your booking ?"), style: .alert)
        
        let yes_logout = NewYorkButton(title: "yes, cancel", style: .destructive) {
            _ in
            self.cancel_booking()
        }

        let cancel = NewYorkButton(title: "dismiss", style: .cancel)
        alert.addButtons([cancel,yes_logout])
        
        self.present(alert, animated: true)
        
    }
    
    @objc func back_click_method() {
        self.navigationController?.popViewController(animated: true)
    }
  
    
    
    // MARK: - EVENT LISTING -
    @objc func cancel_booking() {
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            print(person as Any)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            self.view.endEditing(true)
            
            
            let params = Bookit.cancel_booking(action: "cancelorder",
                                        userId: myString,
                                        bookingId: "\(self.dict_get_booking_details["bookingId"]!)")
            
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
                        
                        let alert = NewYorkAlertController(title: "Success", message: strSuccess2, style: .alert)
                        
                        let cancel = NewYorkButton(title: "dismiss", style: .cancel){
                            _ in
                            self.back_click_method()
                        }
                        alert.addButtons([cancel])
                        
                        self.present(alert, animated: true)
                        
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
    }
    

}

//MARK:- TABLE VIEW -
extension BookingDetailsVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:BookingDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "BookingDetailsTableCell") as! BookingDetailsTableViewCell
        
        cell.backgroundColor = .white
      
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        // cell.imgBG.image = UIImage(named: "bar")
        
       // cell.btnSignUp.addTarget(self, action: #selector(btnSignUpTapped), for: .touchUpInside)
        
        
        cell.lblName.text = (self.dict_get_booking_details["ClubfullName"] as! String)
        cell.btnPhone.setTitle((self.dict_get_booking_details["ClubcontactNumber"] as! String), for: .normal)
        cell.btnLocation.setTitle("N.A.", for: .normal)
        
        let x_3 : Int = self.dict_get_booking_details["totalAmount"] as! Int
        let myString_3 = String(x_3)
        
        let x_4 : Int = self.dict_get_booking_details["TabletotalSeat"] as! Int
        let myString_4 = String(x_4)
        
        cell.lblTableNum.text   = (self.dict_get_booking_details["tableName"] as! String)
        
        let add_booking_fee_to_total = Double("\(self.dict_get_booking_details["processingFee"]!)") 
        let total_amount_after_percent_calulate: String = String(format: "%.2f", add_booking_fee_to_total!)
        print(total_amount_after_percent_calulate as Any)
        cell.lbl_booking_fee.text = "$\(total_amount_after_percent_calulate)"
        
        if (self.dict_get_booking_details["bookingDate"] as! String) == "" {
            cell.lblDate.text       = "N.A."
        } else {
            cell.lblDate.text       = (self.dict_get_booking_details["bookingDate"] as! String)
        }
        
        cell.lblTotalSeat.text  = myString_4
        cell.lblTotalAmount.text = "$"+myString_3
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            if person["role"] as! String == "Customer" {
                
                cell.btnLike.isHidden = true
                cell.btnShare.isHidden = true
                
            } else {
                
                cell.btnLike.isHidden = true
                cell.btnShare.isHidden = true
                
            }
            
            
            
            
        }
        
        
        
        
        if self.dict_get_booking_details["advancePayment"] is String {
            print("Yes, it's a String")

            cell.lblAdvancedPay.text = "$"+(self.dict_get_booking_details["advancePayment"] as! String)
            
        } else if self.dict_get_booking_details["advancePayment"] is Int {
            print("It is Integer")
                        
            let x2 : Int = (self.dict_get_booking_details["advancePayment"] as! Int)
            let myString2 = String(x2)
            // self.lblPayableAmount.text = "Membership Amount : $ "+myString2
                        
             
            cell.lblAdvancedPay.text = "$"+String(myString2)
            
        } else {
            print("i am number")
                        
            let temp:NSNumber = self.dict_get_booking_details["advancePayment"] as! NSNumber
            let tempString = temp.stringValue
            
            cell.lblAdvancedPay.text = "$"+String(tempString)
        }
        
        
        cell.imgBG.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
        cell.imgBG.sd_setImage(with: URL(string: (self.dict_get_booking_details["Clubimage"] as! String)), placeholderImage: UIImage(named: "bar"))
        
        self.btnPay.addTarget(self, action: #selector(pending_amount_payment_click_method), for: .touchUpInside)
        // let remainingAmount:Double = totalAmount - advance
        
        // btnPay.setTitle("PAY REST AMOUNT- $"+String(remainingAmount), for: .normal)
        
        if "\(self.dict_get_booking_details["cancelRequest"]!)" == "2" {
            
            cell.img_decline.isHidden = false
            cell.img_decline.image = UIImage(named: "cancelled_booking")
            
        } else {
            cell.img_decline.isHidden = true
        }
        
        return cell
    }

    @objc func pending_amount_payment_click_method() {
        
        print("open action sheet")
        
        let actionSheet = NewYorkAlertController(title: "Pending Payment", message: "test", style: .actionSheet)
        
        actionSheet.addImage(UIImage(named: "payment_1"))
        
        let apple_pay = NewYorkButton(title: "Apple Pay", style: .default) { _ in
            // print("camera clicked done")

            /*self.apple_pay_in_bookit(str_club_name: club_name,
                                     str_table_name: table_name,
                                     str_table_price: final_pay_to_club)*/
            
         }
        
        let cwd_payment = NewYorkButton(title: "CWA", style: .default) { _ in
            // print("camera clicked done")

             
            // self.payment_via_cwa(payment_to_cwa: final_pay_to_club)
            
         }
                                
        let cancel = NewYorkButton(title: "Dismiss", style: .cancel)
        
        actionSheet.addButtons([apple_pay,cwd_payment, cancel])
        
        self.present(actionSheet, animated: true)
        
        /*if (self.dict_get_booking_details["paymentMode"] as! String) == "WIRED" {
            
            let club_name = (self.dict_get_booking_details["fullName"] as! String)
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PaymentVC") as? PaymentVC
            push!.dict_get_table_Details = self.dict_get_booking_details
            push!.get_club_name = club_name
            
            push!.am_from_which_profile = "booking_Details"
            
            self.navigationController?.pushViewController(push!, animated: true)
            
        } else {
            
            let club_name = (self.dict_get_booking_details["fullName"] as! String)
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "payment_stripe_id") as? payment_stripe
            push!.dict_get_table_Details = self.dict_get_booking_details
            push!.get_club_name = club_name
            
            push!.am_from_which_profile = "booking_Details"
            push!.dict_get_club_details = self.dict_get_booking_details
            self.navigationController?.pushViewController(push!, animated: true)
            
        }*/
        
        
    }
    
    @objc func btnSignUpTapped() {
        
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddTableVC") as? AddTableVC
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 686
    }
    
    
}

extension BookingDetailsVC: UITableViewDelegate {
    
}

extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
