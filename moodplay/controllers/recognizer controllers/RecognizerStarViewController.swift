//
//  RecognizerStarViewController.swift
//  moodplay
//
//  Created by Pasquale Spisto on 19/12/2017.
//  Copyright © 2017 Pasquale Spisto. All rights reserved.
//

import UIKit

class RecognizerStarViewController: UIViewController {

    //Icon Outlets
    @IBOutlet weak var cardioIcon: UIImageView!
    @IBOutlet weak var calendarIcon: UIImageView!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    
    @IBOutlet weak var startRecognitionButton: UIButton!
    
    
    @IBOutlet weak var startingMessageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startRecognitionButton.layer.cornerRadius = 8
        
        startRecognitionButton.backgroundColor = UIColor.orange
        _ = UserDAO.shared.readObjectFromCloud(id: "user_data")
        
        self.navigationItem.title = "Recognizer"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.startingMessageLabel.text = "Hi \(User.shared.name)!\n Want to recognize your mood?"
        
        /*let chill = Mood(name: "chill", color: RGBColor(r: 0.99, g: 0.65, b: 1.0), image: #imageLiteral(resourceName: "Chill"), superMood: "chill")
        
        let happy = Mood(name: "happy", color: RGBColor(r: 0.0, g: 0.79, b: 0.46), image: #imageLiteral(resourceName: "happy"), superMood: "happy")
        
        let motivated = Mood(name: "motivated", color: RGBColor(r: 0.96, g: 0.81, b: 0.16), image: #imageLiteral(resourceName: "motivated"), superMood: "motivated")
        
        let sad = Mood(name: "sad", color: RGBColor(r: 0.0, g: 0.38, b: 0.64), image: #imageLiteral(resourceName: "sad"), superMood: "sad")
        
        MoodDAO.shared.updateRecord(id: chill.name, object: chill)
        MoodDAO.shared.updateRecord(id: happy.name, object: happy)
        MoodDAO.shared.updateRecord(id: motivated.name, object: motivated)
        MoodDAO.shared.updateRecord(id: sad.name, object: sad)*/
        
        /*let tmp = MoodDAO.shared.readObjectFromCloud(id: "happy") as! Mood
        
        print(tmp.color.r)*/
  
    }
    
    
    @IBAction func startToRecognize(_ sender: UIButton) {
        
    }
}
