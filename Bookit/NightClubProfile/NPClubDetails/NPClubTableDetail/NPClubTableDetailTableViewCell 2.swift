//
//  NPClubTableDetailTableViewCell.swift
//  Bookit
//
//  Created by Ranjan on 22/12/21.
//

import UIKit

class NPClubTableDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewTab:UIView!{
        didSet{
            viewTab.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var imgTable:UIImageView!{
        didSet{
            imgTable.layer.cornerRadius = 10.0
            imgTable.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var lblTableNum:UILabel!{
        didSet{
            lblTableNum.textColor = .black
        }
    }
    
    @IBOutlet weak var lblPrice:UILabel!{
        didSet{
            lblPrice.textColor = .systemGreen
        }
    }
    
    @IBOutlet weak var btnBook:UIButton!{
        didSet{
            btnBook.layer.cornerRadius = 20
            btnBook.clipsToBounds =  true
            btnBook.tintColor = .white
            btnBook.backgroundColor = .link
            btnBook.setTitle("Book", for: .normal)
        }
    }
    
    @IBOutlet weak var btnSeat:UIButton!{
        didSet{
            btnSeat.layer.cornerRadius = 20
            btnSeat.clipsToBounds =  true
            btnSeat.tintColor = .white
            btnSeat.backgroundColor = .systemGreen
            btnSeat.setTitle("Seat", for: .normal)
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
