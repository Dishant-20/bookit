//
//  ClubDetailsPhotos.swift
//  Bookit
//
//  Created by Ranjan on 06/01/22.
//

import UIKit
import Alamofire
import SDWebImage

import OpalImagePicker
import BSImagePicker
import Photos

class ClubDetailsPhotos: UIViewController , OpalImagePickerControllerDelegate , UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var dict_get_table_Details:NSDictionary!
    
    var arr_mut_list_of_all_photos:NSMutableArray! = []
    
    var img_data : Data!
    var img_Str : String!
    
    var arrImages : NSMutableArray! = []
    
    var arrImagesThumbnail : NSMutableArray! = []
    var data:Data!
    var arrTest : NSMutableArray! = []
    
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
                lblNavigationTitle.text = "Gallery"
                lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
                lblNavigationTitle.backgroundColor = .clear
            }
        }
                    
    // ***************************************************************** // nav
    
    @IBOutlet weak var collectionView:UICollectionView!{
        didSet{
            // collectionView.delegate = self
            // collectionView.dataSource = self
        
        }
    }

    var str_club_id:String!
    
    @IBOutlet weak var btnUploadPic:UIButton! {
         didSet {
             btnUploadPic.backgroundColor = NAVIGATION_COLOR
             // btnUploadPic.setTitle("Add", for: .normal)
             btnUploadPic.tintColor = .white
             // btnUploadPic.layer.cornerRadius = 30.0
             // btnUploadPic.clipsToBounds = true
             
             btnUploadPic.tintColor = .black
             btnUploadPic.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
             btnUploadPic.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
             btnUploadPic.layer.shadowOpacity = 1.0
             btnUploadPic.layer.shadowRadius = 15.0
             btnUploadPic.layer.masksToBounds = false
             btnUploadPic.layer.cornerRadius = 30
             btnUploadPic.backgroundColor = .white
         }
     }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        // print(self.dict_get_table_Details as Any)
        
        self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        self.btnUploadPic.addTarget(self, action: #selector(open_camera_gallery), for: .touchUpInside)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
       
            if (person["role"] as! String) == "Customer" {
                // self.dict_get_table_Details
                
                self.str_club_id = "\(self.dict_get_table_Details["userId"]!)"
                
                self.btnUploadPic.isHidden = true
            } else {
                
                self.str_club_id = "\(person["userId"]!)"
                self.btnUploadPic.isHidden = false
            }
            
        } else {
            // guest
            self.str_club_id = "\(self.dict_get_table_Details["userId"]!)"
            
            self.btnUploadPic.isHidden = true
        }
        
        self.show_image_wb(str_show_indicator: "yes")
        
    }
    

    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func show_image_wb(str_show_indicator:String) {
       
        self.view.endEditing(true)
        
        self.arr_mut_list_of_all_photos.removeAllObjects()
        
        if str_show_indicator == "yes" {
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        }
        
        
        // if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // print(person as Any)
            
            // let x : Int = person["userId"] as! Int
            // let myString = String(x)
            
            let params = show_club_images(action: "tablephotolist",
                                          userId: String(self.str_club_id),
                                          pageNo: "")
            
            print(params as Any)
            
            AF.request(APPLICATION_BASE_URL,
                       method: .post,
                       parameters: params,
                       encoder: JSONParameterEncoder.default).responseJSON { response in
                // debugPrint(response.result)
                
                switch response.result {
                case let .success(value):
                    
                    let JSON = value as! NSDictionary
                    print(JSON as Any)
                    
                    var strSuccess : String!
                    strSuccess = (JSON["status"]as Any as? String)?.lowercased()
                    print(strSuccess as Any)
                    if strSuccess == String("success") {
                        print("yes")
                        
                        ERProgressHud.sharedInstance.hide()
                        
                        var ar : NSArray!
                        ar = (JSON["data"] as! Array<Any>) as NSArray
                        
                        if ar.count != 0 {
                            
                            
                            
                            self.arr_mut_list_of_all_photos.addObjects(from: ar as! [Any])
                            self.collectionView.delegate = self
                            self.collectionView.dataSource = self
                            self.collectionView.reloadData()
                            
                        }
                        
                        // self.customer_dashboard_wb()
                        
                    } else {
                        print("no")
                        ERProgressHud.sharedInstance.hide()
                        
                        var strSuccess2 : String!
                        strSuccess2 = JSON["msg"]as Any as? String
                        
                        if strSuccess2 == "Your Account is Inactive. Please contact admin.!!" ||
                            strSuccess2 == "Your Account is Inactive. Please contact admin.!" ||
                            strSuccess2 == "Your Account is Inactive. Please contact admin." {
                            
                            
                        } else {
                            
                            let alert = UIAlertController(title: String(strSuccess).uppercased(), message: String(strSuccess2), preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                            
                            self.present(alert, animated: true)
                            
                        }
                    }
                    
                case let .failure(error):
                    print(error)
                    ERProgressHud.sharedInstance.hide()
                    
                    // Utils.showAlert(alerttitle: SERVER_ISSUE_TITLE, alertmessage: SERVER_ISSUE_MESSAGE, ButtonTitle: "Ok", viewController: self)
                }
            // }
        }
    }
    
    
    
    
    // MARK: - OPEN CAMERA OR GALLERY -
    @objc func open_camera_gallery() {
        
        let actionSheet = NewYorkAlertController(title: "Upload pics", message: nil, style: .actionSheet)
        
        actionSheet.addImage(UIImage(named: "camera"))
        
        let cameraa = NewYorkButton(title: "Camera", style: .default) { _ in
            // print("camera clicked done")
            
            self.open_camera_or_gallery(str_type: "c")
        }
        
        let gallery = NewYorkButton(title: "Gallery", style: .default) { _ in
            // print("camera clicked done")
            
            self.open_camera_or_gallery(str_type: "g")
        }
        
        let cancel = NewYorkButton(title: "Cancel", style: .cancel)
        
        actionSheet.addButtons([cameraa, gallery, cancel])
        
        self.present(actionSheet, animated: true)
        
    }
    
    // MARK: - OPEN CAMERA or GALLERY -
    @objc func open_camera_or_gallery(str_type:String) {
        
        /*let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if str_type == "c" {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)*/
        
        let imagePicker = OpalImagePickerController()
        imagePicker.imagePickerDelegate = self
        imagePicker.maximumSelectionsAllowed = 5
        imagePicker.allowedMediaTypes = Set([PHAssetMediaType.image])
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerDidCancel(_ picker: OpalImagePickerController) {
        //Cancel action?
    }
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingAssets assets: [PHAsset]) {
        
        print("Selected: \(assets)")
        
        // self.imgProfile.image = self.getAssetThumbnail(asset: assets[0])
        
        print(assets.count)
        
        self.arrImagesThumbnail.add(self.getAssetThumbnail(asset: assets[0]))
        
        // for uiimage view
        // self.imgFeed.image = self.getAssetThumbnail(asset: assets[0])
        
        // for button
        // self.imgFeed.setImage(self.getAssetThumbnail(asset: assets[0]), for: .normal)
        
        self.arrTest.removeAllObjects()
        
        for i in 0..<assets.count {
            self.arrImages.add(self.getAssetThumbnail(asset: assets[i]))
            
            let image = self.getAssetThumbnail(asset: assets[i])
            self.data = image.jpegData(compressionQuality: 1.0)
            
            self.arrTest.add(self.data as Any) // show on collection
        }
        
        // print(self.arrTest as Any)
        print(self.arrTest.count)
        
        //Dismiss Controller
        self.presentedViewController?.dismiss(animated: true, completion: nil)
        
         self.upload_selected_photos_to_server()
    }
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 500, height: 500), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    
    @objc func upload_selected_photos_to_server() {
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            print(person as Any)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
            
            //Set Your URL
            let api_url = APPLICATION_BASE_URL
            guard let url = URL(string: api_url) else {
                return
            }
            
            // let x : Int = self.dict_fetch_album_holder_data["albumId"] as! Int
            // let myString = String(x)
            
            var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
            urlRequest.httpMethod = "POST"
            
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            urlRequest.addValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
            
            //Set Your Parameter
            
            let parameterDict = NSMutableDictionary()
            
            parameterDict.setValue("addmultiimage", forKey: "action")
            parameterDict.setValue(String(myString), forKey: "userId")
            // parameterDict.setValue(String("26"), forKey: "clubTableId")
            // parameterDict.setValue(String(self.str_get_album_id), forKey: "albumId")
            
            print(parameterDict as Any)
            
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
                
                // "multiImage[0]"
                
                // print(self.arrTest as Any)
                // print(self.arrTest.count as Any)
                
                for i in 0..<self.arrTest.count {
                    print("\("multiImage")"+"\([i])")
                    
                    let image : UIImage = UIImage(data: self.arrTest![i] as! Data)!
                    
                    multiPart.append((image ).jpegData(compressionQuality: 0.5)!, withName: "\("multiImage")"+"\([i])", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/png")
                    
                }
                
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
                            
                            self.arrTest.removeAllObjects()
                            
                            // ERProgressHud.sharedInstance.hide()
                            
                            self.show_image_wb(str_show_indicator: "no")
                            
                            /*var strSuccess2 : String!
                            strSuccess2 = dictionary["msg"]as Any as? String
                            
                            let alert = NewYorkAlertController(title: "Success", message: String(strSuccess2), style: .alert)
                            
                            alert.addImage(UIImage.gif(name: "success3"))
                            
                            let cancel = NewYorkButton(title: "Ok", style: .cancel) {
                                _ in
                                
                            }
                            alert.addButtons([cancel])
                            
                            self.present(alert, animated: true)*/
                            
                        }
                        catch {
                            // catch error.
                            print("catch error")
                            ERProgressHud.sharedInstance.hide()
                        }
                        break
                        
                    case .failure(_):
                        print("failure")
                        ERProgressHud.sharedInstance.hide()
                        
                        if let err = data.response {
                            print(err)
                            return
                        }
                        
                        break
                        
                    }
                })
        }
    }
    
}

//MARK:- COLLECTION VIEW -

extension ClubDetailsPhotos: UICollectionViewDataSource , UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return self.arr_mut_list_of_all_photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath as IndexPath) as! ClubDetailsPhotoCollectionViewCell
        
        let item = self.arr_mut_list_of_all_photos[indexPath.row] as? [String:Any]
        print(item as Any)
        
        cell.backgroundColor = .clear
        
        // cell.img.image = UIImage(named: "bar")
            
        cell.layer.cornerRadius = 8
        cell.layer.borderWidth = 0.8
        
        cell.img.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.img.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "logo"))
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            print(person as Any)
        
            if (person["role"] as! String) == "Club" {
                
                cell.btn_delete.isHidden = false
                cell.btn_delete.tag = indexPath.row
                cell.btn_delete.addTarget(self, action: #selector(delete_click_method), for: .touchUpInside)
                
            } else {
            
                cell.btn_delete.isHidden = true
                
                
            }
            
        } else {
            
            // guest login
            cell.btn_delete.isHidden = true
            
        }
        
        
        return cell
            
        
    }
    
    @objc func delete_click_method(_ sender:UIButton) {
        let btn:UIButton = sender
        
        let item = self.arr_mut_list_of_all_photos[btn.tag] as? [String:Any]
        
        let alert = NewYorkAlertController(title: "Delete", message: String("Are you sure you want to delete ?"), style: .alert)
        
        alert.addImage(UIImage.gif(name: "gif_bin"))
        
        let yes_logout = NewYorkButton(title: "yes, delete", style: .destructive) {
            _ in
            
            self.delete_photo(str_photo_id: "\(item!["tablephotoId"]!)" )
        }

        
        let cancel = NewYorkButton(title: "dismiss", style: .cancel)
        alert.addButtons([cancel,yes_logout])
        
        self.present(alert, animated: true)
        
    }
    
    @objc func delete_photo(str_photo_id:String) {
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        // self.arr_mut_dashboard_Data.removeAllObjects()
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            print(person as Any)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params = delete_club_photo(action: "deleteclubphoto",
                                           userId: String(myString),
                                           tablephotoId: String(str_photo_id))
            
            print(params as Any)
            
            AF.request(APPLICATION_BASE_URL,
                       method: .post,
                       parameters: params,
                       encoder: JSONParameterEncoder.default).responseJSON { response in
                // debugPrint(response.result)
                
                switch response.result {
                case let .success(value):
                    
                    let JSON = value as! NSDictionary
                    print(JSON as Any)
                    
                    var strSuccess : String!
                    strSuccess = (JSON["status"]as Any as? String)?.lowercased()
                    print(strSuccess as Any)
                    if strSuccess == String("success") {
                        print("yes")
                        
                        self.show_image_wb(str_show_indicator: "no")
                        
                    } else {
                        print("no")
                        ERProgressHud.sharedInstance.hide()
                        
                        var strSuccess2 : String!
                        strSuccess2 = JSON["msg"]as Any as? String
                        
                        if strSuccess2 == "Your Account is Inactive. Please contact admin.!!" ||
                            strSuccess2 == "Your Account is Inactive. Please contact admin.!" ||
                            strSuccess2 == "Your Account is Inactive. Please contact admin." {
                            
                            
                        } else {
                            
                            let alert = UIAlertController(title: String(strSuccess).uppercased(), message: String(strSuccess2), preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                            
                            self.present(alert, animated: true)
                            
                        }
                    }
                    
                case let .failure(error):
                    print(error)
                    ERProgressHud.sharedInstance.hide()
                    
                    // Utils.showAlert(alerttitle: SERVER_ISSUE_TITLE, alertmessage: SERVER_ISSUE_MESSAGE, ButtonTitle: "Ok", viewController: self)
                }
            }
        }
    }
//Write DataSource Code Here:-
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // let array: [String] = self.arr_mut_list_of_all_photos.copy() as! [String]
        
        let vc = ImagePreviewVC()
        vc.PhotoArray = self.arr_mut_list_of_all_photos
        vc.passedContentOffset = indexPath
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
}

extension ClubDetailsPhotos: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
return CGSize(
                // width: (view.frame.size.width/2),
                // height: (view.frame.size.width/2)
    
     width: 180,
     height: 180
    
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
        
      
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
            return UIEdgeInsets(top: 10, left: 10, bottom: 8, right: 10)
       
        }
    
}
