//
//  User.swift
//  moodplay
//
//  Created by Andrea Mignano on 14/12/17.
//  Copyright © 2017 Pasquale Spisto. All rights reserved.
//

import Foundation
import UIKit

class User {
    
    //Attributes
    static let shared = User()
    
    public var name : String = ""
    public var surname : String = ""
    public var age : Int = 0
    public var genre : String = ""
    public var sleepHr : Int = 0
    public var workHr: Int = 0
    public var workSatisfactionFlag : Bool = false
    public var weatherFlag : Bool = false
    public var musicFlag : Bool = false
    public var bpmRate : Int = 0
    public var profileImage: UIImage = #imageLiteral(resourceName: "default_profile_image")
    //  public var bpmRateWatch : da Implementare
    public var recognizedMood: String = "default"
    public var recognitionTime: String = "Not avaible"
    
    //Inits
    private init () {}
    
    //Methods
    
    
}

