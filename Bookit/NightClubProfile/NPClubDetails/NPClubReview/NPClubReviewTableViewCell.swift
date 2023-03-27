//
//  NPClubReviewTableViewCell.swift
//  Bookit
//
//  Created by Ranjan on 23/12/21.
//

import UIKit

class NPClubReviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viw:UIView!{
        didSet{
            
            viw.backgroundColor = .clear
            
            viw.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            viw.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            viw.layer.shadowOpacity = 1.0
            viw.layer.shadowRadius = 15.0
            viw.layer.masksToBounds = false
        }
    }
    
    @IBOutlet weak var imgProfile:UIImageView!{
        didSet{
            
            imgProfile.layer.cornerRadius = 25.0
            imgProfile.clipsToBounds = true
            imgProfile.layer.borderWidth = 5
            imgProfile.layer.borderColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1).cgColor
            
        }
    }
    
    @IBOutlet weak var lblName:UILabel!
    
    @IBOutlet weak var lblDate:UILabel!
    
    @IBOutlet weak var btnStarOne:UIButton! {
        didSet {
            btnStarOne.tintColor = .systemYellow
            //btnShare.layer.cornerRadius = 4.0
            //btnShare.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var btnStarTwo:UIButton! {
        didSet {
            btnStarTwo.tintColor = .systemYellow
            //btnShare.layer.cornerRadius = 4.0
            //btnShare.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var btnStarThree:UIButton! {
        didSet {
            btnStarThree.tintColor = .systemYellow
            
            //btnShare.layer.cornerRadius = 4.0
            //btnShare.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var btnStarFour:UIButton! {
        didSet {
            btnStarFour.tintColor = .systemYellow
            
            //btnShare.layer.cornerRadius = 4.0
            //btnShare.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var btnStarFive:UIButton! {
        didSet {
            btnStarFive.tintColor = .systemYellow
            
            //btnShare.layer.cornerRadius = 4.0
            //btnShare.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var lblReview:UILabel!
   
    @IBOutlet weak var btn_flag:UIButton! {
        didSet {
            btn_flag.isUserInteractionEnabled = true
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
