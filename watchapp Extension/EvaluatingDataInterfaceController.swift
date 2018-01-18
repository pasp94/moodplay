//
//  EvaluatingDataInterfaceController.swift
//  watchapp Extension
//
//  Created by Pasquale on 17/01/18.
//  Copyright © 2018 Pasquale Spisto. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class EvaluatingDataInterfaceController: WKInterfaceController, WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("session")
    }
    
    var toSend = ""
    
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let mood = message["recognizedMood"] as? [String]{
            print(mood)
            pushController(withName: "FinalRecognition", context: mood )
        }
        
        
    }
    var wcSession: WCSession!
    
    @IBOutlet var cardioIconEval: WKInterfaceImage!
    
    @IBOutlet var calendarIconEval: WKInterfaceImage!
    @IBOutlet var weatherIconEval: WKInterfaceImage!
    @objc func showCardioIcon(){
        cardioIconEval.setHidden(false)
    }
    
    @objc func showCalendarIcon(){
        calendarIconEval.setHidden(false)
    }
    
    @objc func showWeatherIcon(){
        weatherIconEval.setHidden(false)
        
    }
    
    @objc func showNextVC(){
        //pushController(withName: "FinalRecognition", context: nil)
        
    }

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        wcSession = WCSession.default
        wcSession.delegate = self
       // wcSession.activate()
        
        wcSession.sendMessage(["ore": context as! Int], replyHandler: nil, errorHandler: nil)
      
        cardioIconEval.setHidden(true)
        calendarIconEval.setHidden(true)
        weatherIconEval.setHidden(true)
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(showCardioIcon), userInfo: nil, repeats: false)
        
        //Calendar Appearing
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(showCalendarIcon), userInfo: nil, repeats: false)
        
        //Weather Appearing
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(showWeatherIcon), userInfo: nil, repeats: false)
        // Configure interface objects here.
        //Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(showNextVC), userInfo: nil, repeats: false)
        
  
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
