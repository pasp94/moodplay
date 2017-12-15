//
//  Song.swift
//  prova
//
//  Created by Pasquale on 12/12/17.
//  Copyright © 2017 Pasquale. All rights reserved.
//

import Foundation
import UIKit

/*extension UIColor {
 
 // MARK: - Initialization
 
 convenience init?(hex: String) {
 
 var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
 hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
 
 var rgb: UInt32 = 0
 
 var r: CGFloat = 0.0
 var g: CGFloat = 0.0
 var b: CGFloat = 0.0
 var a: CGFloat = 1.0
 
 let length = hexSanitized.count
 
 
 guard Scanner(string: hexSanitized).scanHexInt32(&rgb) else { return nil }
 
 if length == 6 {
 r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
 g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
 b = CGFloat(rgb & 0x0000FF) / 255.0
 
 } else if length == 8 {
 r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
 g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
 b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
 a = CGFloat(rgb & 0x000000FF) / 255.0
 
 } else {
 return nil
 }
 
 print("r = ",r,"g = ",g,"b = ", b,"a = ", a)
 
 self.init(red: r, green: g, blue: b, alpha: a)
 }
 
 }*/

class Song
{
    
    
    var author: String
    var title: String
    var album: String
    var mood: String
    var duration_ms: Int
    var youtubeLink: String
    var spotifyLink: String
    var spotifyPreviewURL: String
    var genres: [String]
    
    
    
    init(author: String, title: String, album: String, mood: String, youtubeLink: String, spotifyLink: String, duration_ms: Int, genres: [String],spotifyPreviewURL: String){
        self.author = author
        self.title = title
        self.album = album
        self.mood = mood
        self.youtubeLink = youtubeLink
        self.spotifyLink = spotifyLink
        self.duration_ms = duration_ms
        self.genres = genres
        self.spotifyPreviewURL = spotifyPreviewURL
    }
    
    
    
}

