//
//  MoodDAO.swift
//  moodplay
//
//  Created by Andrea Mignano on 15/12/17.
//  Copyright © 2017 Pasquale Spisto. All rights reserved.
//

import Foundation
import CloudKit


class MoodDAO : DAO, ProtocolDAO {
    
    static let shared = MoodDAO()

    //
    let readObjectFromCloudDispatchQueue = DispatchQueue(label: "READ_OBJECT_FROM_CLOUD")
    let fetchObjectsDispatchQueue = DispatchQueue(label: "FETCH_OBJECTS")
    let dispatchGroup  = DispatchGroup()
    
    private override init(){}
    
    func writeObjectToCloud(object: AnyObject) {
        
        let mood = object as! Mood
        
        let moodRecord = CKRecord(recordType: "MoodplayMood", recordID: CKRecordID(recordName: mood.name))
        moodRecord.setValue(mood.name, forKey: "name")
        moodRecord.setValue(mood.color, forKey: "color")
        
        self.database.save(moodRecord, completionHandler: {
            (record, error) in
            
            if error != nil{
                print(error as! String)
            return
            }
            
            print("Saved record")
            
            
        })
    }
    
    func readObjectFromCloud(id: String) -> AnyObject {
        var data : Mood?
        
        readObjectFromCloudDispatchQueue.sync {
            self.dispatchGroup.enter()
            
            self.database.fetch(withRecordID: CKRecordID(recordName: id)){
                (record, error) in
                
                guard record != nil else {return}
                
                let name = record!["name"] as! String
                let color = record!["color"] as! RGBColor
                
                data = Mood(name: name, color: color)
                
                self.dispatchGroup.leave()
            }
            
            self.dispatchGroup.wait()
        }
        
        return data!
    }
    
    
    
}
