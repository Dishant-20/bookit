//
//  NPClubPhotosVC.swift
//  Bookit
//
//  Created by Ranjan on 23/12/21.
//

import UIKit
import Alamofire
import SDWebImage

class NPClubPhotosVC: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var pickedImage = false
    
    var imgData1 : Data!
    var imageStr1 : String!
    
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
    
    @IBOutlet weak var btnUploadImages:UIButton! {
         didSet {
             btnUploadImages.tintColor = NAVIGATION_BACK_COLOR
             btnUploadImages.setTitle("UPLOAD MORE PICTURES", for: .normal)
             btnUploadImages.addTarget(self, action: #selector(btnUploadImagesTapped), for: .touchUpInside)
             btnUploadImages.layer.cornerRadius = 35.0
             btnUploadImages.clipsToBounds = true
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
    
    
    
    @objc func btnUploadImagesTapped(){
        
        UploadImageWebService()
        
    }
    
    //MARK:- Open Gallery Method
    
    @objc func openGallery(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) && !pickedImage {
            
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
                pickedImage = true
            
                }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           self.dismiss(animated: true, completion: nil)
       }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
           
           let indexPath = IndexPath.init(row: 0, section: 0)
           
        let cell = self.collectionView(collectionView, cellForItemAt: indexPath) as! NPClubPhotsCollectionViewCell
           
           let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
           cell.img.image = image
           self.dismiss(animated: true, completion: nil)
        
        //image data
        
        cell.img.isHidden = false
        let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        cell.img.image = image_data // show image on profile
        let imageData:Data = image_data!.pngData()!
        imageStr1 = imageData.base64EncodedString()
        self.dismiss(animated: true, completion: nil)
        imgData1 = image_data!.jpegData(compressionQuality: 0.2)!
        
       }
    
    @objc func UploadImageWebService(){
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        
     let cell = self.collectionView(collectionView, cellForItemAt: indexPath) as! NPClubPhotsCollectionViewCell
        
        //Set Your URL
            let api_url = APPLICATION_BASE_URL
            guard let url = URL(string: api_url) else {
                return
            }

            var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
                
                let x : Int = person["userId"] as! Int
                let myString = String(x)
                let clubName = person["fullName"] as! String
            
//        action: addmultiimage
//        userId:
//        clubTableId:
//        multiImage:

            //Set Your Parameter
                let parameterDict = NSMutableDictionary()
                parameterDict.setValue("addmultiimage", forKey: "action")
                parameterDict.setValue(myString, forKey: "userId")
                parameterDict.setValue("", forKey: "clubTableId")
    //  parameterDict.setValue(clubName, forKey: "name")

            

    //Set Image Data
    let imgData = cell.img
                .image!.jpegData(compressionQuality: 0.5)!

    // Now Execute
            
    AF.upload(multipartFormData: { multiPart in
        for (key, value) in parameterDict {
            if let temp = value as? String {
                    multiPart.append(temp.data(using: .utf8)!, withName: key as! String)
                    }
            if let temp = value as? Int {
                
                multiPart.append("\(temp)".data(using: .utf8)!, withName: key as! String)
                
                            }
                            if let temp = value as? NSArray {
                                temp.forEach({ element in
                                    let keyObj = key as! String + "[]"
                                    if let string = element as? String {
                                        multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                                    } else
                                        if let num = element as? Int {
                                            let value = "\(num)"
                                            multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                                    }
                                })
                            }
                        }
                        multiPart.append(imgData, withName: "multiImage", fileName: "file.png", mimeType: "image/png")
                    }, with: urlRequest)
                        .uploadProgress(queue: .main, closure: { progress in
                            //Current upload progress of file
                            print("Upload Progress: \(progress.fractionCompleted)")
                        })
                        .responseJSON(completionHandler: { data in

                                   switch data.result {

                                   case .success(_):
                                    do {
                                    
                                    let dictionary = try JSONSerialization.jsonObject(with: data.data!, options: .fragmentsAllowed) as! NSDictionary
                                      
                                        print("Success!")
                                        
                                        print(dictionary)
                                        
//                                        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NPManageTable") as? NPManageTable
//                                    self.navigationController?.pushViewController(settingsVCId!, animated: false)
                                   }
                                   catch {
                                      // catch error.
                                    print("catch error")

                                          }
                                    break
                                        
                                   case .failure(_):
                                    print("failure")

                                    break
                                    
                                }


                        })
                    
           }
         
        }
    
}


//MARK:- COLLECTION VIEW -

extension NPClubPhotosVC: UICollectionViewDelegate {
    //Write Delegate Code Here
    
}

extension NPClubPhotosVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
            return 30
    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NPClubPhotsCollectionCell", for: indexPath as IndexPath) as! NPClubPhotsCollectionViewCell
        //cell.img.image = UIImage(named: "bar")
            
        return cell
            
        
    }
    
//Write DataSource Code Here:-
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension NPClubPhotosVC: UICollectionViewDelegateFlowLayout {
    
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
