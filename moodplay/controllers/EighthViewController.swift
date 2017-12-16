//
//  EighthViewController.swift
//  moodplay_conf
//
//  Created by Fabio Salvo on 14/12/17.
//  Copyright © 2017 Fabio Salvo. All rights reserved.
//

import UIKit
import AVFoundation
 
class EighthViewController: UIViewController {
    
    var Player: AVPlayer!
    var PlayerLayer: AVPlayerLayer!
    
    var flag = 0
    
    @IBAction func yes(_ sender: UIButton) {
        
        if flag == 0{
            sender.setImage(#imageLiteral(resourceName: "yes_push"), for: .normal)
            User.shared.musicFlag = true
            flag = 1 
        }
        
    }
    
    @IBAction func no(_ sender: UIButton) {
        
        if flag == 0{
            sender.setImage(#imageLiteral(resourceName: "No_push"), for: .normal)
            User.shared.musicFlag = false
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


