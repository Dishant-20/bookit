//
//  AddressTableViewCell.swift
//  Bookit
//
//  Created by Ranjan on 21/12/21.
//

import UIKit

class AddressTableViewCell: UITableViewCell {
    
    
    let paddingFromLeftIs:CGFloat = 10
    
    @IBOutlet weak var txtAddress:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txtAddress,
                              tfName: txtAddress.text!,
                              tfCornerRadius: 27.5,
                              tfpadding: paddingFromLeftIs,
                              tfBorderWidth: 0.8,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Address")
        }
    }
    
    
    @IBOutlet weak var txtCountry:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txtCountry,
                              tfName: txtCountry.text!,
                              tfCornerRadius: 27.5,
                              tfpadding: paddingFromLeftIs,
                              tfBorderWidth: 0.8,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Country")
        }
    }
    
    @IBOutlet weak var txtState:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txtState,
                              tfName: txtState.text!,
                              tfCornerRadius: 27.5,
                              tfpadding: paddingFromLeftIs,
                              tfBorderWidth: 0.8,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "State")
        }
    }
    
    @IBOutlet weak var txtZipCode:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txtZipCode,
                              tfName: txtZipCode.text!,
                              tfCornerRadius: 27.5,
                              tfpadding: paddingFromLeftIs,
                              tfBorderWidth: 0.8,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Zip Code")
        }
    }
    
    @IBOutlet weak var txtClubOpenTime:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txtClubOpenTime,
                              tfName: txtClubOpenTime.text!,
                              tfCornerRadius: 27.5,
                              tfpadding: paddingFromLeftIs,
                              tfBorderWidth: 0.8,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Open Time")
        }
    }
    
    @IBOutlet weak var txtClubCloseTime:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txtClubCloseTime,
                              tfName: txtClubCloseTime.text!,
                              tfCornerRadius: 27.5,
                              tfpadding: paddingFromLeftIs,
                              tfBorderWidth: 0.8,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Close Time")
        }
    }
    
    @IBOutlet weak var txtUploadLogo:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txtUploadLogo,
                              tfName: txtUploadLogo.text!,
                              tfCornerRadius: 27.5,
                              tfpadding: paddingFromLeftIs,
                              tfBorderWidth: 0.8,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Upload Logo")
        }
    }
    
    @IBOutlet weak var txtUploadBanner:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txtUploadBanner,
                              tfName: txtUploadBanner.text!,
                              tfCornerRadius: 27.5,
                              tfpadding: paddingFromLeftIs,
                              tfBorderWidth: 0.8,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Upload Banner")
        }
    }
    
    @IBOutlet weak var btnSave:UIButton!{
        
        didSet{
            btnSave.layer.cornerRadius = 27.5
            btnSave.clipsToBounds = true
            btnSave.setTitle("SAVE & CONTINUE", for: .normal)
            btnSave.backgroundColor =  BUTTON_DARK_APP_COLOR
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
