//
//  RecognitionViewController.swift
//  moodplay
//
//  Created by Andrea Mignano on 20/12/17.
//  Copyright © 2017 Pasquale Spisto. All rights reserved.
//

import UIKit

class RecognitionViewController: UIViewController {

    @IBOutlet weak var reconizedMoodLabel: UILabel!
    
    //Mood Percentages
    @IBOutlet weak var sadMoodPercentage: UILabel!
    @IBOutlet weak var happyMoodPercentage: UILabel!
    @IBOutlet weak var motivatedMoodPercentage: UILabel!
    
    
    @IBOutlet weak var leaveMoodButton: UIButton!
    @IBOutlet weak var changeMoodButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sadMoodPercentage.text = String("\(Recognizer.shared.sadPercentage)%")
        self.happyMoodPercentage.text = String("\(Recognizer.shared.happyPercentage)%")
        self.motivatedMoodPercentage.text = String("\(Recognizer.shared.motivatedPercentage)%")
        
        changeMoodButton.layer.cornerRadius = 8
        changeMoodButton.backgroundColor = UIColor.orange
    }

}
