//
//  WelcomeVC.swift
//  Bookit
//
//  Created by Ranjan on 18/12/21.
//

import UIKit

// MARK:- LOCATION -
import CoreLocation

var selectedProfile:String = ""

class WelcomeVC: UIViewController , CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    // MARK:- SAVE LOCATION STRING -
    var strSaveLatitude:String! = "0"
    var strSaveLongitude:String! = "0"
    var strSaveCountryName:String!
    var strSaveLocalAddress:String!
    var strSaveLocality:String!
    var strSaveLocalAddressMini:String!
    var strSaveStateName:String!
    var strSaveZipcodeName:String!
    
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
            
       /* @IBOutlet weak var btnBack:UIButton! {
            didSet {
                btnBack.tintColor = NAVIGATION_BACK_COLOR
            }
        }*/
            
        @IBOutlet weak var lblNavigationTitle:UILabel! {
            didSet {
                lblNavigationTitle.text = "WELCOME"
                lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
                lblNavigationTitle.backgroundColor = .clear
            }
        }
                    
    // ***************************************************************** // nav
    
    @IBOutlet weak var btnCustomer:UIButton!{
        didSet{
            btnCustomer.backgroundColor = NAVIGATION_COLOR
            btnCustomer.setTitle("CUSTOMER", for: .normal)
            btnCustomer.layer.cornerRadius = 27.5
            btnCustomer.clipsToBounds = true
            
            btnCustomer.addTarget(self, action: #selector(btnCustomerTapped), for: .touchUpInside)
        }
        
    }
    @IBOutlet weak var btnNightClubs:UIButton!{
        didSet{
            btnNightClubs.backgroundColor = BUTTON_DARK_APP_COLOR
            btnNightClubs.setTitle("Night Clubs", for: .normal)
            btnNightClubs.layer.cornerRadius = 27.5
            btnNightClubs.clipsToBounds = true
            btnNightClubs.addTarget(self, action: #selector(btnNightClubsTapped), for: .touchUpInside)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = APP_BASIC_COLOR
        
        self.rememberMe()
        
    }
    
    @objc func rememberMe() {
        
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {

            print(person as Any)

            if (person["role"] as! String) == "Customer" {

                let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NPHomeVC") as? NPHomeVC
                self.navigationController?.pushViewController(settingsVCId!, animated: false)

            }
            
            else if (person["role"] as! String) == "Club" {

                let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NPClubDetailVC") as? NPClubDetailVC
                self.navigationController?.pushViewController(settingsVCId!, animated: false)
                
//                loggedClubName = (person["fullName"] as! String)
//                loggedClubPhone = (person["contactNumber"] as! String)
//                loggedClubAddress = (person["address"] as! String)
//
//                print(loggedClubName)

            }
            
            else {

//                                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NPHomeVC")
//                                    self.navigationController?.pushViewController(push, animated: true)

            }
        }
    }
    
    @objc func get_current_location_permission() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            
            let authorizationStatus: CLAuthorizationStatus
            
            if #available(iOS 14, *) {
                authorizationStatus = locationManager.authorizationStatus
            } else {
                authorizationStatus = CLLocationManager.authorizationStatus()
            }
            
            switch authorizationStatus {
            case .notDetermined, .restricted, .denied:
                print("No access")
                self.strSaveLatitude = "0"
                self.strSaveLongitude = "0"
                
                /*let alertController = UIAlertController (title: "Location", message: "Your location is disable. To enable please click on Settings.", preferredStyle: .alert)
                
                let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                    
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    }
                }
                alertController.addAction(settingsAction)
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                alertController.addAction(cancelAction)
                
                present(alertController, animated: true, completion: nil)*/
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
                
            @unknown default:
                break
            }
        }
        
        
        
    }
    
    @objc func btnCustomerTapped(){
        
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "GetStartedNowVC") as? GetStartedNowVC
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
        selectedProfile = "customer"
    }
    
    @objc func btnNightClubsTapped(){
        
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NPSignUpVC") as? NPSignUpVC
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
        
        selectedProfile = "nightclub"
        
    }
    
    

}
