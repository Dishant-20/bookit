//
//  BookingTableViewCell.swift
//  Bookit
//
//  Created by Ranjan on 27/12/21.
//

import UIKit
import FSCalendar

class BookingTableViewCell: UITableViewCell{
    
    let paddingFromLeftIs = 20.0
    
    @IBOutlet weak var viewTop:UIView!{
        didSet{
            viewTop.backgroundColor = BUTTON_DARK_APP_COLOR
        }
    }
    
    @IBOutlet weak var lblTop:UILabel!{
        didSet{
            lblTop.textColor = .white
        }
    }
    
    @IBOutlet weak var calendar:FSCalendar!{
        didSet{
            //calendar.delegate = self
            calendar.backgroundColor = .white
        }
    }
    
    
    @IBOutlet weak var viewSelectedDate:UIView!{
        didSet{
            
            viewSelectedDate.backgroundColor = NAVIGATION_COLOR
        }
    }
    
    @IBOutlet weak var lblSelectedDate:UILabel!{
        didSet{
            
            lblSelectedDate.text = "Please select a date"
            lblSelectedDate.textColor = .white
        }
    }
    
    

    @IBOutlet weak var txtTime:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txtTime,
                              tfName: txtTime.text!,
                              tfCornerRadius: 10,
                              tfpadding: paddingFromLeftIs,
                              tfBorderWidth: 0.8,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .systemGray6,
                              tfPlaceholderText: "Select Time")
        }
    }
    
    @IBOutlet weak var btnSelectTime:UIButton!{
        didSet{
            //btnSelectTime.backgroundColor = BUTTON_DARK_APP_COLOR
            //btnSelectTime.tintColor = .white
        }
    }
    
    
    @IBOutlet weak var btnConfirm:UIButton!{
        didSet{
            btnConfirm.backgroundColor = BUTTON_DARK_APP_COLOR
            btnConfirm.tintColor = .white
            btnConfirm.setTitle("Save & Continue", for: .normal)
            btnConfirm.layer.cornerRadius = 10.0
            btnConfirm.clipsToBounds = true
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
