//
//  RecognitionViewController.swift
//  moodplay
//
//  Created by Andrea Mignano on 20/12/17.
//  Copyright © 2017 Pasquale Spisto. All rights reserved.
//

import UIKit

class RecognitionViewController: UIViewController {

    @IBOutlet weak var recognizedMoodLabel: UILabel!
    
    //Mood Percentages
    @IBOutlet weak var sadMoodPercentage: UILabel!
    @IBOutlet weak var happyMoodPercentage: UILabel!
    @IBOutlet weak var motivatedMoodPercentage: UILabel!
    
    
    @IBOutlet weak var leaveMoodButton: UIButton!
    @IBOutlet weak var changeMoodButton: UIButton!
    
    let sad = MoodDAO.shared.readObjectFromCloud(id: "sad") as! Mood
    let happy = MoodDAO.shared.readObjectFromCloud(id: "happy") as! Mood
    let motivated = MoodDAO.shared.readObjectFromCloud(id: "motivated") as! Mood
    
    var moodRecognized : Mood?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sadMoodPercentage.text = String("\(Recognizer.shared.sadPercentage)%")
        self.happyMoodPercentage.text = String("\(Recognizer.shared.happyPercentage)%")
        self.motivatedMoodPercentage.text = String("\(Recognizer.shared.motivatedPercentage)%")
        
        moodRecognized = Recognizer.shared.retriverDominantMood()
        
        self.recognizedMoodLabel.text = moodRecognized?.name.uppercased()
        self.recognizedMoodLabel.textColor = UIColor(red: CGFloat((moodRecognized?.color.r)!), green: CGFloat((moodRecognized?.color.g)!), blue: CGFloat((moodRecognized?.color.b)!), alpha: 1)
        
        self.leaveMoodButton.layer.cornerRadius = 8
        self.leaveMoodButton.backgroundColor = UIColor(red: CGFloat((moodRecognized?.color.r)!), green: CGFloat((moodRecognized?.color.g)!), blue: CGFloat((moodRecognized?.color.b)!), alpha: 1)
        
        self.changeMoodButton.layer.cornerRadius = 8
        self.changeMoodButton.backgroundColor = UIColor.orange
    }
    
    var changeMyMood = false
    
    @IBAction func leaveMood(_ sender: Any) {
        changeMyMood = false
    }
    
    @IBAction func changeMood(_ sender: Any) {
        
        changeMyMood = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let nextVC = segue.destination as? MoodlistCollectionViewController{
            nextVC.recognizer = true
            nextVC.recognizedMood = recognizedMoodLabel.text!.lowercased()
            nextVC.changeMyMood = changeMyMood
        }
    }
    
    @IBAction func pressSadEmoji(_ sender: UIButton) {
        self.recognizedMoodLabel.text = self.sad.name.uppercased()
        self.recognizedMoodLabel.textColor = UIColor(red: CGFloat((self.sad.color.r)), green: CGFloat((self.sad.color.g)), blue: CGFloat((self.sad.color.b)), alpha: 1)
        self.leaveMoodButton.backgroundColor = UIColor(red: CGFloat((self.sad.color.r)), green: CGFloat((self.sad.color.g)), blue: CGFloat((self.sad.color.b)), alpha: 1)
    }
    
    
    @IBAction func pressHappyEmoji(_ sender: UIButton) {
        self.recognizedMoodLabel.text = self.happy.name.uppercased()
        self.recognizedMoodLabel.textColor = UIColor(red: CGFloat((self.happy.color.r)), green: CGFloat((self.happy.color.g)), blue: CGFloat((self.happy.color.b)), alpha: 1)
        self.leaveMoodButton.backgroundColor = UIColor(red: CGFloat((self.happy.color.r)), green: CGFloat((self.happy.color.g)), blue: CGFloat((self.happy.color.b)), alpha: 1)
    }
    
    @IBAction func pressMotevatedEmoji(_ sender: UIButton) {
        self.recognizedMoodLabel.text = self.motivated.name.uppercased()
        self.recognizedMoodLabel.textColor = UIColor(red: CGFloat((self.motivated.color.r)), green: CGFloat((self.motivated.color.g)), blue: CGFloat((self.motivated.color.b)), alpha: 1)
        self.leaveMoodButton.backgroundColor = UIColor(red: CGFloat((self.motivated.color.r)), green: CGFloat((self.motivated.color.g)), blue: CGFloat((self.motivated.color.b)), alpha: 1)
    }
}
