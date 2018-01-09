//
//  MoodDAO.swift
//  moodplay
//
//  Created by Andrea Mignano on 15/12/17.
//  Copyright © 2017 Pasquale Spisto. All rights reserved.
//

import Foundation
import UIKit
import CloudKit


class MoodDAO : DAO, ProtocolDAO {
    
    
    
    static let shared = MoodDAO()
    
    let readObjectFromCloudDispatchQueue = DispatchQueue(label: "READ_OBJECT_FROM_CLOUD")
    let fetchObjectsDispatchQueue = DispatchQueue(label: "FETCH_OBJECTS")
    let updateRecordDispatchQueue = DispatchQueue(label: "UPDATE_RECORD")
    
    let dispatchGroup  = DispatchGroup()
    
    private override init(){}
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
        
        let mood = object as! Mood
        
        let moodRecord = CKRecord(recordType: "MoodPlayMood", recordID: CKRecordID(recordName: mood.name))
        moodRecord.setValue(mood.name, forKey: "name")
        
        moodRecord.setValue([String(mood.color.r), String(mood.color.g), String(mood.color.b)], forKey: "color")
        moodRecord.setValue(CKAsset(fileURL: writeImage(image: mood.image)), forKey: "image")
        moodRecord.setValue(mood.superMood, forKey: "superMood")
        
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
                let rgb = record!["color"] as! [String]
                let r = (rgb[0] as NSString).floatValue
                let g = (rgb[1] as NSString).floatValue
                let b = (rgb[2] as NSString).floatValue
                
                let color = RGBColor(r: r, g: g, b: b)
                let asset = record!["image"] as? CKAsset
                
                var image = UIImage()
                if let file = asset{
                    do{
                        image = UIImage(data: try Data(contentsOf: file.fileURL))!
                        
                    }
                    catch{
                        print(error)
                    }
                    
                }
                
                let superMood = record!["superMood"] as! String
                
                
                
                
                data = Mood(name: name, color: color, image: image, superMood: superMood)
                
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
            
            moodRecord.setValue([String(mood.color.r), String(mood.color.g), String(mood.color.b)] , forKey: "color")
            moodRecord.setValue(CKAsset(fileURL: writeImage(image: mood.image)), forKey: "image")
            moodRecord.setValue(mood.superMood, forKey: "superMood")
            
            self.database.save(moodRecord, completionHandler: {
                (record, error) in
                
                if error != nil{
                    print(error!)
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
                
                
                for res in result!
                {
                    let name = res.object(forKey: "name")! as! String
                    let rgb = res.object(forKey: "color")! as! [String]
                    let r = (rgb[0] as NSString).floatValue
                    let g = (rgb[1] as NSString).floatValue
                    let b = (rgb[2] as NSString).floatValue
                    
                    let color = RGBColor(r: r, g: g, b: b)
                    let asset = res.object(forKey: "image")! as? CKAsset
                    
                    var image = UIImage()
                    if let file = asset{
                        do{
                            image = UIImage(data: try Data(contentsOf: file.fileURL))!
                            
                        }
                        catch{
                            print(error)
                        }
                        
                    }
                    
                    let superMood = res.object(forKey: "superMood")! as! String
                    
                    
                    moods.append(Mood(name: name, color: color, image: image, superMood: superMood))
                    
                }
                
                //MySingleton.shared.finished_query = true
                self.dispatchGroup.leave()
                
            })
            
            //while MySingleton.shared.finished_query != true {}
            self.dispatchGroup.wait()
        }
        
        return moods
    }
    
    func fetchAllSubMoods() -> [AnyObject ]  {
        //let query = CKQuery(recordType: "Song", predicate: NSPredicate(value: true))
        
        let query = CKQuery(recordType: "MoodPlayMood", predicate: NSPredicate(format: "superMood != %@","true"))
        
        var moods = [Mood]()
        
        fetchObjectsDispatchQueue.sync {
            
            //MySingleton.shared.finished_query = false
            self.dispatchGroup.enter()
            
            self.database.perform(query, inZoneWith: nil, completionHandler: {
                
                result, error in
                
                
                for res in result!
                {
                    let name = res.object(forKey: "name")! as! String
                    let rgb = res.object(forKey: "color")! as! [String]
                    let r = (rgb[0] as NSString).floatValue
                    let g = (rgb[1] as NSString).floatValue
                    let b = (rgb[2] as NSString).floatValue
                    let color = RGBColor(r: r, g: g, b: b)
                    let asset = res.object(forKey: "image")! as? CKAsset
                    
                    var image = UIImage()
                    if let file = asset{
                        do{
                            image = UIImage(data: try Data(contentsOf: file.fileURL))!
                            
                        }
                        catch{
                            print(error)
                        }
                        
                    }
                    
                    let superMood = res.object(forKey: "superMood")! as! String
                    
                    moods.append(Mood(name: name, color: color, image: image, superMood: superMood))
                    
                    
                }
                
                //MySingleton.shared.finished_query = true
                self.dispatchGroup.leave()
                
            })
            
            //while MySingleton.shared.finished_query != true {}
            self.dispatchGroup.wait()
        }
        
        return moods
    }
    
    func fetchObjects(field: String, equalTo: String) -> [AnyObject ]  {
        //let query = CKQuery(recordType: "Song", predicate: NSPredicate(value: true))

        
        let query = CKQuery(recordType: "MoodPlayMood", predicate: NSPredicate(format: "\(field) = %@ && superMood != %@ ", equalTo,"true"))
        
        var moods = [Mood]()
        
        fetchObjectsDispatchQueue.sync {
            
            //MySingleton.shared.finished_query = false
            self.dispatchGroup.enter()
            
            self.database.perform(query, inZoneWith: nil, completionHandler: {
                
                result, error in
                
                
                for res in result!
                {
                    let name = res.object(forKey: "name")! as! String
                    let rgb = res.object(forKey: "color")! as! [String]
                    let r = (rgb[0] as NSString).floatValue
                    let g = (rgb[1] as NSString).floatValue
                    let b = (rgb[2] as NSString).floatValue
                    let color = RGBColor(r: r, g: g, b: b)
                    let asset = res.object(forKey: "image")! as? CKAsset
                    
                    var image = UIImage()
                    if let file = asset{
                        do{
                            image = UIImage(data: try Data(contentsOf: file.fileURL))!
                            
                        }
                        catch{
                            print(error)
                        }
                        
                    }
                    
                    let superMood = res.object(forKey: "superMood")! as! String
                    
                    moods.append(Mood(name: name, color: color, image: image, superMood: superMood))
                    
                    
                }
                
                //MySingleton.shared.finished_query = true
                self.dispatchGroup.leave()
                
            })
            
            //while MySingleton.shared.finished_query != true {}
            self.dispatchGroup.wait()
        }
        
        return moods
    }
    
    func fetchObjects(field: String, notEqualTo: String) -> [AnyObject ]  {
        //let query = CKQuery(recordType: "Song", predicate: NSPredicate(value: true))
        
        let predicate1  = NSPredicate(format: "\(field) != %@  ", notEqualTo)
        let predicate2  = NSPredicate(format: "superMood != %@ ","true")
        
        
        
        let query = CKQuery(recordType: "MoodPlayMood", predicate: NSCompoundPredicate.init(type: .and, subpredicates: [predicate1,predicate2]))
        
        //let query = CKQuery(recordType: "MoodPlayMood", predicate: NSPredicate(format: "\(field) != %@ ", notEqualTo))
        
        var moods = [Mood]()
        
        fetchObjectsDispatchQueue.sync {
            
            //MySingleton.shared.finished_query = false
            self.dispatchGroup.enter()
            
            self.database.perform(query, inZoneWith: nil, completionHandler: {
                
                result, error in
                
                
                for res in result!
                {
                    let name = res.object(forKey: "name")! as! String
                    let rgb = res.object(forKey: "color")! as! [String]
                    let r = (rgb[0] as NSString).floatValue
                    let g = (rgb[1] as NSString).floatValue
                    let b = (rgb[2] as NSString).floatValue
                    let color = RGBColor(r: r, g: g, b: b)
                    let asset = res.object(forKey: "image")! as? CKAsset
                    
                    var image = UIImage()
                    if let file = asset{
                        do{
                            image = UIImage(data: try Data(contentsOf: file.fileURL))!
                            
                        }
                        catch{
                            print(error)
                        }
                        
                    }
                    
                    let superMood = res.object(forKey: "superMood")! as! String
                    
                    moods.append(Mood(name: name, color: color, image: image, superMood: superMood))
                    
                    
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

