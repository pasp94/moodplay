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
    let updateRecordDispatchQueue = DispatchQueue(label: "UPDATE_RECORD")
    
    let dispatchGroup  = DispatchGroup()
    
    private override init(){}
    
    func writeObjectToCloud(object: AnyObject) {
        
        let mood = object as! Mood
        
        let moodRecord = CKRecord(recordType: "MoodPlayMood", recordID: CKRecordID(recordName: mood.name))
        moodRecord.setValue(mood.name, forKey: "name")
        moodRecord.setValue([mood.color.r, mood.color.g, mood.color.b], forKey: "color")
        
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
                let rgb = record!["color"] as! [Float]
                
                
                let color = RGBColor(r: rgb[0], g: rgb[1], b: rgb[2])
                
                data = Mood(name: name, color: color)
                
                self.dispatchGroup.leave()
            }
            
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
            let mood = object as! Mood
            
            let moodRecord = CKRecord(recordType: "MoodPlayMood", recordID: CKRecordID(recordName: mood.name))
            moodRecord.setValue(mood.name, forKey: "name")
            moodRecord.setValue([mood.color.r, mood.color.g, mood.color.b], forKey: "color")
            
            self.database.save(moodRecord, completionHandler: {
                (record, error) in
                
                if error != nil{
                    print(error as! String)
                    return
                }
                
                print("Saved record")
                self.dispatchGroup.leave()
                
            })
            
            self.dispatchGroup.wait()
            
            
            
            
    }
    
    
    
}
    func readAllObjects() -> [AnyObject]
    {
        let query = CKQuery(recordType: "MoodPlayMood", predicate: NSPredicate(value: true))
        
        var moods = [Mood]()
        
        fetchObjectsDispatchQueue.sync {
            
            //MySingleton.shared.finished_query = false
            self.dispatchGroup.enter()
            
            self.database.perform(query, inZoneWith: nil, completionHandler: {
                
                result, error in
                
                
                for r in result!
                {
                    let name = r.object(forKey: "name")! as! String
                    let rgb = r.object(forKey: "color")! as! [Float]
                    
                    moods.append(Mood(name: name, color: RGBColor(r: rgb[0], g: rgb[1], b: rgb[2])))
                    
                }
                
                //MySingleton.shared.finished_query = true
                self.dispatchGroup.leave()
                
            })
            
            //while MySingleton.shared.finished_query != true {}
            self.dispatchGroup.wait()
        }
        
        return moods
    }

}
