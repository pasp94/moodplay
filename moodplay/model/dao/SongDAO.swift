//
//  SongDAO.swift
//  moodplay
//
//  Created by Pasquale on 12/12/17.
//  Copyright © 2017 Pasquale. All rights reserved.
//

import Foundation
import CloudKit


class SongDAO: DAO, ProtocolDAO
{
    
    static let shared = SongDAO()
    let readObjectFromCloudDispatchQueue = DispatchQueue(label: "READ_OBJECT_FROM_CLOUD")
    let fetchObjectsDispatchQueue = DispatchQueue(label: "FETCH_OBJECTS")
    let updateRecordDispatchQueue = DispatchQueue(label: "UPDATE_RECORD")
    let dispatchGroup  = DispatchGroup()
    
    private override init(){}
    
    func writeObjectToCloud(object: AnyObject) {
        
        let song = object as! Song
        
        let songRecord = CKRecord(recordType: "MoodPlaySong", recordID: CKRecordID(recordName: song.spotifyLink))
        songRecord.setValue(song.author, forKey: "author")
        songRecord.setValue(song.title, forKey: "title")
        songRecord.setValue(song.album, forKey: "album")
        songRecord.setValue(song.duration_ms, forKey: "duration_ms")
        songRecord.setValue(song.mood, forKey: "mood")
        songRecord.setValue(song.spotifyLink, forKey: "spotifyLink")
        songRecord.setValue(song.genres, forKey: "genres")
        songRecord.setValue(song.spotifyPreviewURL, forKey: "spotifyPreviewURL")
        songRecord.setValue(song.artworks, forKey: "artworks")
        
        self.database.save(songRecord){
            
            (record, error) in
            
            if error != nil{
                print(error!)
            }
            
            guard record != nil else {return}
            
            print("saved record")
        }
    }
    
    func readObjectFromCloud(id: String) -> AnyObject {
        
        var data: Song?
        
        readObjectFromCloudDispatchQueue.sync {
            
            //MySingleton.shared.finished = false;
            self.dispatchGroup.enter()
            
            //Async function
            self.database.fetch(withRecordID: CKRecordID(recordName: id)){ (record, error) in
                
                //print(error)
                
                guard record != nil else {return}
                
                let author = record!["author"] as! String
                let title = record!["title"] as! String
                let album = record!["album"] as! String
                let mood = record!["mood"] as! String
                let duration_ms = record!["duration_ms"] as! Int
                let spotifyLink = record!["spotifyLink"] as! String
                let genres = record!["genres"] as! [String]
                let spotifyPreviewURL = record!["spotifyPreviewURL"] as! String
                let artworks = record!["artworks"] as! [String]
                
                
                data = Song(author: author, title: title, album: album, mood: mood, spotifyLink: spotifyLink, duration_ms: duration_ms, genres: genres, spotifyPreviewURL: spotifyPreviewURL, artworks: artworks)
                
                //MySingleton.shared.finished = true
                self.dispatchGroup.leave()
                
            }
            
            //while(MySingleton.shared.finished != true){}
            self.dispatchGroup.wait()
            
        }
        
        return data!
    }
    
    func fetchObjects(field: String, equalTo: String) -> [AnyObject ]  {
        //let query = CKQuery(recordType: "Song", predicate: NSPredicate(value: true))
        let query = CKQuery(recordType: "MoodPlaySong", predicate: NSPredicate(format: "\(field) = %@ ", equalTo))
        
        var songs = [Song]()
        
        fetchObjectsDispatchQueue.sync {
            
            //MySingleton.shared.finished_query = false
            self.dispatchGroup.enter()
            
            self.database.perform(query, inZoneWith: nil, completionHandler: {
                
                result, error in
                
                
                for r in result!
                {
                    let author = r.object(forKey: "author")! as! String
                    let title = r.object(forKey: "title")! as! String
                    let album = r.object(forKey: "album")! as! String
                    let mood = r.object(forKey: "mood")! as! String
                    let spotifyLink = r.object(forKey: "spotifyLink")! as! String
                    let duration_ms = r.object(forKey: "duration_ms")! as! Int
                    let genres = r.object(forKey: "genres")! as! [String]
                    let spotifyPreviewURL = r.object(forKey: "spotifyPreviewURL")! as! String
                    let artworks = r.object(forKey: "artworks")! as! [String]
                    
                    songs.append(Song(author: author, title: title, album: album, mood: mood, spotifyLink: spotifyLink, duration_ms: duration_ms, genres: genres, spotifyPreviewURL: spotifyPreviewURL, artworks: artworks))
                    
                }
                
                //MySingleton.shared.finished_query = true
                self.dispatchGroup.leave()
                
            })
            
            //while MySingleton.shared.finished_query != true {}
            self.dispatchGroup.wait()
        }
        
        return songs
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
            let song = object as! Song
            
            let songRecord = CKRecord(recordType: "MoodPlaySong", recordID: CKRecordID(recordName: song.spotifyLink))
            songRecord.setValue(song.author, forKey: "author")
            songRecord.setValue(song.title, forKey: "title")
            songRecord.setValue(song.album, forKey: "album")
            songRecord.setValue(song.duration_ms, forKey: "duration_ms")
            songRecord.setValue(song.mood, forKey: "mood")
            songRecord.setValue(song.spotifyLink, forKey: "spotifyLink")
            songRecord.setValue(song.genres, forKey: "genres")
            songRecord.setValue(song.spotifyPreviewURL, forKey: "spotifyPreviewURL")
            songRecord.setValue(song.artworks, forKey: "artworks")
            
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
    
}

