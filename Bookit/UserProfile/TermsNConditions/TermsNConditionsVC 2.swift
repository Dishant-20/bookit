//
//  TermsNConditionsVC.swift
//  Bookit
//
//  Created by Ranjan on 20/12/21.
//

import UIKit

class TermsNConditionsVC: UIViewController {
    
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
                lblNavigationTitle.text = "TERMS & CONDITIONS"
                lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
                lblNavigationTitle.backgroundColor = .clear
            }
        }
                    
    // ***************************************************************** // nav
    
    @IBOutlet weak var txtView:UITextView!{
        didSet{
            txtView.backgroundColor = .clear
            txtView.textColor = .white
            txtView.text =
            """
            TripAdvisor Traveller’s Choice Award 2021 winner lti Maafushivaru will host different exciting activities this joyful season from 24th evening until New Year’s Eve. Island festive experiences include unique  culinary offerings, special events and world-class live entertainment by award winning singer, model  and pianist Clarita de Quiroz.
            While most of the island festivities will begin on 24 December, the joyful season vibes start today  evening (Monday) with Christmas lights decorating most areas of the resort. On 24 December, little  VIP guests can get creative with face painting on the beach while enjoying soft-powdery sands under  their feet. To kick off Christmas Eve, guests are invited for a gala bubble party at Moodhu Grill beach  overlooking the pristine views of the Indian Ocean. Excitement for both little VIPs and adults will reach  its peak on Santa’s arrival at Water Bar who will delight kids with Christmas gifts while a sumptuous  gala dinner of exquisite selection of international dishes awaits at Cuisine Gallery. This will be followed  with a live music performance and upbeat party with Dj Simon to cap off Christmas Eve.
            Guests can embark on a festive culinary experiences such as Maldivian Food Trail, Ramen Night at  UMI, Japanese & Nikkei Night, Türk Mutfağı Menüy(Turkish Cuisine Specials), Comida Mexicana, all  spread out in different restaurant outlets of the resort.
            Closing to the finale of 2021, new year celebration countdown will start with bubbles party at Water  Bar followed by New Year’s Eve gala dinner at Cuisine Gallery. The grand 2021 finale countdown will  happen at Water Bar beach headed by Dj Simon who will then throw a New Year’s party to all guests  afterwards to welcome 2022.
            You can click here to see the full festive program details.
            
            TripAdvisor Traveller’s Choice Award 2021 winner lti Maafushivaru will host different exciting activities this joyful season from 24th evening until New Year’s Eve. Island festive experiences include unique  culinary offerings, special events and world-class live entertainment by award winning singer, model  and pianist Clarita de Quiroz.
            While most of the island festivities will begin on 24 December, the joyful season vibes start today  evening (Monday) with Christmas lights decorating most areas of the resort. On 24 December, little  VIP guests can get creative with face painting on the beach while enjoying soft-powdery sands under  their feet. To kick off Christmas Eve, guests are invited for a gala bubble party at Moodhu Grill beach  overlooking the pristine views of the Indian Ocean. Excitement for both little VIPs and adults will reach  its peak on Santa’s arrival at Water Bar who will delight kids with Christmas gifts while a sumptuous  gala dinner of exquisite selection of international dishes awaits at Cuisine Gallery. This will be followed  with a live music performance and upbeat party with Dj Simon to cap off Christmas Eve.
            Guests can embark on a festive culinary experiences such as Maldivian Food Trail, Ramen Night at  UMI, Japanese & Nikkei Night, Türk Mutfağı Menüy(Turkish Cuisine Specials), Comida Mexicana, all  spread out in different restaurant outlets of the resort.
            Closing to the finale of 2021, new year celebration countdown will start with bubbles party at Water  Bar followed by New Year’s Eve gala dinner at Cuisine Gallery. The grand 2021 finale countdown will  happen at Water Bar beach headed by Dj Simon who will then throw a New Year’s party to all guests  afterwards to welcome 2022.
            You can click here to see the full festive program details.
            """
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = APP_BASIC_COLOR
        self.navigationController?.isNavigationBarHidden = true
    }
    

}
