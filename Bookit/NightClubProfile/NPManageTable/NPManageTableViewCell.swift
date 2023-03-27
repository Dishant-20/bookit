//
//  NPManageTableViewCell.swift
//  Bookit
//
//  Created by Ranjan on 29/12/21.
//

import UIKit

class NPManageTableViewCell: UITableViewCell {
    
    
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
            lblTableNum.textColor = .white
        }
    }
    
    @IBOutlet weak var lblPrice:UILabel!{
        didSet{
            lblPrice.textColor = .systemGreen
            lblPrice.font = UIFont.boldSystemFont(ofSize: 16.0)
        }
    }
    
    @IBOutlet weak var btnEdit:UIButton!{
        didSet{
            btnEdit.layer.cornerRadius = 12.0
            btnEdit.clipsToBounds =  true
            btnEdit.tintColor = .white
            btnEdit.backgroundColor = BUTTON_DARK_APP_COLOR
            btnEdit.setTitle("Update", for: .normal)
        }
    }
    
    @IBOutlet weak var btnSeat:UIButton!{
        didSet{
            btnSeat.layer.cornerRadius = 12.0
            btnSeat.clipsToBounds =  true
            btnSeat.tintColor = .white
            btnSeat.backgroundColor = .systemGreen
        }
    }
    
    @IBOutlet weak var lbl_description:UILabel! {
        didSet {
            
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
