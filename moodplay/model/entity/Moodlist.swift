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
    public let id: String
    public var title : String
    public var description: String
    public var songs : [Song]                  //reference to class Song
    public var image: UIImage
    //public var mood : Mood
    
    //public var color: RGBColor
    
    //Inits
    init (id: String, title: String, description: String, songs: [Song],image: UIImage) {
        
        self.id = id
        self.title = title
        self.description = description
        self.songs = songs
        self.image = image
        //self.mood = mood
        //self.color = mood.color
        
    }
    
    //Methods
    
}

