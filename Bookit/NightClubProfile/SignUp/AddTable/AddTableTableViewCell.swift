//
//  AddTableTableViewCell.swift
//  Bookit
//
//  Created by Ranjan on 21/12/21.
//

import UIKit

class AddTableTableViewCell: UITableViewCell {
    
    let paddingFromLeftIs:CGFloat = 20
    
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
    
    @IBOutlet weak var img_table_image:UIImageView! {
        didSet {
            img_table_image.layer.cornerRadius = 12
            img_table_image.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var txtTableNumber:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txtTableNumber,
                              tfName: txtTableNumber.text!,
                              tfCornerRadius: 27.5,
                              tfpadding: paddingFromLeftIs,
                              tfBorderWidth: 0.8,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Table name/Number")
        }
    }
    
    
    @IBOutlet weak var txtTotaaSeat:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txtTotaaSeat,
                              tfName: txtTotaaSeat.text!,
                              tfCornerRadius: 27.5,
                              tfpadding: paddingFromLeftIs,
                              tfBorderWidth: 0.8,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Total guest")
            txtTotaaSeat.keyboardType = .numberPad
        }
    }
    
    @IBOutlet weak var txtPrice:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txtPrice,
                              tfName: txtPrice.text!,
                              tfCornerRadius: 27.5,
                              tfpadding: paddingFromLeftIs,
                              tfBorderWidth: 0.8,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "table price...")
            txtPrice.keyboardType = .numberPad
        }
    }
    
    @IBOutlet weak var txtUploadPic:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txtUploadPic,
                              tfName: txtUploadPic.text!,
                              tfCornerRadius: 27.5,
                              tfpadding: paddingFromLeftIs,
                              tfBorderWidth: 0.8,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Upload Table Picture")
        }
    }
    
    @IBOutlet weak var btn_advance_percentage:UIButton! {
        didSet {
            btn_advance_percentage.setTitle("", for: .normal)
            btn_advance_percentage.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var txt_advance_percentage:UITextField! {
        didSet {
            txt_advance_percentage.tag = 100
            Utils.textFieldUI(textField: txt_advance_percentage,
                              tfName: txt_advance_percentage.text!,
                              tfCornerRadius: 27.5,
                              tfpadding: paddingFromLeftIs,
                              tfBorderWidth: 0.8,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Advance %")
        }
    }
    
    
    @IBOutlet weak var imgUpload:UIImageView! {
        didSet {
            
        }
    }
    
    
    @IBOutlet weak var btnUploadImg:UIButton!{
        
        didSet{
            //btnAddTable.layer.cornerRadius = 27.5
            //btnAddTable.clipsToBounds = true
            btnUploadImg.setTitle("", for: .normal)
            btnUploadImg.backgroundColor =  .clear
            btnUploadImg.tintColor = .systemYellow
        }
    }
    
    
    @IBOutlet weak var btnAddTable:UIButton!{
        
        didSet{
            //btnAddTable.layer.cornerRadius = 27.5
            //btnAddTable.clipsToBounds = true
            btnAddTable.setTitle("+Add More Table", for: .normal)
            btnAddTable.backgroundColor =  .clear
            btnAddTable.tintColor = .systemYellow
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
    
    @IBOutlet weak var lbl_description:UITextView! {
        didSet {
            
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
    
    @IBOutlet weak var btnSkip:UIButton! {
        didSet {
            //btnSkip.layer.cornerRadius = 27.5
            //btnSkip.clipsToBounds = true
            btnSkip.setTitle("SKIP FOR NOW", for: .normal)
            btnSkip.backgroundColor =  .clear
            btnSkip.tintColor = .link
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
