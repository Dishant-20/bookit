//
//  NPClubTableDetailVC.swift
//  Bookit
//
//  Created by Ranjan on 22/12/21.
//

import UIKit
import Alamofire
import SDWebImage

class NPClubTableDetailVC: UIViewController {
    
    
    
    var club_Details:NSDictionary!
    
    var arr_mut_club_data:NSMutableArray! = []
    
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
                lblNavigationTitle.text = "Tables"
                lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
                lblNavigationTitle.backgroundColor = .clear
            }
        }
                    
    // ***************************************************************** // nav
   
    @IBOutlet weak var tablView:UITableView! {
        didSet {
            // tablView.delegate = self
            // tablView.dataSource = self
            tablView.backgroundColor =  .clear // UIColor.init(red: 230.0/255.0, green: 212.0/255.0, blue: 196.0/255.0, alpha: 1)
        }
    }

    // 230 , 212 , 196

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.init(red: 250.0/255.0, green: 248.0/255.0, blue: 246.0/255.0, alpha: 1)
        
        self.navigationController?.isNavigationBarHidden = true
        self.tablView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        // self.view.backgroundColor = .white
        
        self.club_table_listing_wb()
        
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func club_table_listing_wb() {
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        let x : Int = self.club_Details["userId"] as! Int
        let myString = String(x)
        
        
        let params = customer_table_listing(
                                            action: "tablelist",
                                            clubId: String(myString),
                                            pageNo: "")
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
                    
                    var ar : NSArray!
                    ar = (JSON["data"] as! Array<Any>) as NSArray
                    self.arr_mut_club_data.addObjects(from: ar as! [Any])
                    
                    self.tablView.delegate = self
                    self.tablView.dataSource = self
                    self.tablView.reloadData()
                    
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
        // }
    }
}


//MARK:- TABLE VIEW -
extension NPClubTableDetailVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_mut_club_data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NPClubTableDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NPClubTableDetailCell") as! NPClubTableDetailTableViewCell
        
        cell.backgroundColor = .clear // cell_bg_color
      
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        let item = self.arr_mut_club_data[indexPath.row] as? [String:Any]
        
        let x : Int = item!["seatPrice"] as! Int
        let myString = String(x)
        
        cell.lblPrice.text = "Price : $\(myString) per seat"
        
        
        
        let x_total_seat : Int = item!["totalSeat"] as! Int
        let myString_x_total_seat = String(x_total_seat)
        
        if myString_x_total_seat == "0" {
            cell.btnSeat.setTitle("\(myString_x_total_seat) seat", for: .normal)
        } else if myString_x_total_seat == "1" {
            cell.btnSeat.setTitle("\(myString_x_total_seat) seat", for: .normal)
        } else {
            cell.btnSeat.setTitle("\(myString_x_total_seat) seats", for: .normal)
        }
        
        
        
        cell.lblTableNum.text = (item!["name"] as! String)
        
        cell.imgTable.image = UIImage(named: "bar")
        
        cell.imgTable.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
        cell.imgTable.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "bar"))
        
       // cell.btnSignUp.addTarget(self, action: #selector(btnSignUpTapped), for: .touchUpInside)
        
        cell.btnBook.tag = indexPath.row
        cell.btnBook.addTarget(self, action: #selector(book_click_method), for: .touchUpInside)
        
        return cell
    }

    @objc func book_click_method(_ sender:UIButton) {
        
        let btn:UIButton! = sender
        print(btn.tag as Any)
        
        // let item = self.arr_mut_club_data[btn.tag] as? [String:Any]
        
        /*let actionSheet = NewYorkAlertController(title: "Book a Table", message: "Book a table for today or schedule it.", style: .actionSheet)

        let titles = ["BOOK FOR TODAY", "SCHEDULE A DATE"]
        
        /*let image_is = (item!["image"] as! String)
        print(image_is as Any)
        
        let fileUrl = URL(fileURLWithPath: image_is)
        
         DispatchQueue.global().async { [weak self] in
         if let data = try? Data(contentsOf: fileUrl) {
         if let image = UIImage(data: data) {
         DispatchQueue.main.async {
         // self?.image = image
         
         actionSheet.addImage(image)
         
         }
         }
         }
         }*/
        
        actionSheet.addButtons(
            titles.enumerated().map { index, title -> NewYorkButton in
                let button = NewYorkButton(title: title, style: .default) { button in
                    print("Selected \(titles[button.tag])")
                }
                button.tag = index
                button.setDynamicColor(.orange)
                return button
            }
        )

        let cancel = NewYorkButton(title: "Cancel", style: .cancel)
        actionSheet.addButton(cancel)

        present(actionSheet, animated: true)*/
        
        
        let item = self.arr_mut_club_data[btn.tag] as? [String:Any]
        
        let alert = NewYorkAlertController(title: "Book a Table", message: "Book a table for today or schedule it.", style: .alert)

        // alert.addImage(UIImage(named: "Image"))

        let book_for_today = NewYorkButton(title: "BOOK FOR TODAY", style: .default) { _ in
            print("Tapped BOOK FOR TODAY")
            
            self.direct_payment(dict_get: item! as NSDictionary)
            
        }
        
        let schedule_A_Date = NewYorkButton(title: "SCHEDULE A DATE", style: .default) { _ in
            print("Tapped SCHEDULE A DATE")
            
            self.schedule_a_data(dict_get: item! as NSDictionary)
            
        }
        
        book_for_today.setDynamicColor(.purple)
        schedule_A_Date.setDynamicColor(.purple)
        
        let cancel = NewYorkButton(title: "Cancel", style: .cancel)
        alert.addButtons([book_for_today,schedule_A_Date, cancel])

        present(alert, animated: true)
        
    }
    
    @objc func schedule_a_data(dict_get:NSDictionary) {
        
        let club_name = (self.club_Details["fullName"] as! String)
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BookingVC") as? BookingVC
        
        push!.dict_get_table_Details = dict_get
        push!.get_club_name = club_name
        
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    @objc func direct_payment(dict_get:NSDictionary) {
        
        RPicker.selectDate(title: "Select Time", cancelText: "Cancel", datePickerMode: .time, didSelectDate: { [](selectedDate) in
            // TODO: Your implementation for date
            // cell.txtTime.text = selectedDate.dateString("hh:mm a")
            
             // self.str_selected_time = selectedDate.dateString("hh:mm a")
            
            let club_name = (self.club_Details["fullName"] as! String)
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PaymentVC") as? PaymentVC
            
            push!.dict_get_table_Details = dict_get
            push!.get_club_name = club_name
            push!.str_schedule_time = selectedDate.dateString("hh:mm a")
            push!.my_payment_server_status = "yes"
            
            self.navigationController?.pushViewController(push!, animated: true)
            
            
            
            // self.push_when_time_select_successfully(get_my_dict: dict_get)
        })
        
        
        
    }
    
    @objc func push_when_time_select_successfully(get_my_dict:NSDictionary) {
        
        
        
    }
    
    @objc func btnSignUpTapped() {
        
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddTableVC") as? AddTableVC
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}

extension NPClubTableDetailVC: UITableViewDelegate {
    
}
