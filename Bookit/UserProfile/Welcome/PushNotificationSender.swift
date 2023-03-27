//
//  PushNotificationSender.swift
//  notification_sound_test
//
//  Created by Apple on 26/04/22.
//

import UIKit

class PushNotificationSender {
    
    func sendPushNotification(to token: String, title: String, body: String) {
        
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["to" : token,
                                           "priority": "high",
                                           "notification" : ["title" : title,
                                                             "body" : body,
                                                             "sound": "call.mp3",
                                                             "badge": 0],
                                           "data" : ["user" : "test_id"]
        ]
        
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAACOvhVF8:APA91bERfJ9FMD4NPclYdVZExb-a-K6hO4dyBOymdtokGCEsj815_vHrhHHD4Wnsw8YCRbNjH8jNphkbrB-X1ZSaTLa6IitZMI-OW0Qx4jYdXU4KeJ3C6aNhwwsxaYE6zegVUzblIH2t", forHTTPHeaderField: "Authorization")
        
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
