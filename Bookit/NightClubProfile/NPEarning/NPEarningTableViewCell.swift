//
//  NPEarningTableViewCell.swift
//  Bookit
//
//  Created by Ranjan on 28/12/21.
//

import UIKit

class NPEarningTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viw:UIView!{
        didSet{
            viw.backgroundColor = .white
            viw.layer.cornerRadius = 10.0
            viw.clipsToBounds = true
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
    
    @IBOutlet weak var lblDate:UILabel!{
        didSet{
            
        lblDate.textColor = .link
        }
        
    }
    
    
    @IBOutlet weak var lblAdvanceAmount:UILabel!{
        didSet{
            
            lblAdvanceAmount.textColor = .darkGray
        }
        
    }
    
    
    @IBOutlet weak var btnTotalAmount:UIButton! {
        didSet {
            
            btnTotalAmount.layer.cornerRadius = 20.0
            btnTotalAmount.clipsToBounds = true
            btnTotalAmount.backgroundColor = BUTTON_DARK_APP_COLOR
            btnTotalAmount.tintColor = .white
            //btnTotalAmount.isEnabled = false
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
