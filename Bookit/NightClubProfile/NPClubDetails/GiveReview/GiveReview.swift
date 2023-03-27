//
//  GiveReview.swift
//  Bookit
//
//  Created by Apple on 19/01/22.
//

import UIKit
import Alamofire
import SDWebImage
import SwiftGifOrigin
import SPConfetti

class GiveReview: UIViewController {

    var strCountSelect:String! = "1"
    
    var str_club_id:String!
    
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
                lblNavigationTitle.text = "REVIEW"
                lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
                lblNavigationTitle.backgroundColor = .clear
            }
        }
                    
    // ***************************************************************** // nav
    
    @IBOutlet weak var viewBGforRate:UIView! {
        didSet {
            viewBGforRate.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            viewBGforRate.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            viewBGforRate.layer.shadowOpacity = 1.0
            viewBGforRate.layer.shadowRadius = 15.0
            viewBGforRate.layer.masksToBounds = false
            viewBGforRate.layer.cornerRadius = 15
            viewBGforRate.isHidden = false
        }
    }
    
    @IBOutlet weak var btnStarOne:UIButton! {
        didSet {
            btnStarOne.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
    }
    
    @IBOutlet weak var btnStarTwo:UIButton! {
        didSet {
            btnStarTwo.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
    @IBOutlet weak var btnStarThree:UIButton! {
        didSet {
            btnStarThree.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
    @IBOutlet weak var btnStarFour:UIButton! {
        didSet {
            btnStarFour.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
    @IBOutlet weak var btnStarFive:UIButton! {
        didSet {
            btnStarFive.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
    @IBOutlet weak var btnSubmitReview:UIButton! {
        didSet {
            btnSubmitReview.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
            btnSubmitReview.tintColor = .white
        }
    }
    
    @IBOutlet weak var txtView:UITextView! {
        didSet {
            txtView.layer.cornerRadius = 8
            txtView.clipsToBounds = true
            txtView.layer.borderWidth = 1
            txtView.layer.borderColor = UIColor.lightGray.cgColor
            txtView.text = ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

         self.btnSubmitReview.addTarget(self, action: #selector(give_review_wb), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        self.btnSubmitReview.addTarget(self, action: #selector(give_review_wb), for: .touchUpInside)
        
        self.btnStarOne.addTarget(self, action: #selector(starOneClickMethod), for: .touchUpInside)
        self.btnStarTwo.addTarget(self, action: #selector(starTwoClickMethod), for: .touchUpInside)
        self.btnStarThree.addTarget(self, action: #selector(starThreeClickMethod), for: .touchUpInside)
        self.btnStarFour.addTarget(self, action: #selector(starFourClickMethod), for: .touchUpInside)
        self.btnStarFive.addTarget(self, action: #selector(starFiveClickMethod), for: .touchUpInside)
        
        self.btnBack.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        
    }

    @objc override func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func back_click_method() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func starOneClickMethod() {
        
        self.btnStarOne.setImage(UIImage(systemName: "star.fill"), for: .normal)
        self.btnStarTwo.setImage(UIImage(systemName: "star"), for: .normal)
        self.btnStarThree.setImage(UIImage(systemName: "star"), for: .normal)
        self.btnStarFour.setImage(UIImage(systemName: "star"), for: .normal)
        self.btnStarFive.setImage(UIImage(systemName: "star"), for: .normal)
        
        self.strCountSelect = "1"
    }
    
    @objc func starTwoClickMethod() {
        
        self.btnStarOne.setImage(UIImage(systemName: "star.fill"), for: .normal)
        self.btnStarTwo.setImage(UIImage(systemName: "star.fill"), for: .normal)
        self.btnStarThree.setImage(UIImage(systemName: "star"), for: .normal)
        self.btnStarFour.setImage(UIImage(systemName: "star"), for: .normal)
        self.btnStarFive.setImage(UIImage(systemName: "star"), for: .normal)
        
        self.strCountSelect = "2"
        
    }
    
    @objc func starThreeClickMethod() {
        
        self.btnStarOne.setImage(UIImage(systemName: "star.fill"), for: .normal)
        self.btnStarTwo.setImage(UIImage(systemName: "star.fill"), for: .normal)
        self.btnStarThree.setImage(UIImage(systemName: "star.fill"), for: .normal)
        self.btnStarFour.setImage(UIImage(systemName: "star"), for: .normal)
        self.btnStarFive.setImage(UIImage(systemName: "star"), for: .normal)
        
        self.strCountSelect = "3"
        
    }
    
    @objc func starFourClickMethod() {
        
        self.btnStarOne.setImage(UIImage(systemName: "star.fill"), for: .normal)
        self.btnStarTwo.setImage(UIImage(systemName: "star.fill"), for: .normal)
        self.btnStarThree.setImage(UIImage(systemName: "star.fill"), for: .normal)
        self.btnStarFour.setImage(UIImage(systemName: "star.fill"), for: .normal)
        self.btnStarFive.setImage(UIImage(systemName: "star"), for: .normal)
        
        self.strCountSelect = "4"
        
    }
    
    @objc func starFiveClickMethod() {
        
        self.btnStarOne.setImage(UIImage(systemName: "star.fill"), for: .normal)
        self.btnStarTwo.setImage(UIImage(systemName: "star.fill"), for: .normal)
        self.btnStarThree.setImage(UIImage(systemName: "star.fill"), for: .normal)
        self.btnStarFour.setImage(UIImage(systemName: "star.fill"), for: .normal)
        self.btnStarFive.setImage(UIImage(systemName: "star.fill"), for: .normal)
        
        self.strCountSelect = "5"
    }
    
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func give_review_wb() {
        
        
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
         if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
         // print(person as Any)
        
         let x : Int = person["userId"] as! Int
         let myString = String(x)
        
        let params = give_review_to_club(action: "submitreview",
                                         reviewTo: String(self.str_club_id),
                                         reviewFrom: String(myString),
                                         star: String(self.strCountSelect),
                                         message: String(self.txtView.text!))
        
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
                        
                        // SPConfetti.stopAnimating()
                        
                        self.navigationController?.popViewController(animated: true)
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
