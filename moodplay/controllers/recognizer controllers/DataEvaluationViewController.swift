//
//  DataEvaluationViewController.swift
//  moodplay
//
//  Created by Andrea Mignano on 20/12/17.
//  Copyright © 2017 Pasquale Spisto. All rights reserved.
//

import UIKit

class DataEvaluationViewController: UIViewController {

    //Icons Outlets
    @IBOutlet weak var cardioIconEval: UIImageView!
    @IBOutlet weak var calendarIconEval: UIImageView!
    @IBOutlet weak var weatherIconEval: UIImageView!
    
    //Title Outlets
    @IBOutlet weak var cardioTitle: UILabel!
    @IBOutlet weak var calendarTitle: UILabel!
    @IBOutlet weak var weatherTitle: UILabel!
    
    //Subtitle Outlets
    @IBOutlet weak var cardioSubtitle: UILabel!
    @IBOutlet weak var calendarSubtitle: UILabel!
    @IBOutlet weak var weatherSubtitle: UILabel!
    
    //Appearing Functions
    var timer = Timer()
    @objc func showCardioIcon(){
        cardioIconEval.isHidden = false
        cardioTitle.isHidden = false
        cardioSubtitle.isHidden = false
    }
    
    @objc func showCalendarIcon(){
        calendarIconEval.isHidden = false
        calendarTitle.isHidden = false
        calendarSubtitle.isHidden = false
    }
    
    @objc func showWeatherIcon(){
        weatherIconEval.isHidden = false
        weatherTitle.isHidden = false
        weatherSubtitle.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Cardio Appearing
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(showCardioIcon), userInfo: nil, repeats: false)
        
        //Calendar Appearing
         Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(showCalendarIcon), userInfo: nil, repeats: false)
        
        //Weather Appearing
         Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(showWeatherIcon), userInfo: nil, repeats: false)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
