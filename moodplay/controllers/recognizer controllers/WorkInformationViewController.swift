//
//  WorkInformationViewController.swift
//  moodplay
//
//  Created by Pasquale Spisto on 20/12/2017.
//  Copyright © 2017 Pasquale Spisto. All rights reserved.
//

import UIKit

let MAX_WORK_HOURS = 14

class WorkInformationViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var topGuidingLabel: UILabel!
    @IBOutlet weak var counterHoursLabel: UILabel!
    @IBOutlet weak var attentionMessageLabel: UILabel!
    @IBOutlet weak var bottomGuidingLabel: UILabel!
    @IBOutlet weak var increaseButton: UIButton!
    
    var counter : Int = 0
    
    @IBOutlet weak var nextButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.layer.cornerRadius = 8
    
        
        if (self.counter == 0 || self.counter == 1 || self.counter == 2 ) {
           
            increaseButton.setImage(UIImage(named: "green_face"), for: UIControlState.normal)
            
        } else {
            increaseButton.setImage(UIImage(named: "orange_face"), for: UIControlState.normal)
        }
        
        nextButton.backgroundColor = UIColor.orange
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        self.counterHoursLabel.text = String(self.counter)
    }
    
    @IBAction func addToCounter(_ sender: UIButton) {
        self.counter += 1
        
        if self.counter < MAX_WORK_HOURS {
            self.counterHoursLabel.text = String(self.counter)
        } else {
            self.counter = -1
        }
    }
    
    @IBAction func updateWorkHours(_ sender: UIButton) {
        Recognizer.shared.workHR = self.counter
        self.performSegue(withIdentifier: "showHealtCalculatorView", sender: self)
    }
}
