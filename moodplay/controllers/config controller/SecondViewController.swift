//
//  SecondViewController.swift
//  moodplay_conf
//
//  Created by Fabio Salvo on 14/12/17.
//  Copyright © 2017 Fabio Salvo. All rights reserved.
//

import UIKit
import AVFoundation

class SecondViewController: UIViewController {
    var flag = 0
    var Player: AVPlayer!
    var PlayerLayer: AVPlayerLayer!
     
    @IBAction func Male(_ sender: UIButton) {
       
            if flag == 0{
                sender.setImage(#imageLiteral(resourceName: "male_push"), for: .normal)
                User.shared.genre = "male"
                flag = 1
            }
        
    }
    
    @IBAction func Female(_ sender: UIButton) {
        
        if flag == 0{
            sender.setImage(#imageLiteral(resourceName: "female_push"), for: .normal)
            User.shared.genre = "female"
            flag = 1
        }
        
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

