//
//  NPManageTable.swift
//  Bookit
//
//  Created by Ranjan on 29/12/21.
//

import UIKit
import Alamofire
import SDWebImage

var btnEditTappedStr :String!
var clubTableId:String!
var clubTableImg:String!
var tableName:String!
var seatPrice:String!
var clubAddress:String!
var clubUserName:String!
var tableTotalSeat:String!


class NPManageTable: UIViewController {
    
    var arrTableList:NSMutableArray = []
    
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
            lblNavigationTitle.text = "CLUB TABLE DETAIL"
            lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
            lblNavigationTitle.backgroundColor = .clear
        }
    }
    
    // ***************************************************************** // nav
    
    @IBOutlet weak var btnAddTable:UIButton! {
        didSet {
            btnAddTable.tintColor = NAVIGATION_BACK_COLOR
            btnAddTable.addTarget(self, action: #selector(btnAddTableTapped), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var tablView:UITableView!{
        didSet {
            //            tablView.delegate = self
            //            tablView.dataSource = self
            tablView.backgroundColor =  APP_BASIC_COLOR
        }
    }
    
    @IBOutlet weak var lbl_no_Data_found:UILabel! {
        didSet {
            lbl_no_Data_found.text = "You didn't add any table yet. Please click on '+' icon to add Tables."
            lbl_no_Data_found.textColor = .white
            lbl_no_Data_found.isHidden = true
            lbl_no_Data_found.numberOfLines = 0
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = APP_BASIC_COLOR
        self.navigationController?.isNavigationBarHidden = true
        self.tablView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        self.tablView.separatorColor = .white
        
        // self.manage_profile()
        
        clubTableListWebservices()
    }
    
    @objc func manage_profile() {
        
        if let myLoadedString = UserDefaults.standard.string(forKey: "keySetToBackOrMenu") {
            print(myLoadedString)
            
            if myLoadedString == "backOrMenu" {
                // menu
                self.btnBack.setImage(UIImage(systemName: "list.dash"), for: .normal)
                // self.sideBarMenuClick()
            } else {
                // back
                self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
            }
        } else {
            // back
            self.btnBack.setImage(UIImage(systemName: "arrow.left"), for: .normal)
            self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        }
        
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func sideBarMenuClick() {
        
        let defaults = UserDefaults.standard
        defaults.setValue("", forKey: "keyBackOrSlide")
        defaults.setValue(nil, forKey: "keyBackOrSlide")
        
        if revealViewController() != nil {
            btnBack.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    @objc func btnAddTableTapped() {
        
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddTableVC") as? AddTableVC
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
    }
    
    @objc func clubTableListWebservices() {
        
        //let indexPath = IndexPath.init(row: 0, section: 0)
        //let cell = self.tablView.cellForRow(at: indexPath) as! AddTableTableViewCell
        
        self.view.endEditing(true)
        //
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            if (person["role"] as! String) == "Club" {
                
                ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
                
            }
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            //let clubName = person["fullName"] as! String
            
            
            self.arrTableList.removeAllObjects()
            
            let params =
            ClubTableList(action: "tablelist",
                          userId:myString,
                          clubId:"",
                          pageNo:"")
            
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
                    strSuccess = JSON["status"]as Any as? String
                    
                    if strSuccess == String("success") {
                        print("yes")
                        
                        ERProgressHud.sharedInstance.hide()
                        
                        var ar : NSArray!
                        ar = (JSON["data"] as! Array<Any>) as NSArray
                        
                        if ar.count == 0 {
                            
                            self.lbl_no_Data_found.isHidden = false
                            self.tablView.isHidden = true
                            
                        } else {
                        
                            self.arrTableList.addObjects(from: ar as! [Any])
                        
                            self.tablView.reloadData()
                            self.tablView.delegate = self
                            self.tablView.dataSource = self
                            
                        }
                        
                        
                        
                        
                        
                    }
                    else {
                        ERProgressHud.sharedInstance.hide()
                        print("no")
                        
                    }
                case let .failure(error):
                    ERProgressHud.sharedInstance.hide()
                    print(error)
                }
                
            }
            
        }
        
    }
    
    
}


//MARK:- TABLE VIEW -
extension NPManageTable: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTableList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NPManageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NPManageTableCell") as! NPManageTableViewCell
        
        cell.backgroundColor = APP_BASIC_COLOR
      
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
//        cell.imgTable.image = UIImage(named: "bar")
//
//        cell.btnSeat.setTitle("2 Seat", for: .normal)
//
       // cell.btnSignUp.addTarget(self, action: #selector(btnSignUpTapped), for: .touchUpInside)
        
        let item = arrTableList[indexPath.row] as? [String:Any]
        
        print(item as Any)
        
        cell.imgTable.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.imgTable.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "logo"))
        cell.lblTableNum.text = (item!["name"] as! String)
        cell.lblPrice.text = "$ " + String((item!["seatPrice"] as! Int))
        cell.btnSeat.setTitle((String(item!["totalSeat"] as! Int)) + " Seats", for: .normal)
        cell.lbl_description.text = (item!["description"] as! String)
        
        cell.btnEdit.addTarget(self, action: #selector(btnEditTapped), for: .touchUpInside)
        cell.btnEdit.tag = indexPath.row
        
        return cell
    }

    @objc func btnEditTapped(_ sender:UIButton) {
        
        let btn:UIButton! = sender
        print(btn.tag as Any)
        btnEditTappedStr = "EditBtnTapped"
        //let item = self.arrTableList[btn.tag]
        
        let item = arrTableList[sender.tag] as? [String:Any]
        
        //print(item)
        
        btnEditTappedStr = "EditBtnTapped"
        
        clubTableId = String((item!["clubTableId"] as! Int))
        //clubTableImg = (item!["clubTableId"] as! String)
        tableName = (item!["name"] as! String)
        seatPrice = String((item!["seatPrice"] as! Int))
        tableTotalSeat = String((item!["totalSeat"] as! Int))
        clubAddress = (item!["userAddress"] as! String)
        clubUserName = (item!["userName"] as! String)
        
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddTableVC") as? AddTableVC
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}

extension NPManageTable: UITableViewDelegate {
    
}
