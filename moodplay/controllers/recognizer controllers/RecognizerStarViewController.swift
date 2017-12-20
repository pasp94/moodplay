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
        
        self.navigationItem.title = "Recognizer"
    self.navigationController?.navigationBar.prefersLargeTitles = true
        self.startingMessageLabel.text = "Hi \(User.shared.name)! How do You feel now?"
    }
    
    @IBAction func startToRecognize(_ sender: UIButton) {
        
    }
}
