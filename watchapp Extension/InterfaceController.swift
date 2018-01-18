//
//  InterfaceController.swift
//  watchapp Extension
//
//  Created by Pasquale on 17/01/18.
//  Copyright © 2018 Pasquale Spisto. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet var mood: WKInterfaceImage!
    
    @IBOutlet var btn: WKInterfaceButton!
    @IBOutlet var time: WKInterfaceLabel!
    var wcSession:WCSession!
    
    //let images: [String: UIImage] = ["default": #imageLiteral(resourceName: "default_icon"), "sad": #imageLiteral(resourceName: "sad_icon"),"motivated": #imageLiteral(resourceName: "motivated_icon"), "happy": #imageLiteral(resourceName: "happy_icon")]
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Watch session started")
        wcSession.sendMessage(["requestMood": "dammi il mood"], replyHandler: nil, errorHandler: nil)
        
    }
    
    
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let recognizedMood = message["moodResponse"] as? [String]{
            mood.setImageNamed(recognizedMood[0]+"_icon")
            time.setText(recognizedMood[1])
                mood.setHidden(false)
                btn.setHidden(false)
                time.setHidden(false)
            }
        }
        
        override func awake(withContext context: Any?) {
            
            super.awake(withContext: context)
            mood.setHidden(true)
            btn.setHidden(true)
            time.setHidden(true)
            wcSession = WCSession.default
            wcSession.delegate = self
            wcSession.activate()
            
            // Configure interface objects here.
        }
        
        
        override func willActivate() {
            // This method is called when watch view controller is about to be visible to user
            super.willActivate()
            wcSession.delegate = self
            print("manda")
            if wcSession.isReachable{
                wcSession.sendMessage(["requestMood": "dammi il mood"], replyHandler: nil, errorHandler: nil)
            }
            
            
        }
        
        override func didDeactivate() {
            // This method is called when watch view controller is no longer visible
            super.didDeactivate()
            mood.setHidden(true)
            btn.setHidden(true)
            time.setHidden(true)
        }
        
}

