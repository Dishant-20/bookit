//
//  PaymentTableViewCell.swift
//  Bookit
//
//  Created by Ranjan on 07/01/22.
//

import UIKit

class PaymentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbl_table_capacity:UILabel! {
        didSet {
            lbl_table_capacity.textColor = .black
        }
    }
    
    @IBOutlet weak var view_bg_payment:UIView! {
        didSet {
            view_bg_payment.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_bg_payment.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            view_bg_payment.layer.shadowOpacity = 1.0
            view_bg_payment.layer.shadowRadius = 15.0
            view_bg_payment.layer.masksToBounds = false
            view_bg_payment.layer.cornerRadius = 15
            view_bg_payment.backgroundColor = .white
        }
    }
    
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
    
    @IBOutlet weak var lbl_total_number_of_Seats:UILabel! {
        didSet {
            lbl_total_number_of_Seats.textColor = .black
            lbl_total_number_of_Seats.isHidden = false
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

    @IBOutlet weak var lbl_booking_fee:UILabel! {
        didSet {
            lbl_booking_fee.textColor = .black
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
