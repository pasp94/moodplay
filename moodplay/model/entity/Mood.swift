//
//  Mood.swift
//  moodplay
//
//  Created by Andrea Mignano on 14/12/17.
//  Copyright © 2017 Pasquale Spisto. All rights reserved.
//

import Foundation
import UIKit



struct RGBColor {
    var r : Float
    var g : Float
    var b : Float
}

class Mood {
    
    //Attributes
    let name : String
    var color : RGBColor
    var image: UIImage
    var superMood: String
    
    //Inits
    init(name: String, color: RGBColor,image: UIImage, superMood: String ) {
        self.name = name
        self.color = color
        self.image = image
        self.superMood = superMood
    }
    
    //Methods
    
}
