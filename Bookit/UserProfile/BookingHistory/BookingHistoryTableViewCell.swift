//
//  BookingHistoryTableViewCell.swift
//  Bookit
//
//  Created by Ranjan on 27/12/21.
//

import UIKit

class BookingHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viw:UIView!{
        didSet{
            viw.backgroundColor = APP_BASIC_COLOR
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
    
    @IBOutlet weak var lblName:UILabel!
    
    @IBOutlet weak var lblDate:UILabel!
    
    @IBOutlet weak var btnLocation:UIButton!{
        didSet{
            btnLocation.tintColor = .white
        }
    }
    
    @IBOutlet weak var btnSeats:UIButton!{
        didSet{
            
            btnSeats.layer.cornerRadius = 20.0
            btnSeats.clipsToBounds = true
            btnSeats.backgroundColor = BUTTON_DARK_APP_COLOR
            btnSeats.tintColor = .white
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
