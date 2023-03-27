//
//  notification_class.swift
//  Bookit
//
//  Created by Apple on 12/05/22.
//

import UIKit

class notification_class {

    func sendPushNotification(to token: String, title: String, body: String) {
        
            let urlString = "https://fcm.googleapis.com/fcm/send"
            let url = NSURL(string: urlString)!
            let paramString: [String : Any] = ["to" : token,
                                               "notification" :
                                                ["title" : title,
                                                 "body" : body],
                                               "data" :
                                                ["user" : "test_id"]
            ]
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("key=AAAAjf6PKZg:APA91bHC4aahcYBqjZBF20VorsL0N9D-saAgweSfDVXrmtDiHd0SMtJjzrtMSAtwYfWpgMFtLKr8y3P_XV3QrauqGo_i4if8dQOE9M53ds2SN1YQ48qrqtUpWLXmtBJgdhBiymAL3SAy", forHTTPHeaderField: "Authorization")
            let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
                do {
                    if let jsonData = data {
                        if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                            NSLog("Received data:\n\(jsonDataDict))")
                        }
                    }
                } catch let err as NSError {
                    print(err.debugDescription)
                }
            }
            task.resume()
        }

}
