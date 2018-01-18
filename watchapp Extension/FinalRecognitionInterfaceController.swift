//
//  FinalRecognitionInterfaceController.swift
//  watchapp Extension
//
//  Created by Pasquale on 17/01/18.
//  Copyright © 2018 Pasquale Spisto. All rights reserved.
//

import WatchKit
import Foundation


class FinalRecognitionInterfaceController: WKInterfaceController {

    @IBOutlet var mood: WKInterfaceLabel!
    @IBOutlet var p1: WKInterfaceLabel!
    @IBOutlet var p2: WKInterfaceLabel!
    @IBOutlet var p3: WKInterfaceLabel!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
        let message = context as! [String]
        p1.setText(message[0])
        p2.setText(message[1])
        p3.setText(message[2])
        mood.setText(message[3])
        mood.setTextColor(UIColor(red: CGFloat(Float(message[4])!), green: CGFloat(Float(message[5])!), blue: CGFloat(Float(message[6])!), alpha: 1.0))
        
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
