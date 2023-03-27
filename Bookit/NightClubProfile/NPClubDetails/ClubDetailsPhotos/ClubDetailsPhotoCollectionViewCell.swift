//
//  ClubDetailsPhotoCollectionViewCell.swift
//  Bookit
//
//  Created by Ranjan on 06/01/22.
//

import UIKit

class ClubDetailsPhotoCollectionViewCell: UICollectionViewCell {
    
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
