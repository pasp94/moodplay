//
//  Song.swift
//  moodplay
//
//  Created by Andrea Mignano on 14/12/17.
//  Copyright © 2017 Pasquale Spisto. All rights reserved.
//

import Foundation
import UIKit

class Song {
    
    //Song Attributes
    let title : String
    let author : String
    var mood : String
    var genres : [String]
    let duration_ms : Int
    let artwork : String                //Use it casting in UIImage
    
    //External Song Attributes
    var youtubetLink : String
    var spotifyPreviewURLLink : String
    
    //Inits
    init (title: String, author: String, mood: String, genres: [String], duration_ms: Int, artwork: String, ytlink: String, spPrewLink: String) {
        self.title = title
        self.author = author
        self.mood = mood
        self.genres = genres
        self.duration_ms = duration_ms
        self.artwork = artwork
        self.youtubetLink = ytlink
        self.spotifyPreviewURLLink = spPrewLink
    }
    
    
    //Methods
    
    
}
