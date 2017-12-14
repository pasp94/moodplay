//
//  Moodlist.swift
//  moodplay
//
//  Created by Andrea Mignano on 14/12/17.
//  Copyright © 2017 Pasquale Spisto. All rights reserved.
//

import Foundation
import UIKit

class Moodlist {
    
    //Attributes
    public let id : Int
    public var title : String
    public var songs : [Song]                  //reference to class Song
    public var mood : Mood
    
    public var color: RGBColor
    
    //Inits
    init (id: Int, title: String, songs: [Song], mood: Mood) {
        
        self.id = id
        self.title = title
        self.songs = songs
        self.mood = mood
        self.color = mood.color
        
    }
    
    //Methods
    
}
