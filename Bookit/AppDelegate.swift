//
//  AppDelegate.swift
//  Bookit
//
//  Created by Ranjan on 18/12/21.
//

// com.production.bookit
//
import UIKit
import Firebase
import UserNotifications
import AudioToolbox
import Stripe

@main
class AppDelegate: UIResponder, UIApplicationDelegate , UNUserNotificationCenterDelegate , MessagingDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
         Stripe.setDefaultPublishableKey(STRIPE_PROCESS)
        
        // StripeAPI.defaultPublishableKey = "STRIPE_PROCESS"
        
        /*
         'setDefaultPublishableKey' is deprecated: Use StripeAPI.defaultPublishableKey instead. (StripeAPI.defaultPublishableKey = "pk_12345_xyzabc")
         */
        
        UNUserNotificationCenter.current().delegate = self
        
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()

        Messaging.messaging().delegate = self
        // self.fetchDeviceToken()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    
    // MARK:- FIREBASE NOTIFICATION -
    @objc func fetchDeviceToken() {
        
        
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
                // self.fcmRegTokenMessage.text  = "Remote FCM registration token: \(token)"
                
                let defaults = UserDefaults.standard
                defaults.set("\(token)", forKey: "key_my_device_token")
                
                
            }
        }
        
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        print("dishu dishu")
        
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
                // self.fcmRegTokenMessage.text  = "Remote FCM registration token: \(token)"
                
                let defaults = UserDefaults.standard
                defaults.set("\(token)", forKey: "key_my_device_token")
                
                
            }
        }
        
    }
    
    private func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Error = ",error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print(userInfo)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    // MARK:- WHEN APP IS OPEN -
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("User Info dishu = ",notification.request.content.userInfo)
        
        // completionHandler([.banner,.badge, .sound])
        
        let notification_item = notification.request.content.userInfo
        
        if (notification_item["type"] as! String) == "ServiceRequest" {
            
            completionHandler([.badge, .sound])
            self.notification_new_reuest_show_for_club(dictOfNotification: notification.request.content.userInfo as NSDictionary)
            
        }
        
    }
    
    // MARK: - NOTIFICATION ( PANIC ) -
    @objc func notification_new_reuest_show_for_club(dictOfNotification:NSDictionary) {
        print(dictOfNotification as Any)
        
        AudioServicesPlaySystemSound(1521)
        
        let new_booking_title    = "New booking"//(dictOfNotification["title"] as! String)
        let new_booking_message  = (dictOfNotification["message"] as! String)
        
        let alert = NewYorkAlertController(title: new_booking_title, message: new_booking_message, style: .alert)
        
        // alert.addImage(UIImage.gif(name: "successRecharge"))
        // alert.addImage(UIImage(named: "notification_alert"))
        
        let cancel = NewYorkButton(title: "ok", style: .cancel)
        
        alert.addButtons([cancel])
        UIApplication.topMostViewController2?.present(alert, animated: true, completion: nil)
        
    }
    
    
    // MARK:- WHEN APP IS IN BACKGROUND - ( after click popup ) -
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("User Info = ",response.notification.request.content.userInfo)
        
        
    }
    

}


extension UIApplication {
    
    /// The top most view controller
     static var topMostViewController2: UIViewController? {
         return UIApplication.shared.keyWindow?.rootViewController?.visibleViewController2
     }
    
}

extension UIViewController {
    
    /// The visible view controller from a given view controller
    var visibleViewController2: UIViewController? {
        if let navigationController = self as? UINavigationController {
            return navigationController.topViewController?.visibleViewController2
        } else if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.visibleViewController2
        } else if let presentedViewController = presentedViewController {
            return presentedViewController.visibleViewController2
        } else {
            return self
        }
    }
    
}
