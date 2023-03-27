//
//  NPSignUpTableViewCell.swift
//  Bookit
//
//  Created by Ranjan on 20/12/21.
//

import UIKit

class NPSignUpTableViewCell: UITableViewCell {
    
    let paddingFromLeftIs:CGFloat = 40
    
    @IBOutlet weak var txtEmailAddress:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txtEmailAddress,
                              tfName: txtEmailAddress.text!,
                              tfCornerRadius: 27.5,
                              tfpadding: paddingFromLeftIs,
                              tfBorderWidth: 0.8,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Email Address")
        }
    }
    
    
    @IBOutlet weak var txtPassword:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txtPassword,
                              tfName: txtPassword.text!,
                              tfCornerRadius: 27.5,
                              tfpadding: paddingFromLeftIs,
                              tfBorderWidth: 0.8,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Password")
            txtPassword.isSecureTextEntry = true
        }
        
    }
    
    @IBOutlet weak var txtName:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txtName,
                              tfName: txtName.text!,
                              tfCornerRadius: 27.5,
                              tfpadding: paddingFromLeftIs,
                              tfBorderWidth: 0.8,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Name of Club")
        }
    }
    
    @IBOutlet weak var txtPhone:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txtPhone,
                              tfName: txtPhone.text!,
                              tfCornerRadius: 27.5,
                              tfpadding: paddingFromLeftIs,
                              tfBorderWidth: 0.8,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Phone")
        }
    }
    
    
    @IBOutlet weak var btnSignUp:UIButton!{
        
        didSet{
            btnSignUp.layer.cornerRadius = 27.5
            btnSignUp.clipsToBounds = true
            btnSignUp.setTitle("SAVE & CONTINUE", for: .normal)
            btnSignUp.backgroundColor =  BUTTON_DARK_APP_COLOR
        }
    }
    
    @IBOutlet weak var btnTnC:UIButton!{
        
        didSet{
            btnTnC.layer.cornerRadius = 8.0
            btnTnC.clipsToBounds = true
           // btnTnC.setTitle("SIGN IN", for: .normal)
            //btnTnC.backgroundColor =  BUTTON_DARK_APP_COLOR
        }
    }
    
    @IBOutlet weak var btnDontHavAcount:UIButton!{
        didSet{
            let myAttribute = [ NSAttributedString.Key.font: UIFont(name: "Avenir Heavy", size: 20.0)!]
            
            let myString = NSMutableAttributedString(string: "Already have an account - Sign In.", attributes: myAttribute )
            
            var myRange1 = NSRange(location: 0, length: 24)
            
            myString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range:myRange1 )
            
            btnDontHavAcount.setAttributedTitle(myString, for: .normal)
            
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
