//
//  UserDAO.swift
//  moodplay
//
//  Created by Pasquale on 14/12/17.
//  Copyright © 2017 Pasquale. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class UserDAO: ProtocolDAO{
    
    
    let readObjectFromCloudDispatchQueue = DispatchQueue(label: "READ_OBJECT_FROM_CLOUD")
    let updateRecordDispatchQueue = DispatchQueue(label: "UPDATE_RECORD")
    let dispatchGroup  = DispatchGroup()
    let database = CKContainer.default().privateCloudDatabase
    static let shared = UserDAO()
    private init (){}
    
    func writeImage(image: UIImage) -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent(NSUUID().uuidString + ".png")
        if let imageData = UIImagePNGRepresentation(image) {
            do{
                try imageData.write(to: fileURL)
                
            }catch{
                print(error)
            }
        }
        
        return fileURL as URL
    }
    
    
    func writeObjectToCloud(object: AnyObject) {
        
        let user = object as! User
        
        let record = CKRecord(recordType: "MoodPlayUser", recordID: CKRecordID(recordName: "user_data"))
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
        record.setValue(user.recognizedMood, forKey: "recognizedMood")
        record.setValue(user.recognitionTime, forKey: "recognitionTime")
        
        record.setValue(CKAsset(fileURL: writeImage(image: user.profileImage)), forKey: "profileImage")
    
        
        database.save(record, completionHandler:{
            
            record,error in
            
            if record == nil{
                print(error!)
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
                User.shared.recognizedMood = record!["recognizedMood"] as! String
                User.shared.recognitionTime = record!["recognitionTime"] as! String
                
                let asset = record!["profileImage"] as? CKAsset
                
                var image = UIImage()
                if let file = asset{
                    do{
                        image = UIImage(data: try Data(contentsOf: file.fileURL))!
                        
                        User.shared.profileImage = image
                        
                    }
                    catch{
                        print(error)
                    }
                    
                }
                
                
                
                data = User.shared
                
                //MySingleton.shared.finished = true
                self.dispatchGroup.leave()
                
            }
            
            //while(MySingleton.shared.finished != true){}
            self.dispatchGroup.wait()
            
        }
        
        return data!
    }
    
    func deleteRecord(id: String) {
        database.delete(withRecordID: CKRecordID(recordName: id), completionHandler: {
            
            
            record,error in
            
            if record == nil{
                print(error!)
                return
            }
            print("record deleted successfully")
            
            
        })
    }
    
    func updateRecord(id: String, object: AnyObject) {
        
        updateRecordDispatchQueue.sync {
            self.dispatchGroup.enter()
            self.database.delete(withRecordID: CKRecordID(recordName: id), completionHandler: {
                
                
                record,error in
                
                if record == nil{
                    print(error!)
                    return
                }
                print("record deleted successfully")
                
                self.dispatchGroup.leave()
            })
            
            self.dispatchGroup.wait()
            
            self.dispatchGroup.enter()
            let user = object as! User
            
            let record = CKRecord(recordType: "MoodPlayUser", recordID: CKRecordID(recordName: "user_data"))
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
            record.setValue(user.recognizedMood, forKey: "recognizedMood")
            record.setValue(user.recognitionTime, forKey: "recognitionTime")
            
            record.setValue(CKAsset(fileURL: writeImage(image: user.profileImage)), forKey: "profileImage")
            
            database.save(record, completionHandler:{
                
                record,error in
                
                if record == nil{
                    print(error!)
                    return
                }
                print("record saved successfully")
                self.dispatchGroup.leave()
            })
            self.dispatchGroup.wait()
            
        }
        
    }
    

    
}
