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
                        let alert_pay_price = "Pay Now : $"+final_pay_to_club
                        
                        //
                        let actionSheet = NewYorkAlertController(title: "Payment", message: alert_table_price+alert_booking_price+alert_deposit, style: .actionSheet)
                        
                        actionSheet.addImage(UIImage(named: "apple-pay"))
                        
                        let apple_pay = NewYorkButton(title: alert_pay_price, style: .default) { _ in
                            // print("camera clicked done")

                            self.apple_pay_in_bookit(str_club_name: club_name,
                                                     str_table_name: table_name,
                                                     str_table_price: final_pay_to_club)
                            
                         }
                        
                        let cwd = NewYorkButton(title: alert_pay_price, style: .default) { _ in
                            // print("camera clicked done")

//                            self.apple_pay_in_bookit(str_club_name: club_name,
//                                                     str_table_name: table_name,
//                                                     str_table_price: final_pay_to_club)
                            
                         }
                        
                                                
                        let cancel = NewYorkButton(title: "Dismiss", style: .cancel)
                        
                        actionSheet.addButtons([apple_pay,cwd, cancel])
                        
                        self.present(actionSheet, animated: true)
                        
                        
                        
                        
                        
                        
                        
                        
                        
                       /* if (self.club_details_get_for_schedule["currentPaymentOption"] as! String) == "WIRED" {
                            
                            let club_name = (self.dict_get_table_Details["userName"] as! String)
                            
                            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PaymentVC") as? PaymentVC
                            
                            push!.dict_get_table_Details = self.dict_get_table_Details
                            push!.get_club_name = club_name
                            push!.str_schedule_time = String("N.A.")
                            push!.str_schedule_date = String(self.str_selected_date)
                            push!.dict_get_club_details = self.club_details_get_for_schedule
                            
                            self.navigationController?.pushViewController(push!, animated: true)
                            
                        } else {
                            
                            let club_name = (self.dict_get_table_Details["userName"] as! String)
                            
                            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "payment_stripe_id") as? payment_stripe
                            
                            push!.dict_get_table_Details = self.dict_get_table_Details
                            push!.get_club_name = club_name
                            push!.str_schedule_time = String("N.A.")
                            push!.str_schedule_date = String(self.str_selected_date)
                            push!.dict_get_club_details = self.club_details_get_for_schedule
                            
                            self.navigationController?.pushViewController(push!, animated: true)
                            
                        }*/
                        
                        
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
    
    
    @objc func apple_pay_in_bookit(
        str_club_name:String,str_table_name:String,str_table_price:String) {
        
            
//            print(str_club_name)
//            print(str_table_price)

            let paymentItem = PKPaymentSummaryItem.init(label: str_club_name+"\n"+str_table_name, amount: NSDecimalNumber(value: str_table_price.toDouble()!))
        
        // for cards
            let paymentNetworks = [PKPaymentNetwork.amex, .discover, .masterCard, .visa]
        
        // check user did payment
            if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
            
            // if user make payment
            let request = PKPaymentRequest()
            request.currencyCode = "USD" // 1
            request.countryCode = "US" // 2
                // request.merchantIdentifier = "merchant.com.development.bookit" // 3
            request.merchantIdentifier = "merchant.com.development.info.bookit" // 3

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
        
        displayDefaultAlert(title: "Success!", message: "The Apple Pay transaction was complete.")
        
        // call webservice
        
    }
 
}
