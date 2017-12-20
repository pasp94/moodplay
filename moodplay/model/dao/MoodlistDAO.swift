//
//  MoodlistDAO.swift
//  moodplay
//
//  Created by Pasquale on 19/12/17.
//  Copyright © 2017 Pasquale Spisto. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class MoodlistDAO: ProtocolDAO{
    
    
    static let shared = MoodlistDAO()
    private init(){}
    let fetchObjectsDispatchQueue = DispatchQueue(label: "FETCH_OBJECTS")
    let updateRecordDispatchQueue = DispatchQueue(label: "UPDATE_RECORD")
    let dispatchGroup  = DispatchGroup()
    
    let database = CKContainer.default().privateCloudDatabase
    
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
        
        let moodlist = object as! Moodlist
        
        let songRecord = CKRecord(recordType: "MoodPlayMoodlist")
        songRecord.setValue(songRecord.recordID.recordName, forKey: "id")
        songRecord.setValue(moodlist.title, forKey: "title")
        songRecord.setValue(moodlist.description, forKey: "description")
        
        songRecord.setValue(CKAsset(fileURL: writeImage(image: moodlist.image)), forKey: "image")
        var songIds = [String]()
        for song in moodlist.songs{
           
            songIds.append(song.spotifyLink)
        }
        songRecord.setValue(songIds, forKey: "songs")
        
        
        self.database.save(songRecord){
            
            (record, error) in
            
            if error != nil{
                print(error!)
            }
            
            guard record != nil else {return}
            
            print("saved record")
        }
    }
    
    func readAllObjects() -> [AnyObject]{
        
        let query = CKQuery(recordType: "MoodPlayMoodlist", predicate: NSPredicate(value: true))
        
        var moodlists = [Moodlist]()
        
        fetchObjectsDispatchQueue.sync {
            
            //MySingleton.shared.finished_query = false
            self.dispatchGroup.enter()
            
            self.database.perform(query, inZoneWith: nil, completionHandler: {
                
                result, error in
                
                
                for r in result!
                {
                    let id = r.object(forKey: "id")! as! String
                    let title = r.object(forKey: "title")! as! String
                    let description = r.object(forKey: "description")! as! String
                    
                    let songIds = r.object(forKey: "songs")! as! [String]
                    
                    var songs = [Song]()
                    
                    for songId in songIds{
                        songs.append(SongDAO.shared.readObjectFromCloud(id: songId) as! Song)
                    }
                    
                    let asset = r.object(forKey: "image")! as? CKAsset
                    
                    var image = UIImage()
                    if let file = asset{
                        do{
                            image = UIImage(data: try Data(contentsOf: file.fileURL))!
                            
                        }
                        catch{
                            print(error)
                        }
                        
                    }
                    
                    
                    moodlists.append(Moodlist(id: id, title: title, description: description, songs: songs, image: image))
                }
                
                //MySingleton.shared.finished_query = true
                self.dispatchGroup.leave()
                
            })
            
            //while MySingleton.shared.finished_query != true {}
            self.dispatchGroup.wait()
        }
        
        return moodlists
        
    }
    
    func updateRecord(id: String, object: AnyObject){
        
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
            
            let moodlist = object as! Moodlist
            
            let songRecord = CKRecord(recordType: "MoodPlayMoodlist")
            songRecord.setValue(songRecord.recordID.recordName, forKey: "id")
            songRecord.setValue(moodlist.title, forKey: "title")
            songRecord.setValue(moodlist.description, forKey: "description")
            var songIds = [String]()
            for song in moodlist.songs{
                
                songIds.append(song.spotifyLink)
            }
            songRecord.setValue(songIds, forKey: "songs")
            
            
            self.database.save(songRecord){
                
                (record, error) in
                
                if error != nil{
                    print(error!)
                }
                
                guard record != nil else {return}
                
                print("saved record")
                self.dispatchGroup.leave()
            }
            self.dispatchGroup.wait()
            
            
        
    }
    
    
    
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
    
}
