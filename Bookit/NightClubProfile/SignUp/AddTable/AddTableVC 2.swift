//
//  AddTableVC.swift
//  Bookit
//
//  Created by Ranjan on 21/12/21.
//

import UIKit
import Alamofire
import SDWebImage

class AddTableVC: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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
                
                lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
                lblNavigationTitle.backgroundColor = .clear
                
                if btnEditTappedStr == "EditBtnTapped"{
                    
                    lblNavigationTitle.text = "EDIT TABLE"
                }
                else{
                    
                lblNavigationTitle.text = "ADD TABLE"
                    
                }
            }
        }
                    
    // ***************************************************************** // nav
   
    @IBOutlet weak var tablView:UITableView!{
        didSet {
            tablView.delegate = self
            tablView.dataSource = self
            tablView.backgroundColor =  APP_BASIC_COLOR
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = APP_BASIC_COLOR
        self.navigationController?.isNavigationBarHidden = true
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func callBeforeAddTable(){
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        
        let cell = self.tablView.cellForRow(at: indexPath) as! AddTableTableViewCell
        
        if String(cell.txtTableNumber.text!) == "" {
            self.fieldShoulNotBeEmptyPopup(strTitle: "Table Name/Number")
        } else if String(cell.txtTotaaSeat.text!) == "" {
            self.fieldShoulNotBeEmptyPopup(strTitle: "Total Seat")
        } else if String(cell.txtPrice.text!) == "" {
            self.fieldShoulNotBeEmptyPopup(strTitle: "Price")
        }
        
        else {
            AddTableWithImageWebService()
        }
        
    }
    
    @objc func fieldShoulNotBeEmptyPopup(strTitle:String) {
        
        let alert = UIAlertController(title: "Alert", message: String(strTitle)+" Field should not be empty", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true)
        
    }
    
    @objc func btnContinueTapped(){
        
        if btnEditTappedStr == "EditBtnTapped"{
            
            EditTableWithImageWebService()
        }
        
        else{
            
        callBeforeAddTable()
        
        }
    }

    
    @objc func btnAddMoreTableTapped(){
        
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddTableVC") as? AddTableVC
            self.navigationController?.pushViewController(settingsVCId!, animated: false)
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
           
           let cell = self.tablView.cellForRow(at: indexPath) as! AddTableTableViewCell
           
           let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
           cell.imgUpload.image = image
           self.dismiss(animated: true, completion: nil)
        
        //image data
        
        cell.imgUpload.isHidden = false
        let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        cell.imgUpload.image = image_data // show image on profile
        let imageData:Data = image_data!.pngData()!
        imageStr1 = imageData.base64EncodedString()
        self.dismiss(animated: true, completion: nil)
        imgData1 = image_data!.jpegData(compressionQuality: 0.2)!
        
       }
    
    @objc func EditTableWithImageWebService(){
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        
        let cell = self.tablView.cellForRow(at: indexPath) as! AddTableTableViewCell
        
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

            //Set Your Parameter
                let parameterDict = NSMutableDictionary()
                parameterDict.setValue("edittable", forKey: "action")
                parameterDict.setValue(myString, forKey: "userId")
                parameterDict.setValue(String(cell.txtTableNumber.text!), forKey: "name")
                parameterDict.setValue(String(cell.txtTotaaSeat.text!), forKey: "totalSeat")
                parameterDict.setValue(String(cell.txtPrice.text!), forKey: "seatPrice")
                parameterDict.setValue(String(clubTableId), forKey: "clubTableId")
    //  parameterDict.setValue(clubName, forKey: "name")

            

    //Set Image Data
    let imgData = cell.imgUpload.image!.jpegData(compressionQuality: 0.5)!

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
                        multiPart.append(imgData, withName: "image", fileName: "file.png", mimeType: "image/png")
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
                                        
                                        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NPManageTable") as? NPManageTable
                                    self.navigationController?.pushViewController(settingsVCId!, animated: false)
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
    
    
    @objc func AddTableWithImageWebService(){
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        
        let cell = self.tablView.cellForRow(at: indexPath) as! AddTableTableViewCell
        
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

            //Set Your Parameter
                let parameterDict = NSMutableDictionary()
                parameterDict.setValue("addtable", forKey: "action")
                parameterDict.setValue(myString, forKey: "userId")
                parameterDict.setValue(String(cell.txtTableNumber.text!), forKey: "name")
                parameterDict.setValue(String(cell.txtTotaaSeat.text!), forKey: "totalSeat")
                parameterDict.setValue(String(cell.txtPrice.text!), forKey: "seatPrice")
    //  parameterDict.setValue(clubName, forKey: "name")
            

    //Set Image Data
    let imgData = cell.imgUpload.image!.jpegData(compressionQuality: 0.5)!

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
                        multiPart.append(imgData, withName: "image", fileName: "file.png", mimeType: "image/png")
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
                                        
                                        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NPManageTable") as? NPManageTable
                                        self.navigationController?.pushViewController(settingsVCId!, animated: false)
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


//MARK:- TABLE VIEW -
extension AddTableVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:AddTableTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AddTableCell") as! AddTableTableViewCell
        
        cell.backgroundColor = APP_BASIC_COLOR
      
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        
        cell.txtUploadPic.isEnabled = false
        
        
//        var clubTableId:String!
//        var clubTableImg:String!
//        var tableName:String!
//        var seatPrice:String!
//        var clubAddress:String!
//        var clubUserName:String!
//        var tableTotalSeat:String!
        
        cell.btnSave.addTarget(self, action: #selector(btnContinueTapped), for: .touchUpInside)
        
        cell.btnUploadImg.addTarget(self, action: #selector(openGallery), for: .touchUpInside)
        cell.btnAddTable.addTarget(self, action: #selector(btnAddMoreTableTapped), for: .touchUpInside)
        
        cell.btnUploadImg.addTarget(self, action: #selector(openGallery), for: .touchUpInside)
        
        if btnEditTappedStr == "EditBtnTapped"{
            
            cell.txtPrice.text = seatPrice
            cell.txtTableNumber.text = tableName
            cell.txtTotaaSeat.text = tableTotalSeat
            
            cell.btnSave.setTitle("EDIT & CONTINUE", for: .normal)
            cell.btnAddTable.isHidden = true
            cell.btnSkip.isHidden = true
        
        }
        
        return cell
    }

    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 800
    }
    
    
}

extension AddTableVC: UITableViewDelegate {
    
}
