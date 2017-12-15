//
//  UtilitySpotify.swift
//  prova
//
//  Created by Pasquale on 15/12/17.
//  Copyright © 2017 Pasquale. All rights reserved.
//

import Foundation
import Alamofire

class UtilitySpotify{
    
    static let shared = UtilitySpotify()
    private init(){}
    
    typealias JSONStandard = [String: AnyObject]
    
    let headers: HTTPHeaders = [ "Authorization" : "Bearer BQBlHZS3jgpp-5ECPLE0YcNowqAceTT_CKBJBGKhC4P_N2IGffgnHCaplcyi9xaY8Py3Y_qrbt8fdmXMtlynavwEU5IrhRaxAdZPmFaICCFDvBEdiKul5fB9eGBMvQajf3FCNe-M_CoeZ1UNTUQBxj1r4_EpoHpFFQ"]
    
    func createSongFromSpotify(spotifyLink : String, youtubeLink: String, mood: String )
    {
        
        let searchURL = "https://api.spotify.com/v1/tracks/\(spotifyLink)"
        
        Alamofire.request(searchURL, headers : headers).responseJSON(completionHandler: { response in
            self.parseData(JSONData: response.data!, spotifyLink: spotifyLink, youtubeLink: youtubeLink, mood: mood)

            
        })
        
        
    }
    
    func parseArtistData(JSONData: Data, spotifyLink: String, youtubeLink: String, mood: String, author:String, title: String,album:String, duration_ms: Int, spotifyPreviewURL: String){
        do {
            let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONStandard
            
            //print(readableJSON)
            var grabbedGenres = [String]()
            
            if let root = readableJSON as? JSONStandard{
                
                grabbedGenres = root["genres"] as! [String]
                
                SongDAO.shared.writeObjectToCloud(object: Song(author: author, title: title, album: album, mood: mood, youtubeLink: youtubeLink, spotifyLink: spotifyLink, duration_ms: duration_ms, genres: grabbedGenres,spotifyPreviewURL: spotifyPreviewURL))
                
            }
            
        } catch {
            print(error)
        }
    }
    
    func parseData(JSONData: Data, spotifyLink: String, youtubeLink: String, mood: String){
        
        do {
            let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONStandard
            
            //print(readableJSON)
            
            if let root = readableJSON as? JSONStandard
            {
                var grabbedAuthor = ""
                var grabbedTitle = ""
                var grabbedAlbum = ""
                var grabbedDuration_ms = 0
                var grabbedSpotifyPreviewURL = ""
                var authorId = ""
                
                
                
                if let artists = root["artists"] as? [JSONStandard]{
                    //print("author: ", artists[0]["name"] as! String)
                    grabbedAuthor = artists[0]["name"] as! String
                    authorId = artists[0]["id"] as! String
                    //print(artists[0]["id"] as! String)
                }
                
                // print("title: ",root["name"] as! String)
                grabbedTitle = root["name"] as! String
                
                if let album = root["album"] as? JSONStandard{
                    
                    //print("album: ", album["name"] as! String)
                    grabbedAlbum = album["name"] as! String
                }
                
                //print(root["preview_url"] as? String ?? "no_prewiew")
                
                grabbedSpotifyPreviewURL = root["preview_url"] as? String ?? "no_prewiew"
                
                //print("duration_ms: ", root["duration_ms"] as! Int)
                grabbedDuration_ms =  root["duration_ms"] as! Int
                
                Alamofire.request("https://api.spotify.com/v1/artists/\(authorId)", headers : headers).responseJSON(completionHandler: { response in
                    self.parseArtistData(JSONData: response.data!, spotifyLink: spotifyLink, youtubeLink: youtubeLink, mood: mood, author: grabbedAuthor, title: grabbedTitle, album: grabbedAlbum, duration_ms: grabbedDuration_ms, spotifyPreviewURL: grabbedSpotifyPreviewURL)
                    //set your flag to true
                    //MySingleton.shared.finished_parsing = true
                    
                })
                
                
                // saveToCloud(song: Song(author: grabbedAuthor, title: grabbedTitle, album: grabbedAlbum, mood: mood, youtubeLink: youtubeLink, spotifyLink: spotifyLink, duration_ms: grabbedDuration_ms))
                
                
            }
            
        } catch {
            print(error)
        }
        
        
    }
    
    
}
