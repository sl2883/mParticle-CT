//
//  AppDelegate.swift
//  mParticle
//
//  Created by Sunny Ladkani on 6/9/22.
//

import UIKit
import mParticle_Apple_SDK
import CleverTapSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //initialize mParticle
        
            let options = MParticleOptions(key: "us2-a38cf3f0faab0645946a3e962c6b57a3",
                                                 secret: "z1_88POaW8Xdz3eVp-lWryMzMgb06EQS8egpZhIyS0-_UeE_eiB3eu-7rvk-_cz2")
            options.environment = .development
            options.logLevel = MPILogLevel.verbose
        
            let identityRequest = MPIdentityApiRequest.withEmptyUser()
            identityRequest.email = "foo6@examplemparticle1.com"
            identityRequest.customerId = "foo6"
        
            options.identifyRequest = identityRequest
            options.onIdentifyComplete =  {(result: MPIdentityApiResult?, error: Error?) in
                if (result?.user != nil) {
                    result?.user.setUserAttribute("key1", value: "value1")
                    result?.user.setUserAttribute("key2", value: "value2")
                } else {
                    //handle failure - see below
                }
            }
            
            MParticle.sharedInstance().start(with: options)
        
        registerForPush();
                
        
        return true
    }
    
    func registerForPush() {
            // Register for Push notifications
            UNUserNotificationCenter.current().delegate = self
            // request Permissions
            UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .badge, .alert], completionHandler: {granted, error in
                if granted {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            })
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
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                    didReceive response: UNNotificationResponse,
                                    withCompletionHandler completionHandler: @escaping () -> Void) {

            NSLog("%@: did receive notification response: %@", self.description, response.notification.request.content.userInfo)
            completionHandler()
        }

        func userNotificationCenter(_ center: UNUserNotificationCenter,
                                    willPresent notification: UNNotification,
                                    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

            NSLog("%@: will present notification: %@", self.description, notification.request.content.userInfo)
            completionHandler([.badge, .sound, .alert])
        }
//
//        func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//            NSLog("%@: registered for remote notifications: %@", self.description, deviceToken.description)
//            //CleverTap.sharedInstance()?.setPushToken(deviceToken)
//        }


}

