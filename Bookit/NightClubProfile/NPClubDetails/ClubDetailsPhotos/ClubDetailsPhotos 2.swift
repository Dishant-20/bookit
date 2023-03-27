//
//  ClubDetailsPhotos.swift
//  Bookit
//
//  Created by Ranjan on 06/01/22.
//

import UIKit

class ClubDetailsPhotos: UIViewController {
    
    // ***************************************************************** // nav
                    
        @IBOutlet weak var navigationBar:UIView! {
            didSet {
                navigationBar.backgroundColor = NAVIGATION_COLOR
                navigationBar.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
                navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                navigationBar.layer.shadowOpacity = 1.0
                navigationBar.layer.shadowRadius = 15.0
                navigationBar.layer.masksToBounds = false
            }
        }
            
       @IBOutlet weak var btnBack:UIButton! {
            didSet {
                btnBack.tintColor = NAVIGATION_BACK_COLOR
            }
        }
            
        @IBOutlet weak var lblNavigationTitle:UILabel! {
            didSet {
                lblNavigationTitle.text = "CLUB DETAIL"
                lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
                lblNavigationTitle.backgroundColor = .clear
            }
        }
                    
    // ***************************************************************** // nav
    
    @IBOutlet weak var collectionView:UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
        
        }
    }

    @IBOutlet weak var btnUploadPic:UIButton! {
        
         didSet {
             btnUploadPic.backgroundColor = NAVIGATION_COLOR
             btnUploadPic.setTitle("UPLOAD MORE PICTURE", for: .normal)
             btnUploadPic.tintColor = .white
             btnUploadPic.layer.cornerRadius = 30.0
             btnUploadPic.clipsToBounds = true
         }
     }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
    }
    

    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK:- COLLECTION VIEW -

extension ClubDetailsPhotos: UICollectionViewDelegate {
    //Write Delegate Code Here
    
}

extension ClubDetailsPhotos: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
            return 30
    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath as IndexPath) as! ClubDetailsPhotoCollectionViewCell
        cell.img.image = UIImage(named: "bar")
            
        return cell
            
        
    }
    
//Write DataSource Code Here:-
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension ClubDetailsPhotos: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
return CGSize(
                width: (view.frame.size.width/3)-3,
                height: (view.frame.size.width/3)-3
            )
        }
        
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
    return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
      
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
            return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
       
        }
    
}
