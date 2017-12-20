//
//  WorkInformationViewController.swift
//  moodplay
//
//  Created by Pasquale Spisto on 20/12/2017.
//  Copyright © 2017 Pasquale Spisto. All rights reserved.
//

import UIKit

let MAX_WORK_HOURS = 12

class WorkInformationViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var topGuidingLabel: UILabel!
    @IBOutlet weak var counterHoursLabel: UILabel!
    @IBOutlet weak var attentionMessageLabel: UILabel!
    @IBOutlet weak var bottomGuidingLabel: UILabel!
    
    var counter : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        self.counterHoursLabel.text = String(self.counter)
    }
    
    @IBAction func addToCounter(_ sender: UIButton) {
        self.counter += 1
        self.counterHoursLabel.text = String(self.counter)
        
        if self.counter == MAX_WORK_HOURS {
            self.counter = -1
        }
    }
    
    @IBAction func updateWorkHours(_ sender: UIButton) {
        Recognizer.shared.workHR = self.counter
        self.performSegue(withIdentifier: "showHealtCalculatorView", sender: self)
    }
}