//
//  ThirdViewController.swift
//  moodplay_conf
//
//  Created by Fabio Salvo on 14/12/17.
//  Copyright © 2017 Fabio Salvo. All rights reserved.
//

import UIKit
import AVFoundation

class ThirdViewController: UIViewController, UIPickerViewDataSource , UIPickerViewDelegate {
    
    var Player: AVPlayer!
    var PlayerLayer: AVPlayerLayer!
    
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var agePickerView: UIPickerView!
    
    let ages = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100]
     
    
    func numberOfComponents(in agePickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ agePickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return String(Int(ages[row]))
    }
    
    func pickerView(_ agePickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ages.count
    }
    
    func pickerView(_ agePickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        ageLabel.text = String(Int(ages[row]))
    }
    
    
    @IBAction func nextButton(_ sender: UIButton) {
        User.shared.age = Int(ageLabel.text!)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let URL = Bundle.main.url(forResource: "gradient", withExtension: "mov")
        
        
        
        Player = AVPlayer.init(url: URL!)
        
        PlayerLayer = AVPlayerLayer(player: Player)
        PlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        PlayerLayer.frame = view.layer.frame
        
        Player.actionAtItemEnd = AVPlayerActionAtItemEnd.none
        
        Player.play()
        
        view.layer.insertSublayer(PlayerLayer, at: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemReachEnd(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: Player.currentItem)
        agePickerView.tintColor = .white
        
    }
    
    @objc func playerItemReachEnd(notification: NSNotification){
        Player.seek(to: kCMTimeZero)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


