//
//  Song.swift
//  prova
//
//  Created by Pasquale on 12/12/17.
//  Copyright © 2017 Pasquale. All rights reserved.
//

import Foundation
import UIKit

class Song
{
    
    
    var author: String
    var title: String
    var album: String
    var mood: String
    var duration_ms: Int
    var spotifyLink: String
    var spotifyPreviewURL: String
    var genres: [String]
    var artworks: [String]
    // var test = UIColor(hex: "#b9e4f1")
    
    
    
    init(author: String, title: String, album: String, mood: String, spotifyLink: String, duration_ms: Int, genres: [String],spotifyPreviewURL: String, artworks: [String]){
        self.author = author
        self.title = title
        self.album = album
        self.mood = mood
        self.spotifyLink = spotifyLink
        self.duration_ms = duration_ms
        self.genres = genres
        self.spotifyPreviewURL = spotifyPreviewURL
        self.artworks = artworks
    }
    
    
    
}
