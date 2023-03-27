//
//  BookingVC.swift
//  Bookit
//
//  Created by Ranjan on 25/12/21.
//

import UIKit
import FSCalendar



class BookingVC: UIViewController {
    
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
    
}


//MARK:- TABLE VIEW -
extension BookingVC: UITableViewDataSource, FSCalendarDelegate,FSCalendarDataSource{
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
        
       cell.btnSelectTime.addTarget(self, action: #selector(btnSelectTimeTapped), for: .touchUpInside)
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
        
         cell.lblTop.text = (self.dict_get_table_Details["userName"] as! String)+" - Table '\(self.dict_get_table_Details["name"] as! String)' Booking"
        
        cell.btnConfirm.addTarget(self, action: #selector(show_payment_screen), for: .touchUpInside)
        
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
        
        foramtter.dateFormat = "yy-MM-dd"
        
        let date = foramtter.string(from: date)
        cell.lblSelectedDate.text = "Selected Date: " + date
        // print("\(date)")
        
        self.str_selected_date = "\(date)"
        
        // print(self.str_selected_date as Any)
        
        print(String(self.str_selected_date))
    }

    @objc func show_payment_screen() {
        
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
            
        } else if cell.txtTime.text == "" {
            
            let alert = NewYorkAlertController(title: "Alert", message: String("Please Select Time"), style: .alert)
            
            alert.addImage(UIImage.gif(name: "gif_alert"))
            
            let cancel = NewYorkButton(title: "Ok", style: .cancel) { _ in
                
                // SPConfetti.stopAnimating()
                
                // self.navigationController?.popViewController(animated: true)
            }
            alert.addButtons([cancel])
            
            self.present(alert, animated: true)
            
        } else {
            
            let club_name = (self.dict_get_table_Details["userName"] as! String)
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PaymentVC") as? PaymentVC
            
            push!.dict_get_table_Details = self.dict_get_table_Details
            push!.get_club_name = club_name
            push!.str_schedule_time = String(self.str_selected_time)
            push!.str_schedule_date = String(self.str_selected_date)
            
            
            self.navigationController?.pushViewController(push!, animated: true)
            
        }
        
        
        
        
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
