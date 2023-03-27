//
//  NPBookingDetailTableViewCell.swift
//  Bookit
//
//  Created by Ranjan on 28/12/21.
//

import UIKit

class NPBookingDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viwCell:UIView!{
        didSet{
            viwCell.backgroundColor = BUTTON_DARK_APP_COLOR
        }
    }
    
    @IBOutlet weak var imgProfile:UIImageView!{
        didSet{
            
            imgProfile.clipsToBounds = true
            imgProfile.layer.cornerRadius = 30.0
            imgProfile.layer.borderWidth = 5
            imgProfile.layer.borderColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1).cgColor
            
        }
    }
    
    @IBOutlet weak var viwBelow:UIView!{
        didSet{
            viwBelow.backgroundColor = NAVIGATION_COLOR
        }
    }
    
    @IBOutlet weak var lblName:UILabel!
    
    @IBOutlet weak var lblPhone:UILabel!
    
    @IBOutlet weak var btnLocation:UIButton!{
        didSet{
            btnLocation.tintColor = .white
        }
    }
    
    @IBOutlet weak var lblTableNum:UILabel!
    
    @IBOutlet weak var lblTotalSeat:UILabel!
    
    @IBOutlet weak var lblDate:UILabel!
    
    @IBOutlet weak var lblTime:UILabel!
    
    @IBOutlet weak var lblTotalAmount:UILabel!
    
    @IBOutlet weak var lblAdvancedPay:UILabel!
    
    @IBOutlet weak var lblBookitFee:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
