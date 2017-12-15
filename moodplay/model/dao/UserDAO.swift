//
//  UserDAO.swift
//  prova
//
//  Created by Pasquale on 14/12/17.
//  Copyright © 2017 Pasquale. All rights reserved.
//

import Foundation
import CloudKit

class UserDAO: ProtocolDAO{


    static let shared = UserDAO()
    let readObjectFromCloudDispatchQueue = DispatchQueue(label: "READ_OBJECT_FROM_CLOUD")
    let dispatchGroup  = DispatchGroup()
    
    private init (){}
    let database = CKContainer.default().privateCloudDatabase
    
    func writeObjectToCloud(object: AnyObject) {
        
        let user = object as! User
        
        let record = CKRecord(recordType: "MoodplaytUser", recordID: CKRecordID(recordName: "user_data"))
        record.setValue(user.name, forKey: "name")
        record.setValue(user.surname, forKey: "surname")
        record.setValue(user.age, forKey: "age")
        record.setValue(user.genre, forKey: "genre")
        record.setValue(user.sleepHr, forKey: "sleepHr")
        record.setValue(user.workHr, forKey: "workHr")
        record.setValue(user.workSatisfactionFlag, forKey: "workSatisfactionFlag")
        record.setValue(user.weatherFlag, forKey: "weatherFlag")
        record.setValue(user.musicFlag, forKey: "musicFlag")
        record.setValue(user.bpmRate, forKey: "bpmRate")
        
        database.save(record, completionHandler:{
            
            record,error in
            
            if record == nil{
                print("error")
                return
            }
            print("record saved successfully")
        })
    }
    
    func readObjectFromCloud(id: String) -> AnyObject {
        var data: User?
        
        
        
        readObjectFromCloudDispatchQueue.sync {
            
            //MySingleton.shared.finished = false;
            self.dispatchGroup.enter()
            
            //Async function
            self.database.fetch(withRecordID: CKRecordID(recordName: id)){ (record, error) in
                
                //print(error)
                
                guard record != nil else {return}
                
                User.shared.name = record!["name"] as! String
                User.shared.surname = record!["surname"] as! String
                User.shared.age = record!["age"] as! Int              //reference to class Song
                User.shared.genre = record!["genre"] as! String
                User.shared.sleepHr = record!["sleepHr"] as! Int
                User.shared.workHr = record!["workHr"] as! Int
                User.shared.workSatisfactionFlag = record!["workSatisfactionFlag"] as! Bool
                User.shared.weatherFlag = record!["weatherFlag"] as! Bool
                User.shared.musicFlag = record!["musicFlag"] as! Bool
                User.shared.bpmRate = record!["bpmRate"] as! Int
                
                data = User.shared
                
                //MySingleton.shared.finished = true
                self.dispatchGroup.leave()
                
            }
            
            //while(MySingleton.shared.finished != true){}
            self.dispatchGroup.wait()
            
        }
        
        return data!
    }
    

    
    
    
}
