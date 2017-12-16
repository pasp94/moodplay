//
//  FifthViewController.swift
//  moodplay_conf
//
//  Created by Fabio Salvo on 14/12/17.
//  Copyright © 2017 Fabio Salvo. All rights reserved.
//

import UIKit
import AVFoundation
 
class FifthViewController: UIViewController, UIPickerViewDataSource , UIPickerViewDelegate {
    
    @IBOutlet weak var workLabel: UILabel!
    @IBOutlet weak var workPickerView: UIPickerView!
    
    @IBAction func nextButton(_ sender: UIButton) {
        User.shared.workHr = Int(workLabel.text!)!
    }
    
    
    var Player: AVPlayer!
    var PlayerLayer: AVPlayerLayer!
    
    let hours = [0,1,2,3,4,5,6,7,8,9,10,11,12]
    
    //    --------------WORK HOURS----------
    
    func numberOfComponents(in sleepPickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ workPickerView: UIPickerView, titleForRow rows: Int, forComponent components: Int) -> String?
    {
        return String(Int(hours[rows]))
    }
    
    func pickerView(_ workPickerView: UIPickerView, numberOfRowsInComponent components: Int) -> Int {
        return hours.count
    }
    
    func pickerView(_ workPickerView: UIPickerView, didSelectRow rows: Int, inComponent components: Int){
        workLabel.text = String(Int(hours[rows]))
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
        
    }
    
    @objc func playerItemReachEnd(notification: NSNotification){
        Player.seek(to: kCMTimeZero)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


