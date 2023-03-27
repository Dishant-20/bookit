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
    
    @IBOutlet weak var txt_city:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txt_city,
                              tfName: txt_city.text!,
                              tfCornerRadius: 27.5,
                              tfpadding: paddingFromLeftIs,
                              tfBorderWidth: 0.8,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "City")
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
    
    
    
    @IBOutlet weak var view_bg:UIView! {
        didSet {
            view_bg.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_bg.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            view_bg.layer.shadowOpacity = 1.0
            view_bg.layer.shadowRadius = 15.0
            view_bg.layer.masksToBounds = false
            view_bg.layer.cornerRadius = 15
            view_bg.backgroundColor = .systemGray4
        }
    }
    
    @IBOutlet weak var img_logo:UIImageView! {
        didSet {
            /*img_logo.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            img_logo.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            img_logo.layer.shadowOpacity = 1.0
            img_logo.layer.shadowRadius = 15.0
            img_logo.layer.masksToBounds = false
            img_logo.layer.cornerRadius = 15
            img_logo.backgroundColor = .white*/
        }
    }
    
    @IBOutlet weak var btn_country:UIButton!
    @IBOutlet weak var btn_state:UIButton!
    
    @IBOutlet weak var img_banner:UIImageView! {
        didSet {
            /*img_banner.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            img_banner.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            img_banner.layer.shadowOpacity = 1.0
            img_banner.layer.shadowRadius = 15.0
            img_banner.layer.masksToBounds = false
            img_banner.layer.cornerRadius = 15
            img_banner.backgroundColor = .white*/
        }
    }
    
    @IBOutlet weak var btn_open_time:UIButton!
    @IBOutlet weak var btn_close_time:UIButton!
    
    @IBOutlet weak var btnSave:UIButton!{
        
        didSet{
            btnSave.layer.cornerRadius = 27.5
            btnSave.clipsToBounds = true
            btnSave.setTitle("SAVE & CONTINUE", for: .normal)
            btnSave.backgroundColor =  BUTTON_DARK_APP_COLOR
        }
    }

    @IBOutlet weak var txt_view_about:UITextView! {
        didSet {
            txt_view_about.text = ""
            txt_view_about.layer.cornerRadius = 16
            txt_view_about.clipsToBounds = true
            txt_view_about.backgroundColor = .white
            txt_view_about.textColor = .black
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
