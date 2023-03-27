//
//  BookingDetailsTableViewCell.swift
//  Bookit
//
//  Created by Ranjan on 27/12/21.
//

import UIKit

class BookingDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viw:UIView! {
        didSet {
            viw.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            viw.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            viw.layer.shadowOpacity = 1.0
            viw.layer.shadowRadius = 15.0
            viw.layer.masksToBounds = false
            viw.layer.cornerRadius = 15
            viw.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var imgBG:UIImageView!{
        didSet{
           // imgBG.layer.cornerRadius = 8.0
            imgBG.clipsToBounds = true
            imgBG.layer.borderWidth = 0.8
            imgBG.layer.borderColor = UIColor.systemGray6.cgColor
           // imageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var btnShare:UIButton!{
        didSet{
            //btnShare.layer.cornerRadius = 4.0
            //btnShare.clipsToBounds = true
            
            btnShare.backgroundColor = .white
            btnShare.tintColor = .systemYellow
            btnShare.layer.cornerRadius = 8
            btnShare.clipsToBounds = true
            
        }
    }
    
    @IBOutlet weak var btnLike:UIButton! {
        didSet {
            //btnShare.layer.cornerRadius = 4.0
            //btnShare.clipsToBounds = true
            
            btnLike.backgroundColor = .white
            btnLike.tintColor = .darkGray
            btnLike.layer.cornerRadius = 8
            btnLike.clipsToBounds = true
            
        }
    }
    
    @IBOutlet weak var btnStarOne:UIButton!{
        didSet{
            //btnShare.layer.cornerRadius = 4.0
            //btnShare.clipsToBounds = true
        }
    }
    @IBOutlet weak var btnStarTwo:UIButton!{
        didSet{
            //btnShare.layer.cornerRadius = 4.0
            //btnShare.clipsToBounds = true
        }
    }
    @IBOutlet weak var btnStarThree:UIButton!{
        didSet{
            //btnShare.layer.cornerRadius = 4.0
            //btnShare.clipsToBounds = true
        }
    }
    @IBOutlet weak var btnStarFour:UIButton!{
        didSet{
            //btnShare.layer.cornerRadius = 4.0
            //btnShare.clipsToBounds = true
        }
    }
    @IBOutlet weak var btnStarFive:UIButton! {
        didSet {
            //btnShare.layer.cornerRadius = 4.0
            //btnShare.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var lblRating:UILabel! {
        didSet {
            lblRating.textColor = .white
        }
    }
    
    @IBOutlet weak var lblName:UILabel!{
        didSet{
            lblName.textColor = .black
        }
    }
    
    @IBOutlet weak var btnPhone:UIButton!{
        didSet{
            btnPhone.backgroundColor = .clear
            btnPhone.tintColor = .black
            btnLocation.setTitleColor(.black, for: .normal)
        }
    }
    
    @IBOutlet weak var btnLocation:UIButton!{
        didSet{
            btnLocation.backgroundColor = .clear
            btnLocation.tintColor = .black
            btnLocation.setTitleColor(.black, for: .normal)
        }
    }
    
    @IBOutlet weak var btnDistance:UIButton!{
        didSet{
            
            btnDistance.backgroundColor = .systemGreen
            btnDistance.tintColor = .white
        }
    }
    
    @IBOutlet weak var lblTableNum:UILabel! {
        didSet {
            lblTableNum.textColor = .black
        }
    }
    
    @IBOutlet weak var lblTotalSeat:UILabel!
    
    @IBOutlet weak var lblDate:UILabel!
    
    @IBOutlet weak var lblTime:UILabel!
    
    @IBOutlet weak var lblTotalAmount:UILabel!
    
    @IBOutlet weak var lbl_booking_fee:UILabel! {
        didSet {
            lbl_booking_fee.textColor = .black
        }
    }
    
    @IBOutlet weak var lblAdvancedPay:UILabel!

    @IBOutlet weak var img_decline:UIImageView! {
        didSet {
            img_decline.layer.cornerRadius = 0
            img_decline.clipsToBounds = true
            img_decline.isHidden = true
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
