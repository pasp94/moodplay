        //
//  AppDelegate.swift
//  moodplay
//
//  Created by Pasquale Spisto on 11/12/2017.
//  Copyright © 2017 Pasquale Spisto. All rights reserved.
//

import UIKit
import WatchConnectivity

@UIApplicationMain
        class AppDelegate: UIResponder, UIApplicationDelegate,WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("session AppDelegate")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("session Inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("session deactivate")
    }
    
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
        if let requestMood = message["requestMood"]{
            
            session.sendMessage(["moodResponse":Recognizer.shared.recognizedMood], replyHandler: nil, errorHandler: nil)
        }
        
        if let ore = message["ore"]
        {
            print("ore = ",ore)
            Recognizer.shared.workHR = ore as! Int
            
            //Calculate bpm
            Recognizer.shared.bpmRate = Int(arc4random_uniform(120) + 40)
            
            Recognizer.shared.recognizeMood()
            
            let sadMoodPercentage = String("\(Recognizer.shared.sadPercentage)%")
            let happyMoodPercentage = String("\(Recognizer.shared.happyPercentage)%")
            let motivatedMoodPercentage = String("\(Recognizer.shared.motivatedPercentage)%")
            
            let moodRecognized = Recognizer.shared.retriverDominantMood()
            Recognizer.shared.recognizedMood = moodRecognized.name.lowercased()
            let r = String(moodRecognized.color.r)
            let g = String(moodRecognized.color.g)
            let b = String(moodRecognized.color.b)
            
            let message = ["recognizedMood": [sadMoodPercentage, happyMoodPercentage, motivatedMoodPercentage,  moodRecognized.name.uppercased(), r, g, b]]
            
            sleep(2)
            
            session.sendMessage(message, replyHandler: nil, errorHandler: {
                (error) in
                print(error.localizedDescription)
            })
        }
       
        
    }
    
    var window: UIWindow?
    
    var wcSession: WCSession!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if (UserDefaults.standard.value(forKey: "hasConfigurated") != nil){
            self.window = UIWindow(frame: UIScreen.main.bounds)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "Main")
            
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
            
        }else{
            self.window = UIWindow(frame: UIScreen.main.bounds)
            
            let storyboard = UIStoryboard(name: "Configuration", bundle: nil)
            
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "conf")
            
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }
        
        // Override point for customization after application launch.
        UINavigationBar.appearance().barTintColor = UIColor.black
        UINavigationBar.appearance().tintColor = UIColor.orange
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        UITabBar.appearance().barTintColor = UIColor.black
        UITabBar.appearance().tintColor = UIColor.orange
        
        wcSession = WCSession.default
        wcSession.delegate = self
        wcSession.activate()
        
        
        
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

