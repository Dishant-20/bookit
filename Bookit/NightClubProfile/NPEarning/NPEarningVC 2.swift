//
//  NPEarningVC.swift
//  Bookit
//
//  Created by Ranjan on 28/12/21.
//

import UIKit

class NPEarningVC: UIViewController {
    
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
                lblNavigationTitle.text = "CLUB REVIEW"
                lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
                lblNavigationTitle.backgroundColor = .clear
            }
        }
                    
    // ***************************************************************** // nav
    
    
    @IBOutlet weak var btnToday:UIButton!{
        didSet{
            btnToday.backgroundColor = BUTTON_DARK_APP_COLOR
            btnToday.tintColor = .white
            btnToday.addBottomBorder(with: .yellow, andWidth: 1.0)
            btnToday.setTitle("TODAY", for: .normal)
        }
    }
    
    @IBOutlet weak var btnWeekly:UIButton!{
        didSet{
            btnWeekly.backgroundColor = BUTTON_DARK_APP_COLOR
            btnWeekly.tintColor = .white
            btnWeekly.addBottomBorder(with: .yellow, andWidth: 1.0)
            btnWeekly.setTitle("WEEKLY", for: .normal)
        }
    }
    
    @IBOutlet weak var viwLeft:UIView!{
        didSet{
            viwLeft.backgroundColor = .white
            viwLeft.layer.cornerRadius = 10.0
            viwLeft.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var viwRight:UIView!{
        didSet{
            viwRight.backgroundColor = .white
            viwRight.layer.cornerRadius = 10.0
            viwRight.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var lblTotalEarnig:UILabel!
    @IBOutlet weak var lblTotalBooking:UILabel!
   
    @IBOutlet weak var tablView:UITableView!{
        didSet {
            tablView.delegate = self
            tablView.dataSource = self
            tablView.backgroundColor =  APP_BASIC_COLOR
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = APP_BASIC_COLOR
        self.navigationController?.isNavigationBarHidden = true
        self.tablView.separatorColor = .clear
    }
    


}

//MARK:- TABLE VIEW -
extension NPEarningVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NPEarningTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NPEarningTableCell") as! NPEarningTableViewCell
        
        cell.backgroundColor = APP_BASIC_COLOR
      
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.imgProfile.image = UIImage(named: "dan")
        cell.btnTotalAmount.setTitle("$45", for: .normal)
        
       // cell.btnSignUp.addTarget(self, action: #selector(btnSignUpTapped), for: .touchUpInside)
        
        
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
        return 120
    }
    
    
}

extension NPEarningVC: UITableViewDelegate {
    
}
