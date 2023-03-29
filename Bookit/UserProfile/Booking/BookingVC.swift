//
//  BookingVC.swift
//  Bookit
//
//  Created by Ranjan on 25/12/21.
//

import UIKit
import FSCalendar
import Alamofire

import PassKit

class BookingVC: UIViewController {
    
    var club_details_get_for_schedule:NSDictionary!
    
    var str_from_club_for_event:String!
    
    var str_selected_date:String! = "0"
    var str_selected_time:String! = "0"
    
    var dict_get_table_Details:NSDictionary!
    var get_club_name:String!
    
    var txt_card_number = UITextField()
    var txt_exp = UITextField()
    var txt_cvv = UITextField()
    
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
                lblNavigationTitle.text = "Schedule a date"
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
    
    var payment_for_apple_pay:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        self.btnBack.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        
        // let indexPath = IndexPath.init(row: 0, section: 0)
        // let cell = self.tablView.cellForRow(at: indexPath) as! BookingTableViewCell
        
        // cell.lblTop.text = (self.dict_get_table_Details["ClubfullName"] as! String)+" - Table '\(self.dict_get_table_Details["tableName"] as! String)' Booking"
        
        /*if cell.lblTop == "booking_Details" {
            // pay_pending_payment_wb
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
            
            cell.lblTop.text = (self.dict_get_table_Details["ClubfullName"] as! String)+" - Table '\(self.dict_get_table_Details["tableName"] as! String)' Booking"
            
            // let indexPath = IndexPath.init(row: 0, section: 0)
            // let cell = self.tbleView.cellForRow(at: indexPath) as! PaymentTableViewCell
            
            
            
        } else {
        
            cell.lblTop.text = String(self.get_club_name)+" - Table '\(self.dict_get_table_Details["name"] as! String)' Booking"
            
            // self.strCardType = "none"
        
        }*/
        
        
        
        
        UserDefaults.standard.set("", forKey: "key_save_card_details")
        UserDefaults.standard.set(nil, forKey: "key_save_card_details")
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let payment_details = UserDefaults.standard.value(forKey: "key_save_card_details") as? [String:Any] {
        
            self.btnBack.isHidden = true
            self.lblNavigationTitle.text = "please wait..."
            
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
            
            self.payment_via_cwa(payment_to_cwa: (payment_details["card_amount"] as! String),
                                 get_card_number: (payment_details["card_number"] as! String),
                                 get_card_name: (payment_details["card_name"] as! String),
                                 get_card_cvv: (payment_details["card_cvv"] as! String),
                                 get_card_year: (payment_details["card_year"] as! String),
                                 get_card_month: (payment_details["card_month"] as! String)
            )
            
        }
        
    }
    @objc func back_click_method() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - CHECK DATES AVAILAIBLE -
    @objc func check_availaibility() {
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "checking availaibility...")
        
        
        let params = check_dates_availaibility(action: "checkavailable",
                                               date: String(self.str_selected_date),
                                               tableId: "\(self.dict_get_table_Details["clubTableId"] as! Int)"
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
                    strSuccess2 = JSON["Availabe"]as Any as? String
                    
                    if strSuccess2 == "No" {
                    
                        let alert = NewYorkAlertController(title: String("Alert"), message: String("This table is already booked for today. Please choose another table."), style: .alert)
                        
                        alert.addImage(UIImage.gif(name: "gif_alert"))
                        
                        let cancel = NewYorkButton(title: "Ok", style: .cancel)
                        alert.addButtons([cancel])
                        
                        self.present(alert, animated: true)
                        
                        
                    } else {
                        
                        print(self.dict_get_table_Details as Any) // 1
                        print(self.club_details_get_for_schedule as Any) // 2
                        
                        
                        // seat price
                        let myString = "\(self.dict_get_table_Details["seatPrice"]!)"
                        let convert_seat_price_to_double = myString.toDouble()
//                        print(convert_seat_price_to_double)
                        
                        // username
                        let club_name = (self.dict_get_table_Details["userName"] as! String)
                        
                        // club name
                        let table_name = (self.dict_get_table_Details["name"] as! String)
//
                        
                        
                        
                        // calculate booking fee
                        let double_add_booking_fee_with_total = (convert_seat_price_to_double!*Double(0.039))+Double(0.30)
                        print(double_add_booking_fee_with_total as Any)
                        
                        let s_final_amount = (String(format:"%.02f", double_add_booking_fee_with_total))
                        // let myInt3_final_amount = (s_final_amount as NSString).integerValue
//                        print(s_final_amount as Any)
                        
                        
                        // table price
                        let final_table_price = (String(format:"%.02f", convert_seat_price_to_double!))
                        
                        print("Table Price ========> "+final_table_price)
                        print("Your Booking Fees ========> "+s_final_amount)
                        
                        
                        
                        // advance percentage
                        let club_deposit_advance = "\(self.dict_get_table_Details["advancePercentage"]!)"
                        print(club_deposit_advance as Any)
                        
                        // deduct deposit from total price
                        let deduct_deposit_from_total = (Double(club_deposit_advance)!/100)*Double(final_table_price)!
                        print(deduct_deposit_from_total as Any)
                        
                        let deposit_with_total = (String(format:"%.02f", deduct_deposit_from_total))
                        print(deposit_with_total as Any)
                        
                        // addbooking fee with deposit total
                        let final_pay_to_club_double = Double(deposit_with_total)!+Double(s_final_amount)!
                        print(final_pay_to_club_double as Any)
                        
                        let final_pay_to_club = (String(format:"%.02f", final_pay_to_club_double))
                        print(final_pay_to_club as Any)
                        
                        let alert_table_price = "Table Price : $"+String(final_table_price)
                        let alert_booking_price = "\n\nBooking fees : $"+String(s_final_amount)
                        let alert_deposit = "\n\nDeposit : "+String(club_deposit_advance)+"%"
                        let alert_pay_price = "$"+final_pay_to_club
                        
                        //
                        let actionSheet = NewYorkAlertController(title: "Payment", message: alert_table_price+alert_booking_price+alert_deposit, style: .actionSheet)
                        
                        actionSheet.addImage(UIImage(named: "payment_1"))
                        
                        let apple_pay = NewYorkButton(title: "Apple pay : "+alert_pay_price, style: .default) { _ in
                            // print("camera clicked done")

                            self.apple_pay_in_bookit(str_club_name: club_name,
                                                     str_table_name: table_name,
                                                     str_table_price: final_pay_to_club)
                            
                         }
                        
                        let cwd = NewYorkButton(title: "CWA : "+alert_pay_price, style: .default) { _ in
                            
                            self.open_card_popup(final_payment_for_card_payment: final_pay_to_club)
                            
                         }
                        
                                                
                        let cancel = NewYorkButton(title: "Dismiss", style: .cancel)
                        
                        actionSheet.addButtons([apple_pay,cwd, cancel])
                        
                        self.present(actionSheet, animated: true)
                     
                    }
                    
                    
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
    
    @objc func open_card_popup(final_payment_for_card_payment:String) {
        
                    
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "card_payment_screen_id") as? card_payment_screen
        
        settingsVCId!.str_price = String(final_payment_for_card_payment)
        
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
    }
    
    @objc func apple_pay_in_bookit(
        str_club_name:String,str_table_name:String,str_table_price:String) {
        
            self.payment_for_apple_pay = String(str_table_price)
            
            let paymentItem = PKPaymentSummaryItem.init(label: str_club_name+"\n"+str_table_name, amount: NSDecimalNumber(value: str_table_price.toDouble()!))
        
        // for cards
            let paymentNetworks = [PKPaymentNetwork.amex, .discover, .masterCard, .visa]
        
        // check user did payment
            if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
            
            // if user make payment
            let request = PKPaymentRequest()
            request.currencyCode = "USD" // 1
            request.countryCode = "US" // 2
                
            request.merchantIdentifier = merchant_id // 3

            request.merchantCapabilities = PKMerchantCapability.capability3DS // 4
            request.supportedNetworks = paymentNetworks // 5
            request.paymentSummaryItems = [paymentItem] // 6
            
            
            guard let paymentVC = PKPaymentAuthorizationViewController(paymentRequest: request) else {
                displayDefaultAlert(title: "Error", message: "Unable to present Apple Pay authorization.")
                return
            }
            paymentVC.delegate = self
            self.present(paymentVC, animated: true, completion: nil)
            
        } else {
            displayDefaultAlert(title: "Error", message: "Unable to make Apple Pay transaction.")
        }
        
    }
    
    func displayDefaultAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @objc func book_a_table_wb(advanced_payment:Double) {
      
        // print(self.dict_save_club_info_for_apple_pay as Any)
        // print(self.club_Details as Any)
        
        /*
         Optional({
             advancePercentage = 20;
             clubTableId = 81;
             created = "Jan 3rd, 2023, 9:58 pm";
             description = "Five premium no cover up to 10 people ";
             image = "https://bookitweb.com/img/uploads/table/1672801106add_table.png";
             name = PLATINUM;
             "profile_picture" = "https://bookitweb.com/img/uploads/users/1672801183add_club_logo.png";
             seatPrice = 1500;
             totalSeat = 5;
             userAddress = "51-07 27th Street";
             userId = 1336;
             userName = "Sugar Daddy's Gentlemen\U2019s Club";
         })
         Optional({
             AVGRating = "";
             Fri = 0;
             Mon = 0;
             Sat = 0;
             StripeStatus = "";
             Sun = 0;
             Thu = 0;
             Tue = 0;
             Userimage = "https://bookitweb.com/img/uploads/users/1672801183add_club_logo.png";
             Wed = 0;
             about = "Gentlemen\U2019s Club";
             address = "51-07 27th Street";
             banner = "https://bookitweb.com/img/uploads/users/1672801191edit_club_banner.png";
             city = 11101;
             closeTime = "04:00 AM";
             contactNumber = "718-706-9600";
             currentPaymentOption = WIRED;
             device = "";
             deviceToken = "";
             email = "";
             fullName = "Sugar Daddy's Gentlemen\U2019s Club";
             latitude = "";
             longitude = "";
             openTime = "08:00 PM";
             stripeAccountNo = "";
             totalLiked = 0;
             userId = 1336;
             youliked = No;
             zipCode = 11101;
         */
          
        
        
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
                                               advancePayment : "\(advanced_payment)",
                                               fullPaymentStatus: String("2") // half payment
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

                        let x : Int = JSON["bookingId"] as! Int
                        let myString_bid = String(x)

                        //
                        // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
                        self.update_payment_after_stripe(str_booking_id: String(myString_bid),
                                                         str_payment_Status: "2",
                                                         str_status_is: "yes",
                                                         str_transaction_id: "dummy_transaction_id",
                                                         str_total_price: "\(advanced_payment)")
                        
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
    
    
    
    @objc func update_payment_after_stripe(str_booking_id:String,
                                           str_payment_Status:String,
                                           str_status_is:String,
                                           str_transaction_id:String,
                                           str_total_price:String) {
        
        
        
//        self.view.endEditing(true)
        
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // print(person as Any)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
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
                            
                            self.confirm_payment(str_total_price_show: str_total_price)
                            
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
    
    @objc func confirm_payment(str_total_price_show:String) {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BookingSuccessVC") as? BookingSuccessVC
         push!.str_booked_price = str_total_price_show
        self.navigationController?.pushViewController(push!, animated: true)
    }
    
    // CWA
    @objc func payment_via_cwa(payment_to_cwa:String,
                               get_card_number:String,
                               get_card_name:String,
                               get_card_cvv:String,
                               get_card_year:String,
                               get_card_month:String
    ) {
        // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
        let myDouble = Double(payment_to_cwa)
        
        let url = URL(string: "https://cwamerchantservices.transactiongateway.com/api/transact.php")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        
        let parameters: [String: Any] = [
            "zip"       : (person["zipCode"] as! String),
            "country"   : (person["countryId"] as! String),
            "amount"    : myDouble!,
            "firstname" : String(get_card_name),
            "cvv"       : String(get_card_cvv),
            "city"      : (person["city"] as! String),
            "address1"  : (person["address"] as! String),
            "type"      : "sale",
            "lastname"  : String(get_card_name),
            "security_key"  : cwa_payment_api_key,
            "phone"     : (person["contactNumber"] as! String),
            "state"     : (person["stateId"] as! String),
            "ccexp"     : String(get_card_month)+String(get_card_year),
            "ccnumber"  : String(get_card_number),
        ]
        
        request.httpBody = parameters.percentEncoded()
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                error == nil
            else {                                                               // check for fundamental networking error
                print("error", error ?? URLError(.badServerResponse))
                return
            }
            
            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
            
            // do whatever you want with the `data`, e.g.:
            
            do {
                let responseObject = try JSONDecoder().decode(ResponseObject<Foo>.self, from: data)
                print(responseObject)
            } catch {
                print(error) // parsing error
                
                if let responseString = String(data: data, encoding: .utf8) {
                    print("responseString = \(responseString)")
                    print(type(of: "\(responseString)"))
                    
                    let ch = Character("&")
                    let result = "\(responseString)".split(separator: ch)
                    
                    for _ in 0..<result.count {
                        
                        print(result)
                        print(result[0])
                        
                        let ch_2 = Character("=")
                        var result_2 = result[0].split(separator: ch_2)
                        print(result_2)
                        
                        if "\(result_2[1])" == "1" {
                            print("all details are perfect")
                            
                            DispatchQueue.main.async {
                                // send data to evs server
                                
                                ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
                                self.book_a_table_wb(advanced_payment: myDouble!)
                            }
                            
                            
                            return
                        } else {
                            print("something went wrong")
                            
                            let ch_3 = Character("=")
                            let result_3 = result[1].split(separator: ch_3)
                            print(result_3)
                            
                            DispatchQueue.main.async {
                                
                                ERProgressHud.sharedInstance.hide()
                                
                                let alert = UIAlertController(title: String("Alert").uppercased(), message: "\(result_3[1])", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                self.present(alert, animated: true)
                                
                                    }
                            
                            
                            
                            return
                            
                        }
                        
                    }
                    
                    
                    //
                } else {
                    print("unable to parse response as string")
                }
            }
        }
        
        task.resume()
        
        // delete this after uncomment
        /*let myDouble = Double(payment_to_cwa)
         self.book_a_table_wb(advanced_payment: myDouble!)*/
    }
    }
}


//MARK:- TABLE VIEW -
extension BookingVC: UITableViewDataSource, FSCalendarDelegate,FSCalendarDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:BookingTableViewCell = tableView.dequeueReusableCell(withIdentifier: "BookingTableCell") as! BookingTableViewCell
        
        cell.backgroundColor = .white
      
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.calendar.delegate = self
        cell.calendar.dataSource = self
        
        // cell.btnSelectTime.addTarget(self, action: #selector(btnSelectTimeTapped), for: .touchUpInside)
        // cell.lblTop.text = "Dance Club - Table No.1 Booking"
        
        // print(self.dict_get_table_Details as Any)
        
        /*
         clubTableId = 2;
         created = "Dec 21st, 2021, 3:51 pm";
         image = "https://demo4.evirtualservices.net/bookit/img/uploads/table/16400820692.jpg";
         name = Xyz;
         "profile_picture" = "https://demo4.evirtualservices.net/bookit/img/uploads/users/16400815972.jpg";
         seatPrice = 75;
         totalSeat = 5;
         userAddress = gggggggg;
         userId = 2;
         userName = "Raushan Kumar";
         */
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            print(person as Any)
            
            if (person["role"] as! String) == "Club" {
                
                self.str_from_club_for_event = "yes"
                
            } else {
                
                self.str_from_club_for_event = "no"
                
            }
            
        }
        
        if self.str_from_club_for_event == "yes" {
            
            cell.lblTop.text = "Select date to create event."
            
            cell.btnConfirm.addTarget(self, action: #selector(show_payment_screen), for: .touchUpInside)
            
        } else {
        
            cell.lblTop.text = (self.dict_get_table_Details["userName"] as! String)+" - Table '\(self.dict_get_table_Details["name"] as! String)' Booking"
            
            cell.btnConfirm.addTarget(self, action: #selector(show_payment_screen), for: .touchUpInside)
            
        }
        
        
        return cell
    }

    @objc func btnSignUpTapped() {
        
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddTableVC") as? AddTableVC
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
        
    }
    
    @objc func btnSelectTimeTapped() {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! BookingTableViewCell
        
        // Simple Time Picker
        RPicker.selectDate(title: "Select Time", cancelText: "Cancel", datePickerMode: .time, didSelectDate: { [](selectedDate) in
            // TODO: Your implementation for date
            cell.txtTime.text = selectedDate.dateString("hh:mm a")
            
            self.str_selected_time = String(cell.txtTime.text!)
        })
        
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! BookingTableViewCell
        
        let foramtter = DateFormatter()
        
        // foramtter.dateFormat = "EEE MM-dd-YYYY"
        
        foramtter.dateFormat = "yyyy-MM-dd"
        
        let date = foramtter.string(from: date)
        
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date_set = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let resultString = dateFormatter.string(from: date_set!)
        cell.lblSelectedDate.text = "Selected Date: " + resultString
        
        
        self.str_selected_date = "\(date)"
        
        // print(self.str_selected_date as Any)
        
        print(String(self.str_selected_date))
        
        
        
    }

    @objc func show_payment_screen() {
        
        if self.str_from_club_for_event == "yes" {
            
            // create event click
            
            if self.str_selected_date == "0" {
                
                let alert = NewYorkAlertController(title: String("Alert"), message: String("Please select date"), style: .alert)
                
                alert.addImage(UIImage.gif(name: "gif_alert"))
                
                let cancel = NewYorkButton(title: "Ok", style: .cancel)
                alert.addButtons([cancel])
                
                self.present(alert, animated: true)
                
            } else {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "create_event_id") as? create_event
                
                push!.str_selected_date_for_event = String(self.str_selected_date)
                
                self.navigationController?.pushViewController(push!, animated: true)
                
            }
            
            
            
            
        } else {
            
            let indexPath = IndexPath.init(row: 0, section: 0)
            let cell = self.tablView.cellForRow(at: indexPath) as! BookingTableViewCell
            
            if self.str_selected_date == "0" {
                
                let alert = NewYorkAlertController(title: "Alert", message: String("Please Select Date"), style: .alert)
                
                alert.addImage(UIImage.gif(name: "gif_alert"))
                
                let cancel = NewYorkButton(title: "Ok", style: .cancel) { _ in
                    
                    // SPConfetti.stopAnimating()
                    
                    // self.navigationController?.popViewController(animated: true)
                }
                alert.addButtons([cancel])
                
                self.present(alert, animated: true)
                
            } /*else if cell.txtTime.text == "" {
               
               let alert = NewYorkAlertController(title: "Alert", message: String("Please Select Time"), style: .alert)
               
               alert.addImage(UIImage.gif(name: "gif_alert"))
               
               let cancel = NewYorkButton(title: "Ok", style: .cancel) { _ in
               
               // SPConfetti.stopAnimating()
               
               // self.navigationController?.popViewController(animated: true)
               }
               alert.addButtons([cancel])
               
               self.present(alert, animated: true)
               
               }*/ else {
                   
                   print(self.club_details_get_for_schedule as Any)
                   
                   let get_day_from_date = self.getDayNameBy(stringDate: self.str_selected_date)
                   print(get_day_from_date as Any)
                   
                   if "\(self.club_details_get_for_schedule[get_day_from_date]!)" == "1" {
                       
                       let alert = NewYorkAlertController(title: "Alert", message: String("This club is closed today. Please select another date to book this table."), style: .alert)
                       
                       let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                       alert.addButtons([cancel])
                       
                       self.present(alert, animated: true)
                       
                       
                   } else {
                       
                       self.check_availaibility()
                       
                   }
                   
                   
                   
                   
               }
        }
        
        
        
    }

    func getDayNameBy(stringDate: String) -> String {
        
        let df  = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let date = df.date(from: stringDate)!
        df.dateFormat = "EE"
        return df.string(from: date)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 800
    }
    
}

extension BookingVC: UITableViewDelegate {
    
}

extension BookingVC: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        
        //
        
        dismiss(animated: true, completion: nil)
        //
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        
        dismiss(animated: true, completion: nil)
        
        print("The Apple Pay transaction was complete.")
        
        print(payment.token.paymentData)
        print(payment.token.paymentMethod)
        print(payment.token.transactionIdentifier)
        
        if let url = Bundle.main.appStoreReceiptURL,
           let data = try? Data(contentsOf: url) {
              let receiptBase64 = data.base64EncodedString()
              // Send to server
            print(receiptBase64)
        }
        
        // displayDefaultAlert(title: "Success!", message: "The Apple Pay transaction was complete.")
        
        // call webservice
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        self.book_a_table_wb(advanced_payment: Double(self.payment_for_apple_pay)!)
        
    }
 
}
