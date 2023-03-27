//
//  NPClubPhotsCollectionViewCell.swift
//  Bookit
//
//  Created by Ranjan on 23/12/21.
//

import UIKit

class NPClubPhotsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var viw:UIView!{
        didSet{
            viw.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var img:UIImageView!{
        didSet{
            
            img.layer.cornerRadius = 10.0
            img.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var btn_delete:UIButton! {
        didSet {
            btn_delete.layer.cornerRadius = 15
            btn_delete.clipsToBounds = true
            btn_delete.backgroundColor = .systemRed
            btn_delete.tintColor = .white
        }
    }
    
}
