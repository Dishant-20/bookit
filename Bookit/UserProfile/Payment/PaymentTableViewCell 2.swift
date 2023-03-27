//
//  PaymentTableViewCell.swift
//  Bookit
//
//  Created by Ranjan on 07/01/22.
//

import UIKit

class PaymentTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var btnAdvance:UIButton!{
        didSet {
            
            btnAdvance.backgroundColor = NAVIGATION_COLOR
            btnAdvance.layer.cornerRadius = 8.0
            btnAdvance.clipsToBounds = true
            btnAdvance.tintColor = .white
        }
    }
    
    @IBOutlet weak var btnTotal:UIButton!{
        didSet{
            
            btnTotal.backgroundColor = .lightGray
            btnTotal.layer.cornerRadius = 8.0
            btnTotal.clipsToBounds = true
            btnTotal.tintColor = .black
        }
    }
    
    @IBOutlet weak var viwCardDetails:UIView!{
        didSet{
            viwCardDetails.layer.cornerRadius = 8.0
            viwCardDetails.clipsToBounds = true
            viwCardDetails.backgroundColor = BUTTON_DARK_APP_COLOR
        }
    }
    
    @IBOutlet weak var lblCardNumber:UILabel! {
        didSet {
            lblCardNumber.textColor = .white
            lblCardNumber.isHidden = true
        }
    }
    
    @IBOutlet weak var lbl_total_amount:UILabel! {
        didSet {
            lbl_total_amount.textColor = .black
            lbl_total_amount.isHidden = false
            lbl_total_amount.text = "Total amount to pay :"
        }
    }
    
    @IBOutlet weak var lblCardExpDate:UILabel!{
        didSet{
            lblCardExpDate.textColor = .white
            lblCardExpDate.isHidden = true
        }
    }
    
    @IBOutlet weak var imgCardType:UIImageView!{
        didSet{
            imgCardType.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var txtNameOnCard:UITextField! {
        didSet {
           
            txtNameOnCard.borderStyle = UITextField.BorderStyle.none
            txtNameOnCard.textAlignment = .center
            txtNameOnCard.keyboardType = .default
            
        }
    }
    @IBOutlet weak var txtCardNumber:UITextField! {
        didSet {
            
            txtCardNumber.borderStyle = UITextField.BorderStyle.none
            txtCardNumber.textAlignment = .center
            txtCardNumber.keyboardType = .numberPad
            txtCardNumber.backgroundColor = .white
        }
    }
    @IBOutlet weak var txtExpDate:UITextField! {
        didSet {
            
            txtExpDate.borderStyle = UITextField.BorderStyle.none
            txtExpDate.textAlignment = .center
            txtExpDate.keyboardType = .numberPad
            txtExpDate.backgroundColor = .white
        }
    }
    @IBOutlet weak var txtCVV:UITextField! {
        didSet {
        
            txtCVV.borderStyle = UITextField.BorderStyle.none
            txtCVV.textAlignment = .center
            txtCVV.keyboardType = .numberPad
            txtCVV.isSecureTextEntry = true
            txtCVV.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var btnCvvHelp:UIButton!{
        didSet{
            
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
