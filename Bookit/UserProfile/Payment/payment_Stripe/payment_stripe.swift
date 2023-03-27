//
//  payment_stripe.swift
//  Bookit
//
//  Created by Apple on 03/06/22.
//

import UIKit
import Alamofire
import Stripe

class payment_stripe: UIViewController , UITextFieldDelegate {
    
    var am_from_which_profile:String!
    
    var get_club_name:String!
    
    var str_advance:String! = "50"
    
    var total_price:String! = "0"
    
    var is_full_payment_status:String! = "2"
    
    var dict_get_table_Details:NSDictionary!
    var dict_get_club_details:NSDictionary!
    
    var pending_payment_is:String!
    
    var str_schedule_date:String!
    var str_schedule_time:String!
    
    var my_payment_server_status:String!
    
    var get_Stripe_token_id:String! = "12345-qwerty"
    
    var str_booking_fees:String! = "0"
    
    var total_price_starting_for_driver_calculation:String! = "0"
    
    var str_my_advance_payment_is:String!
    
    // ***************************************************************** // nav
                    
        @IBOutlet weak var navigationBar:UIView! {
            didSet {
                navigationBar.backgroundColor = NAVIGATION_COLOR
            }
        }
            
        @IBOutlet weak var btnBack:UIButton! {
            didSet {
                btnBack.tintColor = NAVIGATION_BACK_COLOR
            }
        }
            
        @IBOutlet weak var lblNavigationTitle:UILabel! {
            didSet {
                lblNavigationTitle.text = "Payment"
                lblNavigationTitle.textColor = .white
                lblNavigationTitle.backgroundColor = .clear
            }
        }
                    
    // ***************************************************************** // nav
    
    var cardNumberCursorPreviousPosition = 0
    
    var strCardType:String!
    
    @IBOutlet weak var tbleView:UITableView! {
        didSet {
            tbleView.delegate = self
            tbleView.dataSource = self
        }
    }
    
    @IBOutlet weak var viewTop:UIView! {
        didSet {
            viewTop.backgroundColor = BUTTON_DARK_APP_COLOR
            
        }
    }
    
    @IBOutlet weak var lblClubTableInfo:UILabel!
    
    @IBOutlet weak var btnmakePayment:UIButton! {
        didSet {
            btnmakePayment.backgroundColor = NAVIGATION_COLOR
            btnmakePayment.setTitle("MAKE PAYMENT", for: .normal)
            btnmakePayment.setTitleColor(.white, for: .normal)
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        // print(100*0.8)
        
        print(self.dict_get_table_Details as Any)
        print(self.dict_get_club_details as Any)
        
        self.calculate_booking_fee()
        
        /*
         clubTableId = 31;
         created = "Feb 25th, 2022, 12:18 pm";
         image = "";
         name = "Jaisalmer ";
         "profile_picture" = "";
         seatPrice = 400;
         totalSeat = 10;
         userAddress = bshdh;
         userId = 57;
         userName = "new nc";
         */
        
        
        self.view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        self.btnBack.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        
        self.btnmakePayment.addTarget(self, action: #selector(checkValidation), for: .touchUpInside)
        
        if self.am_from_which_profile == "booking_Details" {
            
            // print(self.dict_get_table_Details as Any)
            
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
             advancePayment = "187.5";
             bokingDate = "";
             bookingId = 15;
             clubId = 2;
             clubTableId = 2;
             contactNumber = 1232142314;
             created = "2022-01-19 12:53:00";
             email = "ios@gmail.com";
             fullName = ios;
             fullPaymentStatus = 2;
             lastName = "";
             seatPrice = 75;
             tableName = Xyz;
             totalAmount = 375;
             totalSeat = 5;
             userId = 6;
             
             */
            
            self.lblClubTableInfo.text = (self.dict_get_table_Details["ClubfullName"] as! String)+" - Table '\(self.dict_get_table_Details["tableName"] as! String)' Booking"
            
            // let indexPath = IndexPath.init(row: 0, section: 0)
            // let cell = self.tbleView.cellForRow(at: indexPath) as! payment_stripe_table_cell
            
            
            
        } else {
        
            // print(self.dict_get_table_Details as Any)
            
                self.lblClubTableInfo.text = String(self.get_club_name)+" - Table '\(self.dict_get_table_Details["name"] as! String)' Booking"
                
                self.strCardType = "none"
                
            
            
            
        
        }
        
        
    }
    
    @objc func calculate_booking_fee() {
    
        print(self.dict_get_table_Details as Any)
        print(self.dict_get_club_details as Any)
        
        
    }
    
    @objc func back_click_method() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc override func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func checkValidation(){
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! payment_stripe_table_cell
        if cell.txtCardNumber.text == "" {
            let alert = UIAlertController(title: "Card Number", message: "card number should not be blank", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
                
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        /*else if cell.txtNameOnCard.text == "" {
         let alert = UIAlertController(title: "Name", message: "Name should not be blank", preferredStyle: UIAlertController.Style.alert)
         alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
         
         }))
         
         self.present(alert, animated: true, completion: nil)
         }*/
        
        else if cell.txtExpDate.text == "" {
            let alert = UIAlertController(title: "Exp Month", message: "Expiry Month should not be blank", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
                
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        else if cell.txtCVV.text == "" {
            let alert = UIAlertController(title: "Security Code", message: "Security Code should not be blank", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
                
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        else {
            
            // let indexPath = IndexPath.init(row: 0, section: 0)
            // let cell = self.tbleView.cellForRow(at: indexPath) as! payment_stripe_table_cell
            //lblEXPDate.isHidden = false
            //lblEXPDate.text = cell.txtExpDate.text
            //lblCardHolderName.isHidden=false
            //lblCardHolderName.text = cell.txtNameOnCard.text
            //lblCardNumberHeading.isHidden = false
            //lblCardNumberHeading.text = cell.txtCardNumber.text
            // imgCardImage.image = UIImage(named: String(strCardType))
            
            self.hit_stripe_for_token()
            
        }
    }

    @objc func hit_stripe_for_token() {
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! payment_stripe_table_cell
        
        let fullNameArr = cell.txtExpDate.text!.components(separatedBy: "/")
        
        // print(fullNameArr as Any)
        let name    = fullNameArr[0]
        let surname = fullNameArr[1]
        
        // print(name as Any)
        // print(surname as Any)
        
        let cardParams = STPCardParams()
        
        cardParams.number       = String(cell.txtCardNumber.text!)
        cardParams.expMonth     = UInt(name)!
        cardParams.expYear      = UInt(surname)!
        cardParams.cvc          = String(cell.txtCVV.text!)
        
        print(cardParams as Any)
        
        STPAPIClient.shared().createToken(withCard: cardParams) { token, error in
            guard let token = token else {
                // Handle the error
                // print(error as Any)
                print(error?.localizedDescription as Any)
                
                ERProgressHud.sharedInstance.hide()
                
                let alert = UIAlertController(title: "Error", message: String(error!.localizedDescription), preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "dismiss", style: UIAlertAction.Style.default, handler: { action in
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            
            let tokenID = token.tokenId
            print(tokenID)
            
            self.get_Stripe_token_id = String(tokenID)
            
            if self.am_from_which_profile == "booking_Details" {
                
                self.charger_amount_hit_for_pending_payment()
                
            } else {
                                
                print(self.str_schedule_time as Any)

                
                if self.my_payment_server_status == "yes" {
                    
                    self.book_a_table_wb()
                    
                } else {
                    
                    self.book_a_table_with_time_date_wb()
                    
                }
                
                
            }
            
        }
        
        // self.fullAndFinalBW(strTokenIdIs: "", strCardNumber: String(cell.txtCardNumber.text!))
        
    }
    
    @objc func book_a_table_wb() {
        
        self.view.endEditing(true)
        // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // print(person as Any)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            
            
            let x_2 : Int = (self.dict_get_table_Details["userId"] as! Int)
            let myString_2 = String(x_2)
            
            let x_3 : Int = (self.dict_get_table_Details["clubTableId"] as! Int)
            let myString_3 = String(x_3)
            
            let x_4 : Int = (self.dict_get_table_Details["totalSeat"] as! Int)
            let myString_4 = String(x_4)
            
            let x_5 : Int = (self.dict_get_table_Details["seatPrice"] as! Int)
            let myString_5 = String(x_5)
            
            // let total_amount_minus_admin = Double(myString_5)! - Double(0)
            
            // print(self.total_price as Any)
            
            var str_advance_payment_is:String!
            
            if self.is_full_payment_status == "2" {
                
                str_advance_payment_is = String(self.str_my_advance_payment_is)
            } else {
                
                str_advance_payment_is = "0"
            }
            
            print(myString_4 as Any)
            print(myString_5 as Any)
            
            // let total_amount_calculate = Double(myString_4)!*Double(myString_5)!
            
            
            
            
            let params = customer_book_a_table(action   : "addbooking",
                                               userId       : myString,
                                               clubId       : myString_2,
                                               clubTableId  : myString_3,
                                               bookingDate  : Date.getCurrentDate(),
                                               arrvingTime  : String("N.A."),
                                               totalSeat    : myString_4,
                                               seatPrice    : myString_5,
                                               adminFee     : "0",
                                               totalAmount  : String(myString_5),
                                               advancePayment : String(str_advance_payment_is),
                                               fullPaymentStatus: String(self.is_full_payment_status))
            
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
                        
                        // ERProgressHud.sharedInstance.hide()
                         
                        let x : Int = JSON["bookingId"] as! Int
                        let myString_bid = String(x)
                        
                        self.update_payment_from_stripe_to_EVS(str_booking_id_2: String(myString_bid),
                                                               str_payment_Status_2: self.is_full_payment_status,
                                                               str_status_is_2: "yes",
                                                               str_total_amount: String(myString_5))
                        
                        
                        
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

    @objc func book_a_table_with_time_date_wb() {
        
        self.view.endEditing(true)
        // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // print(person as Any)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            
            
            let x_2 : Int = (self.dict_get_table_Details["userId"] as! Int)
            let myString_2 = String(x_2)
            
            let x_3 : Int = (self.dict_get_table_Details["clubTableId"] as! Int)
            let myString_3 = String(x_3)
            
            let x_4 : Int = (self.dict_get_table_Details["totalSeat"] as! Int)
            let myString_4 = String(x_4)
            
            let x_5 : Int = (self.dict_get_table_Details["seatPrice"] as! Int)
            let myString_5 = String(x_5)
            
            // let total_amount_minus_admin = Double(myString_5)! - Double(0)
            
            // print(self.total_price as Any)
            
            var str_advance_payment_is:String!
            
            if self.is_full_payment_status == "2" {
                
                str_advance_payment_is = String(self.str_my_advance_payment_is)
                
            } else {
                
                str_advance_payment_is = "0"
            }
            
            let params = customer_book_a_table(action       : "addbooking",
                                               userId       : myString,
                                               clubId       : myString_2,
                                               clubTableId  : myString_3,
                                               bookingDate  : String(self.str_schedule_date),
                                               arrvingTime  : String("N.A."),
                                               totalSeat    : myString_4,
                                               seatPrice    : myString_5,
                                               adminFee     : "0",
                                               totalAmount  : String(myString_5),
                                               advancePayment : String(str_advance_payment_is),
                                               fullPaymentStatus : String(self.is_full_payment_status))
            
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
                        
                        // ERProgressHud.sharedInstance.hide()
                        
                        // self.confirm_payment()
                        
                        let x : Int = JSON["bookingId"] as! Int
                        let myString_bid = String(x)
                        
                        self.update_payment_from_stripe_to_EVS(str_booking_id_2: String(myString_bid), str_payment_Status_2: self.is_full_payment_status, str_status_is_2: "yes", str_total_amount: String(myString_5))
                        
                        
                        
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
    
    @objc func charger_amount_hit_for_pending_payment() {
        
        self.view.endEditing(true)
        // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // print(person as Any)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            /*let strTotalAmount = Double(str_total_amount)!*100
            print(strTotalAmount as Any)*/
            
            // print(str_total_amount as Any)
            
            print(self.total_price as Any)
            
            // calculate : Total  + 3.9 % + 0.30
            /*let double_add_booking_fee_with_total = (Double(str_total_amount)!*Double(0.039))+Double(0.30)
            print(double_add_booking_fee_with_total as Any)
            
            let strTotalAmount = double_add_booking_fee_with_total*100
            print(strTotalAmount as Any)
            
            let s_final_amount = (String(format:"%.02f", strTotalAmount))
            let myInt3_final_amount = (s_final_amount as NSString).integerValue
            print(myInt3_final_amount as Any)*/
            
            let str_split_total_amount = Double(self.total_price)!*100
            let split_final_amount = (String(format:"%.02f", str_split_total_amount))
            let myInt3_split_final_amount = (split_final_amount as NSString).integerValue
            
            // driver amount
            
            if self.total_price_starting_for_driver_calculation == "0" {
            
                ERProgressHud.sharedInstance.hide()
                print("=======> SOMETHING WENT WRONG. PLEASE ADD DRIVER AMOUNT <=========")
                return
            }
            
            let driver_amount = Double(self.total_price_starting_for_driver_calculation)!*0.8
            print(driver_amount as Any)
            let multiple_with_hundred = driver_amount*100
            print(multiple_with_hundred as Any)
            let driver_final_amount = (String(format:"%.02f", multiple_with_hundred))
            let myInt3_final_driver_amount = (driver_final_amount as NSString).integerValue
            print(myInt3_final_driver_amount)
            
            let params = Bookit.split_payment_via_stripe(action: "chargeramount",
                                                         userId: String(myString),
                                                         amount: "\(myInt3_split_final_amount)",
                                                         tokenID: String(self.get_Stripe_token_id),
                                                         DriverAmount: String(myInt3_final_driver_amount),
                                                         AccountNo: (self.dict_get_club_details["stripeAccountNo"] as! String))
            
            print(params as Any)
            
            AF.request(split_payment_URL,
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
                        
                        // ERProgressHud.sharedInstance.hide()
                        
                        var get_transaction_id : String!
                        get_transaction_id = JSON["transactionID"]as Any as? String
                        
                        self.pay_pending_payment_wb(str_transaction_id: String(get_transaction_id))
                        
                        /*self.update_payment_after_stripe(str_booking_id: str_booking_id_2,
                                                         str_payment_Status: str_payment_Status_2,
                                                         str_status_is:str_status_is_2,
                                                         str_transaction_id: String(get_transaction_id))*/
                        
                        
                        
                    } else {
                        
                        print("no")
                        ERProgressHud.sharedInstance.hide()
                        
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
        
        /*if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // print(person as Any)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let strTotalAmount = Double(total_price)!*100
            print(strTotalAmount as Any)
            
            let s_final_amount = (String(format:"%.02f", strTotalAmount))
            
            let myInt3_final_amount = (s_final_amount as NSString).integerValue
            print(myInt3_final_amount as Any)
            
            // calculate : Total  + 3.9 % + 0.30
            
            
            let params = Bookit.stripe_charger_amount(action: "chargeramount",
                                               userId: String(myString),
                                               amount: String(myInt3_final_amount),
                                               tokenID: String(self.get_Stripe_token_id))
            
            print(params as Any)
            
            AF.request(stripe_payment_update,
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
                        
                        // ERProgressHud.sharedInstance.hide()
                        
                        var get_transaction_id : String!
                        get_transaction_id = JSON["transactionID"]as Any as? String
                        
                        self.pay_pending_payment_wb(str_transaction_id: String(get_transaction_id))
                        
                        /*self.update_payment_after_stripe(str_booking_id: str_booking_id_2,
                                                          str_payment_Status: str_payment_Status_2,
                                                         str_status_is:str_status_is_2, str_transaction_id: String(get_transaction_id))*/
                        
                        
                        
                    } else {
                        print("no")
                          ERProgressHud.sharedInstance.hide()
                        
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
        }*/
        
    }
    
    //MARK: - PAY PENDING PAYMENT -
    @objc func pay_pending_payment_wb(str_transaction_id:String) {
        
        self.view.endEditing(true)
        // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // print(person as Any)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let x_2 : Int = self.dict_get_table_Details["bookingId"] as! Int
            let myString_2 = String(x_2)
            
            
            
            let params = pay_pending_payment(action: "remainpaymentupdate",
                                             userId: String(myString),
                                             bookingId: String(myString_2),
                                             fullPaymentStatus: "1",
                                             remainPayment:String(self.total_price),
                                             remainTransactionID:String(str_transaction_id))
            
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
                        
                        let alert = NewYorkAlertController(title: "Success", message: String(strSuccess2), style: .alert)
                        
                        alert.addImage(UIImage.gif(name: "success3"))
                        
                        let cancel = NewYorkButton(title: "Ok", style: .cancel) { _ in
                            
                            let tab_bar = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "tab_bar_controller_id") as? tab_bar_controller
                            tab_bar?.selectedIndex = 1
                            self.navigationController?.pushViewController(tab_bar!, animated: false)
                            
                        }
                        alert.addButtons([cancel])
                        
                        self.present(alert, animated: true)
                        
                        /*var get_transaction_id : String!
                        get_transaction_id = JSON["transactionID"]as Any as? String
                        
                        self.update_payment_after_stripe(str_booking_id: String(myString_2),
                                                         str_payment_Status: "1",
                                                         str_status_is:"no",
                                                         str_transaction_id: String(get_transaction_id))*/
                        
                        
                    } else {
                        print("no")
                          ERProgressHud.sharedInstance.hide()
                        
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
    
    @objc func update_payment_from_stripe_to_EVS(str_booking_id_2:String,
                                                 str_payment_Status_2:String,
                                                 str_status_is_2:String,
                                                 str_total_amount:String) {
        
        
        
        self.view.endEditing(true)
        // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // print(person as Any)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            /*let strTotalAmount = Double(str_total_amount)!*100
            print(strTotalAmount as Any)*/
            
            print(str_total_amount as Any)
            
            print(self.total_price as Any)
            
            // calculate : Total  + 3.9 % + 0.30
            /*let double_add_booking_fee_with_total = (Double(str_total_amount)!*Double(0.039))+Double(0.30)
            print(double_add_booking_fee_with_total as Any)
            
            let strTotalAmount = double_add_booking_fee_with_total*100
            print(strTotalAmount as Any)
            
            let s_final_amount = (String(format:"%.02f", strTotalAmount))
            let myInt3_final_amount = (s_final_amount as NSString).integerValue
            print(myInt3_final_amount as Any)*/
            
            let str_split_total_amount = Double(self.total_price)!*100
            let split_final_amount = (String(format:"%.02f", str_split_total_amount))
            let myInt3_split_final_amount = (split_final_amount as NSString).integerValue
            
            // driver amount
            let driver_amount = Double(self.total_price_starting_for_driver_calculation)!*0.8
            print(driver_amount as Any)
            let multiple_with_hundred = driver_amount*100
            print(multiple_with_hundred as Any)
            let driver_final_amount = (String(format:"%.02f", multiple_with_hundred))
            let myInt3_final_driver_amount = (driver_final_amount as NSString).integerValue
            print(myInt3_final_driver_amount)
            
            let params = Bookit.split_payment_via_stripe(action: "chargeramount",
                                                         userId: String(myString),
                                                         amount: "\(myInt3_split_final_amount)",
                                                         tokenID: String(self.get_Stripe_token_id),
                                                         DriverAmount: String(myInt3_final_driver_amount),
                                                         AccountNo: (self.dict_get_club_details["stripeAccountNo"] as! String))
            
            print(params as Any)
            
            AF.request(split_payment_URL,
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
                        
                        // ERProgressHud.sharedInstance.hide()
                        
                        var get_transaction_id : String!
                        get_transaction_id = JSON["transactionID"]as Any as? String
                        
                        self.update_payment_after_stripe(str_booking_id: str_booking_id_2,
                                                         str_payment_Status: str_payment_Status_2,
                                                         str_status_is:str_status_is_2,
                                                         str_transaction_id: String(get_transaction_id))
                        
                        
                        
                    } else {
                        
                        print("no")
                        ERProgressHud.sharedInstance.hide()
                        
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
        
        /*if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // print(person as Any)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            /*let strTotalAmount = Double(str_total_amount)!*100
            print(strTotalAmount as Any)*/
            
            // calculate : Total  + 3.9 % + 0.30
            let double_add_booking_fee_with_total = Double(str_total_amount)!+Double(0.039)+Double(0.30)
            print(double_add_booking_fee_with_total as Any)
            
            let strTotalAmount = double_add_booking_fee_with_total*100
            print(strTotalAmount as Any)
            
            let s_final_amount = (String(format:"%.02f", strTotalAmount))
            let myInt3_final_amount = (s_final_amount as NSString).integerValue
            print(myInt3_final_amount as Any)
            
            
            let params = Bookit.stripe_charger_amount(action: "chargeramount",
                                               userId: String(myString),
                                               amount: "\(myInt3_final_amount)",
                                               tokenID: String(self.get_Stripe_token_id))
            
            print(params as Any)
            
            AF.request(stripe_payment_update,
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
                        
                        // ERProgressHud.sharedInstance.hide()
                        
                        var get_transaction_id : String!
                        get_transaction_id = JSON["transactionID"]as Any as? String
                        
                        self.update_payment_after_stripe(str_booking_id: str_booking_id_2,
                                                         str_payment_Status: str_payment_Status_2,
                                                         str_status_is:str_status_is_2, str_transaction_id: String(get_transaction_id))
                        
                        
                        
                    } else {
                        
                        print("no")
                        ERProgressHud.sharedInstance.hide()
                        
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
        }*/
        
    }
    
    @objc func update_payment_after_stripe(str_booking_id:String,
                                           str_payment_Status:String,
                                           str_status_is:String,
                                           str_transaction_id:String) {
        
        
        
        self.view.endEditing(true)
        // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // print(person as Any)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            // let x_2 : Int = self.dict_get_table_Details["bookingId"] as! Int
            // let myString_2 = String(x_2)
            
            let params = Bookit.update_payment_after_stripe_webservice(action: "updatepayment",
                                                     userId: String(myString),
                                                     bookingId: String(str_booking_id),
                                                     fullPaymentStatus: String(str_payment_Status),
                                                     transactionId: String(str_transaction_id))
            
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
                        
                        if str_status_is == "yes" {
                            
                            self.confirm_payment()
                            
                        } else {
                            
                            var strSuccess2 : String!
                            strSuccess2 = JSON["msg"]as Any as? String
                            
                            let alert = NewYorkAlertController(title: "Success", message: String(strSuccess2), style: .alert)
                            
                            alert.addImage(UIImage.gif(name: "success3"))
                            
                            let cancel = NewYorkButton(title: "Ok", style: .cancel) { _ in
                                
                                let tab_bar = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "tab_bar_controller_id") as? tab_bar_controller
                                tab_bar?.selectedIndex = 0
                                self.navigationController?.pushViewController(tab_bar!, animated: false)
                                
                            }
                            alert.addButtons([cancel])
                            
                            self.present(alert, animated: true)
                            
                        }
                        
                        
                        
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


extension payment_stripe:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:payment_stripe_table_cell = tableView.dequeueReusableCell(withIdentifier: "payment_stripe_table_cell") as! payment_stripe_table_cell
        
        cell.backgroundColor = .white
      
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.txtCardNumber.delegate = self
        cell.txtExpDate.delegate = self
        cell.txtCVV.delegate = self
        //cell.txtNameOnCard.delegate = self
        
        
        
        if self.am_from_which_profile == "booking_Details" {
            
            cell.btnAdvance.backgroundColor = .lightGray
            cell.btnAdvance.layer.cornerRadius = 8.0
            cell.btnAdvance.clipsToBounds = true
            cell.btnAdvance.tintColor = .white
            cell.btnAdvance.isUserInteractionEnabled = false
            
            cell.btnTotal.backgroundColor = NAVIGATION_COLOR
            cell.btnTotal.layer.cornerRadius = 8.0
            cell.btnTotal.clipsToBounds = true
            cell.btnTotal.tintColor = .black
            cell.btnTotal.isUserInteractionEnabled = false
            
            // total amount
            let total_amount_get:String!
            
            if self.dict_get_table_Details["totalAmount"] is String {
                print("Yes, it's a String")

                total_amount_get = (self.dict_get_table_Details["totalAmount"] as! String)
                
            } else if self.dict_get_table_Details["totalAmount"] is Int {
                print("It is Integer")
                            
                let x2 : Int = (self.dict_get_table_Details["totalAmount"] as! Int)
                let myString2 = String(x2)
                
                total_amount_get = String(myString2)
                
            } else {
                print("i am number")
                            
                let temp:NSNumber = self.dict_get_table_Details["totalAmount"] as! NSNumber
                let tempString = temp.stringValue
                
                total_amount_get = String(tempString)
            }
            
            
            // advance payment
            let advance_payment_get:String!
            
            if "\(self.dict_get_table_Details["advancePayment"]!)" == "" {
                advance_payment_get = "0"
            } else {
                if self.dict_get_table_Details["advancePayment"] is String {
                    print("Yes, it's a String")

                    advance_payment_get = (self.dict_get_table_Details["advancePayment"] as! String)
                    
                } else if self.dict_get_table_Details["advancePayment"] is Int {
                    print("It is Integer")
                                
                    let x2 : Int = (self.dict_get_table_Details["advancePayment"] as! Int)
                    let myString2 = String(x2)
                    
                    advance_payment_get = String(myString2)
                    
                } else {
                    print("i am number")
                                
                    let temp:NSNumber = self.dict_get_table_Details["advancePayment"] as! NSNumber
                    let tempString = temp.stringValue
                    
                    advance_payment_get = String(tempString)
                }
            }
            
            
            
            let get_pending_amount = Double(total_amount_get)!-Double(advance_payment_get)!
            
            
            
            /*
             /*
              clubTableId = 31;
              created = "Feb 25th, 2022, 12:18 pm";
              image = "";
              name = "Jaisalmer ";
              "profile_picture" = "";
              seatPrice = 400;
              totalSeat = 10;
              userAddress = bshdh;
              userId = 57;
              userName = "new nc";
              */
             */
            
            // seat price
            let table_price:String!
            
            if self.dict_get_table_Details["seatPrice"] is String {
                print("Yes, it's a String")

                table_price = (self.dict_get_table_Details["seatPrice"] as! String)
                
            } else if self.dict_get_table_Details["seatPrice"] is Int {
                print("It is Integer")
                            
                let x2 : Int = (self.dict_get_table_Details["seatPrice"] as! Int)
                let myString2 = String(x2)
                
                table_price = String(myString2)
                
            } else {
                print("i am number")
                            
                let temp:NSNumber = self.dict_get_table_Details["seatPrice"] as! NSNumber
                let tempString = temp.stringValue
                
                table_price = String(tempString)
            }
            
            cell.lbl_total_amount.text = "Table price : $"+String(table_price)
            
            
            
            // total number of seats
            // cell.lbl_total_number_of_Seats.text = "Table Capacity :"+"\(self.dict_get_table_Details["totalSeat"]!) seats"
            
            // cell.lbl_total_number_of_Seats.text = "Table Capacity : \(self.dict_get_table_Details["totalSeat"] as! Int) seats"
            
            
            cell.btnTotal.setTitle("Pay : $\(get_pending_amount)", for: .normal)
            cell.btnTotal.setTitleColor(.white, for: .normal)
            
            
            cell.btnAdvance.setTitle("Already Pay : $"+String(advance_payment_get), for: .normal)
            cell.btnTotal.setTitle("Left : $"+String(get_pending_amount), for: .normal)
            
            self.btnmakePayment.setTitle("Make Payment $\(get_pending_amount) ", for: .normal)
            self.total_price = String(get_pending_amount)
            
            self.total_price_starting_for_driver_calculation = String(get_pending_amount)
            
        } else {
        
             
            // seat price
            let table_price:String!
            
            if self.dict_get_table_Details["seatPrice"] is String {
                print("Yes, it's a String")

                table_price = (self.dict_get_table_Details["seatPrice"] as! String)
                
            } else if self.dict_get_table_Details["seatPrice"] is Int {
                print("It is Integer")
                            
                let x2 : Int = (self.dict_get_table_Details["seatPrice"] as! Int)
                let myString2 = String(x2)
                
                table_price = String(myString2)
                
            } else {
                print("i am number")
                            
                let temp:NSNumber = self.dict_get_table_Details["seatPrice"] as! NSNumber
                let tempString = temp.stringValue
                
                table_price = String(tempString)
            }
            
            // table total price
            cell.lbl_total_amount.text = "Table price : $"+String(table_price)
            
            
            
            
            
            
            // calculate booking fee
            let double_add_booking_fee_with_total = (Double(table_price)!*Double(0.039))+Double(0.30)
            print(double_add_booking_fee_with_total as Any)
            
            let s_final_amount = (String(format:"%.02f", double_add_booking_fee_with_total))
            // let myInt3_final_amount = (s_final_amount as NSString).integerValue
            print(s_final_amount as Any)
            
            cell.lbl_booking_fee.text = "Booking fee : $"+String(s_final_amount)
            
            self.str_booking_fees = String(s_final_amount)
            
            
            
            
            
            
            
            
            
            
            
            
            // total number of seats
            // cell.lbl_total_number_of_Seats.text = "Table Capacity :"+"\(self.dict_get_table_Details["totalSeat"]!) seats"
            
            // show full price
            cell.btnTotal.setTitle("Pay Full : $"+String(table_price), for: .normal)
            
            
            
            
            
            
            cell.btnAdvance.setTitle("Deposit \(self.dict_get_table_Details["advancePercentage"]!) %", for: .normal)
            
            
            
            // %
            let calulate_advance_percentage = (Double("\(self.dict_get_table_Details["advancePercentage"]!)")!/100)*Double(table_price)!
            print(calulate_advance_percentage as Any)
            
            self.str_my_advance_payment_is = "\(calulate_advance_percentage)"
            
            self.total_price_starting_for_driver_calculation = "\(calulate_advance_percentage)"
            
            print(self.total_price_starting_for_driver_calculation as Any)
            
            
            
            
            
            let add_booking_fee_to_total = Double(self.str_booking_fees)!+Double(calulate_advance_percentage)
            
            
            let total_amount_after_percent_calulate: String = String(format: "%.2f", add_booking_fee_to_total)
            print(total_amount_after_percent_calulate as Any)
            
            
            
            self.btnmakePayment.setTitle("Make deposit of : $\(total_amount_after_percent_calulate) ", for: .normal)
            self.total_price = String(total_amount_after_percent_calulate)
            print(self.total_price as Any)
            
            
            cell.btnTotal.addTarget(self, action: #selector(total_payment_click), for: .touchUpInside)
            
            cell.btnAdvance.addTarget(self, action: #selector(advance_amount_pay), for: .touchUpInside)
            // self.btnmakePayment.addTarget(self, action: #selector(confirm_payment), for: .touchUpInside)
            
        }
        
        cell.txtCardNumber.addTarget(self, action: #selector(PaymentVC.textFieldDidChange(_:)), for: .editingChanged)
        cell.txtExpDate.addTarget(self, action: #selector(PaymentVC.textFieldDidChange2(_:)), for: .editingChanged)
        
        return cell
    }
    
    @objc func advance_amount_pay() {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! payment_stripe_table_cell
        
        /*let x : Int = self.dict_get_table_Details["seatPrice"] as! Int
        let myString = String(x)
        
        let x_2 : Int = self.dict_get_table_Details["totalSeat"] as! Int
        let myString_2 = String(x_2)
        
        let total_amount_calculate = Double(myString)!*Double(myString_2)!*/
        // print(total_amount_calculate as Any)
        
        // seat price
        let table_price:String!
        
        if self.dict_get_table_Details["seatPrice"] is String {
            print("Yes, it's a String")

            table_price = (self.dict_get_table_Details["seatPrice"] as! String)
            
        } else if self.dict_get_table_Details["seatPrice"] is Int {
            print("It is Integer")
                        
            let x2 : Int = (self.dict_get_table_Details["seatPrice"] as! Int)
            let myString2 = String(x2)
            
            table_price = String(myString2)
            
        } else {
            print("i am number")
                        
            let temp:NSNumber = self.dict_get_table_Details["seatPrice"] as! NSNumber
            let tempString = temp.stringValue
            
            table_price = String(tempString)
        }
        
        
        
        let calulate_advance_percentage = (Double("\(self.dict_get_table_Details["advancePercentage"]!)")!/100)*Double(table_price)!
        print(calulate_advance_percentage as Any)
        
        self.str_my_advance_payment_is = "\(calulate_advance_percentage)"
        
        self.total_price_starting_for_driver_calculation = String(calulate_advance_percentage)
        print(total_price_starting_for_driver_calculation as Any)
        
        let add_booking_fee_to_total = Double(self.str_booking_fees)!+Double(calulate_advance_percentage)
        
        let total_amount_after_percent_calulate: String = String(format: "%.2f", add_booking_fee_to_total)
        print(total_amount_after_percent_calulate as Any)
        
        
        // let divide_total_by_50 = Double(table_price)!/2
        // print(divide_total_by_50 as Any)
        
        // show full amount on button
         cell.btnTotal.setTitle("Pay Full : $"+String(table_price), for: .normal)
        
        
        
        self.btnmakePayment.setTitle("Make deposit of : $\(total_amount_after_percent_calulate) ", for: .normal)
        self.total_price = String(total_amount_after_percent_calulate)
        print(self.total_price as Any)
        
        cell.btnAdvance.backgroundColor = NAVIGATION_COLOR
        cell.btnAdvance.layer.cornerRadius = 8.0
        cell.btnAdvance.clipsToBounds = true
        cell.btnAdvance.tintColor = .white
        
        cell.btnTotal.backgroundColor = .lightGray
        cell.btnTotal.layer.cornerRadius = 8.0
        cell.btnTotal.clipsToBounds = true
        cell.btnTotal.tintColor = .black
        
        
        self.is_full_payment_status = "2"
    }
    
    @objc func total_payment_click() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! payment_stripe_table_cell
        
        cell.btnTotal.backgroundColor = NAVIGATION_COLOR
        cell.btnTotal.layer.cornerRadius = 8.0
        cell.btnTotal.clipsToBounds = true
        cell.btnTotal.tintColor = .white
        
        cell.btnAdvance.backgroundColor = .lightGray
        cell.btnAdvance.layer.cornerRadius = 8.0
        cell.btnAdvance.clipsToBounds = true
        cell.btnAdvance.tintColor = .black
        
        /*let x : Int = self.dict_get_table_Details["seatPrice"] as! Int
        let myString = String(x)
        
        let x_2 : Int = self.dict_get_table_Details["totalSeat"] as! Int
        let myString_2 = String(x_2)
        
        let total_amount_calculate = Double(myString)!*Double(myString_2)!
        // print(total_amount_calculate as Any)*/
        
        // seat price
        let table_price:String!
        
        if self.dict_get_table_Details["seatPrice"] is String {
            print("Yes, it's a String")

            table_price = (self.dict_get_table_Details["seatPrice"] as! String)
            
        } else if self.dict_get_table_Details["seatPrice"] is Int {
            print("It is Integer")
                        
            let x2 : Int = (self.dict_get_table_Details["seatPrice"] as! Int)
            let myString2 = String(x2)
            
            table_price = String(myString2)
            
        } else {
            print("i am number")
                        
            let temp:NSNumber = self.dict_get_table_Details["seatPrice"] as! NSNumber
            let tempString = temp.stringValue
            
            table_price = String(tempString)
        }
        
        self.total_price_starting_for_driver_calculation = String(table_price)
        print(total_price_starting_for_driver_calculation as Any)
        let add_booking_fee_to_total = Double(self.str_booking_fees)!+Double(table_price)!
        
        let total_amount_after_percent_calulate: String = String(format: "%.2f", add_booking_fee_to_total)
        
        self.btnmakePayment.setTitle("Make full payment of : $"+String(total_amount_after_percent_calulate), for: .normal)
        self.total_price = String(total_amount_after_percent_calulate)
        
        
        self.is_full_payment_status = "1"
    }
    
    @objc func full_amount_pay() {
        
    }
    
    @objc func confirm_payment() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BookingSuccessVC") as? BookingSuccessVC
         push!.str_booked_price = self.total_price
        self.navigationController?.pushViewController(push!, animated: true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! payment_stripe_table_cell
        cell.lblCardNumber.isHidden = false
        cell.lblCardNumber.text! = cell.txtCardNumber.text!
        
    }
    
    @objc func textFieldDidChange2(_ textField: UITextField) {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! payment_stripe_table_cell
        
        cell.lblCardExpDate.isHidden = false
        cell.lblCardExpDate.text! = cell.txtExpDate.text!
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! payment_stripe_table_cell
        
        if textField == cell.txtCardNumber {
            
            let first2 = String(cell.txtCardNumber.text!.prefix(2))
            
            if first2.count == 2 {
               // print("yes")
                
                let first3 = String(cell.txtCardNumber.text!.prefix(2))
               // print(first3 as Any)
                
                if first3 == "34" { // amex
                    cell.imgCardType.image = UIImage(named: "Amex")
                    self.strCardType = "amex"
                } else if first3 == "37" { // amex
                    cell.imgCardType.image = UIImage(named: "Amex")
                    self.strCardType = "amex"
                } else if first3 == "51" { // master
                    cell.imgCardType.image = UIImage(named: "Mastercard")
                    self.strCardType = "master"
                } else if first3 == "55" { // master
                    cell.imgCardType.image = UIImage(named: "Mastercard")
                    self.strCardType = "master"
                }  else if first3 == "42" { // visa
                    cell.imgCardType.image = UIImage(named: "visa")
                    self.strCardType = "visa"
                } else if first3 == "65" { // discover
                    cell.imgCardType.image = UIImage(named: "Discover")
                    self.strCardType = "discover"
                } else {
                    cell.imgCardType.image = UIImage(named: "ccCard")
                    self.strCardType = "none"
                }
                
            } else {
                // print("no")
                cell.imgCardType.image = UIImage(named: "ccCard")
            }
            
            
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            
            if self.strCardType == "amex" {
                return count <= 15
            } else {
                return count <= 16
            }
            
            
        }
        
        if textField == cell.txtExpDate {
            if string == "" {
                return true
            }

            
            let currentText = textField.text! as NSString
            let updatedText = currentText.replacingCharacters(in: range, with: string)

            textField.text = updatedText
            let numberOfCharacters = updatedText.count
            
            if numberOfCharacters == 2 {
                textField.text?.append("/")
            }
            
            cell.lblCardExpDate.text! = cell.txtExpDate.text!
        }
        
       if textField == cell.txtCVV {
           
           guard let textFieldText = textField.text,
               let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                   return false
           }
           let substringToReplace = textFieldText[rangeOfTextToReplace]
           let count = textFieldText.count - substringToReplace.count + string.count
           return count <= 3
       }
        
        return false
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 800
    }
    
    
}


class payment_stripe_table_cell: UITableViewCell {
    
    @IBOutlet weak var lbl_table_capacity:UILabel! {
        didSet {
            lbl_table_capacity.textColor = .black
        }
    }
    
    @IBOutlet weak var view_bg_payment:UIView! {
        didSet {
            view_bg_payment.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_bg_payment.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            view_bg_payment.layer.shadowOpacity = 1.0
            view_bg_payment.layer.shadowRadius = 15.0
            view_bg_payment.layer.masksToBounds = false
            view_bg_payment.layer.cornerRadius = 15
            view_bg_payment.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var btnAdvance:UIButton!{
        didSet {
            
            btnAdvance.backgroundColor = NAVIGATION_COLOR
            btnAdvance.layer.cornerRadius = 8.0
            btnAdvance.clipsToBounds = true
            btnAdvance.tintColor = .white
        }
    }
    
    @IBOutlet weak var btnTotal:UIButton!{
        didSet{
            
            btnTotal.backgroundColor = .lightGray
            btnTotal.layer.cornerRadius = 8.0
            btnTotal.clipsToBounds = true
            btnTotal.tintColor = .black
        }
    }
    
    @IBOutlet weak var viwCardDetails:UIView!{
        didSet{
            viwCardDetails.layer.cornerRadius = 8.0
            viwCardDetails.clipsToBounds = true
            viwCardDetails.backgroundColor = BUTTON_DARK_APP_COLOR
        }
    }
    
    @IBOutlet weak var lblCardNumber:UILabel! {
        didSet {
            lblCardNumber.textColor = .white
            lblCardNumber.isHidden = true
        }
    }
    
    @IBOutlet weak var lbl_total_number_of_Seats:UILabel! {
        didSet {
            lbl_total_number_of_Seats.textColor = .black
            lbl_total_number_of_Seats.isHidden = false
        }
    }
    
    @IBOutlet weak var lbl_total_amount:UILabel! {
        didSet {
            lbl_total_amount.textColor = .black
            lbl_total_amount.isHidden = false
            lbl_total_amount.text = "Total amount to pay :"
        }
    }
    
    @IBOutlet weak var lblCardExpDate:UILabel!{
        didSet{
            lblCardExpDate.textColor = .white
            lblCardExpDate.isHidden = true
        }
    }
    
    @IBOutlet weak var imgCardType:UIImageView!{
        didSet{
            imgCardType.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var txtNameOnCard:UITextField! {
        didSet {
           
            txtNameOnCard.borderStyle = UITextField.BorderStyle.none
            txtNameOnCard.textAlignment = .center
            txtNameOnCard.keyboardType = .default
            
        }
    }
    @IBOutlet weak var txtCardNumber:UITextField! {
        didSet {
            
            txtCardNumber.borderStyle = UITextField.BorderStyle.none
            txtCardNumber.textAlignment = .center
            txtCardNumber.keyboardType = .numberPad
            txtCardNumber.backgroundColor = .white
        }
    }
    @IBOutlet weak var txtExpDate:UITextField! {
        didSet {
            
            txtExpDate.borderStyle = UITextField.BorderStyle.none
            txtExpDate.textAlignment = .center
            txtExpDate.keyboardType = .numberPad
            txtExpDate.backgroundColor = .white
        }
    }
    @IBOutlet weak var txtCVV:UITextField! {
        didSet {
        
            txtCVV.borderStyle = UITextField.BorderStyle.none
            txtCVV.textAlignment = .center
            txtCVV.keyboardType = .numberPad
            txtCVV.isSecureTextEntry = true
            txtCVV.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var btnCvvHelp:UIButton!{
        didSet{
            
        }
    }

    @IBOutlet weak var lbl_booking_fee:UILabel! {
        didSet {
            lbl_booking_fee.textColor = .black
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
