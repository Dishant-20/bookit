//
//  AddTableTableViewCell.swift
//  Bookit
//
//  Created by Ranjan on 21/12/21.
//

import UIKit

class AddTableTableViewCell: UITableViewCell {
    
    let paddingFromLeftIs:CGFloat = 20
    
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
                              tfPlaceholderText: "Total Seat")
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
                              tfPlaceholderText: "Price Per Seat")
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
    
    @IBOutlet weak var btnSave:UIButton!{
        
        didSet{
            btnSave.layer.cornerRadius = 27.5
            btnSave.clipsToBounds = true
            btnSave.setTitle("SAVE & CONTINUE", for: .normal)
            btnSave.backgroundColor =  BUTTON_DARK_APP_COLOR
        }
    }
    
    @IBOutlet weak var btnSkip:UIButton!{
        
        didSet{
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
