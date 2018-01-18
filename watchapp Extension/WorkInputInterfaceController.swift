//
//  WorkInputInterfaceController.swift
//  watchapp Extension
//
//  Created by Pasquale on 17/01/18.
//  Copyright © 2018 Pasquale Spisto. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class WorkInputInterfaceController: WKInterfaceController,WCSessionDelegate{
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("entrato  nella sessione estiva")
    }
    

    
    @IBOutlet var workHoursPicker: WKInterfacePicker!
    
    var wcSession: WCSession!
    
    var elementi: [WKPickerItem]!
    var selectedWorkHours = 0
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        wcSession = WCSession.default
        wcSession.delegate = self
        //wcSession.activate()
        
        var counter = 0
        
        
        let a = WKPickerItem()
        let b = WKPickerItem()
        let c = WKPickerItem()
        let d = WKPickerItem()
        let e = WKPickerItem()
        let f = WKPickerItem()
        let g = WKPickerItem()
        let h = WKPickerItem()
        let i = WKPickerItem()
        let j = WKPickerItem()
        let k = WKPickerItem()
        let l = WKPickerItem()
        let m = WKPickerItem()
        let n = WKPickerItem()
        
        elementi = [a, b, c, d, e, f, g, h, i, j, k, l, m, n]
        
        for elem in elementi{
            counter = counter + 1
            elem.caption = "Item \(counter)"
            elem.title = "\(counter - 1)"
            
        }
//        for i in [0 ... 13]{
//            elementi[i].caption = "Item 1"
//        }
//        for elem in elementi{
//            elem.title =
//        }
//        a.caption = "Item 2"
//        a.title = "0"
//
//       let b = WKPickerItem()
//       b.caption = "Item 2"
//       b.title = "stringa2"
        
       // elementi = [a, b]
        workHoursPicker.focus()

        workHoursPicker.setItems(elementi)


    }
    
    @IBAction func setWorkHourVariable(_ value: Int) {
        print(value + 1)
        selectedWorkHours = value + 1
        

    }
    
    @IBAction func pressedNext() {
        pushController(withName: "DataEvaluation", context: selectedWorkHours)
        /*let message = ["ore": selectedWorkHours ]
        wcSession.sendMessage(message, replyHandler: nil, errorHandler: {
            (error) in
            print(error.localizedDescription)
        })*/
        
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
