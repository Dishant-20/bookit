//
//  NPClubDetailTableViewCell.swift
//  Bookit
//
//  Created by Ranjan on 22/12/21.
//

import UIKit

class NPClubDetailTableViewCell: UITableViewCell {
    
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
    
    @IBOutlet weak var imgBG:UIImageView! {
        didSet{
           // imgBG.layer.cornerRadius = 8.0
            //imgBG.clipsToBounds = true
            //imgBG.layer.borderWidth = 0.8
            //imgBG.layer.borderColor = UIColor.systemGray6.cgColor
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
    
    @IBOutlet weak var btnLike:UIButton!{
        didSet{
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
    @IBOutlet weak var btnStarFive:UIButton!{
        didSet{
            //btnShare.layer.cornerRadius = 4.0
            //btnShare.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var lblRating:UILabel!{
        didSet{
            lblRating.textColor = .white
        }
    }
    
    @IBOutlet weak var lblName:UILabel!{
        didSet{
            lblName.textColor = .white
        }
    }
    
    @IBOutlet weak var btnPhone:UIButton!{
        didSet{
            //btnShare.layer.cornerRadius = 4.0
            //btnShare.clipsToBounds = true
            //btnPhone.setTitle("+", for: <#T##UIControl.State#>)
            btnPhone.backgroundColor = .clear
            btnPhone.tintColor = .white
        }
    }
    
    @IBOutlet weak var btnLocation:UIButton!{
        didSet{
            //btnShare.layer.cornerRadius = 4.0
            //btnShare.clipsToBounds = true
            //btnPhone.setTitle("+", for: <#T##UIControl.State#>)
            btnLocation.backgroundColor = .clear
            btnLocation.tintColor = .white
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
    
    @IBOutlet weak var btnTables:UIButton! {
        didSet {
            btnTables.setTitle("Tables", for: .normal)
            btnTables.setTitleColor(.black, for: .normal)
            btnTables.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btnTables.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            btnTables.layer.shadowOpacity = 1.0
            btnTables.layer.shadowRadius = 15.0
            btnTables.layer.masksToBounds = false
            btnTables.layer.cornerRadius = 15
            btnTables.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var btnReviews:UIButton!{
        didSet {
            btnReviews.setTitle("Reviews", for: .normal)
            btnReviews.setTitleColor(.black, for: .normal)
            btnReviews.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btnReviews.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            btnReviews.layer.shadowOpacity = 1.0
            btnReviews.layer.shadowRadius = 15.0
            btnReviews.layer.masksToBounds = false
            btnReviews.layer.cornerRadius = 15
            btnReviews.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var btnDirections:UIButton!{
        didSet {
            btnDirections.setTitle("Directions", for: .normal)
            btnDirections.setTitleColor(.black, for: .normal)
            btnDirections.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btnDirections.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            btnDirections.layer.shadowOpacity = 1.0
            btnDirections.layer.shadowRadius = 15.0
            btnDirections.layer.masksToBounds = false
            btnDirections.layer.cornerRadius = 15
            btnDirections.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var btnPhotos:UIButton!{
        didSet {
            btnPhotos.setTitle("Photos", for: .normal)
            btnPhotos.setTitleColor(.black, for: .normal)
            btnPhotos.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btnPhotos.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            btnPhotos.layer.shadowOpacity = 1.0
            btnPhotos.layer.shadowRadius = 15.0
            btnPhotos.layer.masksToBounds = false
            btnPhotos.layer.cornerRadius = 15
            btnPhotos.backgroundColor = .white
            
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
