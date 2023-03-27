//
//  NPHomeTableViewCell.swift
//  Bookit
//
//  Created by Ranjan on 22/12/21.
//

import UIKit

class NPHomeTableViewCell: UITableViewCell {
    
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
            imgBG.layer.cornerRadius = 8.0
            imgBG.clipsToBounds = true
            imgBG.layer.borderWidth = 0.8
            imgBG.layer.borderColor = UIColor.systemGray6.cgColor
           // imageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var btnShare:UIButton! {
        didSet {
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
    
    @IBOutlet weak var btnStarOne:UIButton! {
        didSet {
            btnStarOne.tintColor = .systemYellow
             
        }
    }
    @IBOutlet weak var btnStarTwo:UIButton! {
        didSet {
            btnStarTwo.tintColor = .systemYellow
        }
    }
    @IBOutlet weak var btnStarThree:UIButton! {
        didSet {
            btnStarThree.tintColor = .systemYellow
        }
    }
    @IBOutlet weak var btnStarFour:UIButton! {
        didSet {
            btnStarFour.tintColor = .systemYellow
        }
    }
    @IBOutlet weak var btnStarFive:UIButton! {
        didSet {
            btnStarFive.tintColor = .systemYellow
        }
    }
    
    @IBOutlet weak var lblName:UILabel! {
        didSet {
            lblName.textColor = .black
        }
    }
    
    @IBOutlet weak var btnPhone:UIButton! {
        didSet{
            //btnShare.layer.cornerRadius = 4.0
            //btnShare.clipsToBounds = true
            //btnPhone.setTitle("+", for: <#T##UIControl.State#>)
            btnPhone.backgroundColor = .clear
            btnPhone.tintColor = .link
            btnPhone.setTitleColor(.black, for: .normal)
            // btnPhone.titleLabel?.font =  UIFont.init(name: "Avenir-Next Regular", size: 12)
        }
    }
    
    @IBOutlet weak var btnLocation:UIButton!{
        didSet{
            //btnShare.layer.cornerRadius = 4.0
            //btnShare.clipsToBounds = true
            //btnPhone.setTitle("+", for: <#T##UIControl.State#>)
            btnLocation.backgroundColor = .clear
            btnLocation.tintColor = .link
            btnLocation.setTitleColor(.black, for: .normal)
        }
    }
    
    @IBOutlet weak var btnDistance:UIButton!{
        didSet{
            //btnShare.layer.cornerRadius = 4.0
            //btnShare.clipsToBounds = true
            //btnPhone.setTitle("+", for: <#T##UIControl.State#>)
            btnDistance.backgroundColor = .systemGreen
            btnDistance.tintColor = .white
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
