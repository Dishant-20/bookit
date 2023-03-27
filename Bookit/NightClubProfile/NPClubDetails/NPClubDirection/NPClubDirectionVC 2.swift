//
//  NPClubDirectionVC.swift
//  Bookit
//
//  Created by Ranjan on 23/12/21.
//

import UIKit
import CoreLocation
import MapKit

class NPClubDirectionVC: UIViewController {
    
    var dict_get_direction_details:NSDictionary!
    
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
                lblNavigationTitle.text = "DIRECTIONS"
                lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
                lblNavigationTitle.backgroundColor = .clear
            }
        }
                    
    // ***************************************************************** // nav
    
    @IBOutlet weak var map:MKMapView!
    
    @IBOutlet weak var btnLocation:UIButton!{
        didSet{
            btnLocation.setTitle("", for: .normal)
            
        }
    }
    
    @IBOutlet weak var btnStartDirection:UIButton!{
        didSet{
            btnStartDirection.setTitle("START DIRECTION", for: .normal)
            btnStartDirection.layer.cornerRadius = 27.5
            btnStartDirection.clipsToBounds =  true
            btnStartDirection.tintColor = .white
            btnStartDirection.backgroundColor = NAVIGATION_COLOR
           
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = APP_BASIC_COLOR
        self.navigationController?.isNavigationBarHidden = true
        
        print(self.dict_get_direction_details as Any)
        
        btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        let london = MKPointAnnotation()
        london.title = "London"
        london.coordinate = CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275)
        map.addAnnotation(london)
        
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }

        return annotationView
    }

}
