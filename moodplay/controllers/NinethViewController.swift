//
//  NinethViewController.swift
//  moodplay_conf
//
//  Created by Fabio Salvo on 14/12/17.
//  Copyright © 2017 Fabio Salvo. All rights reserved.
//

import UIKit
import AVFoundation

class NinethViewController: UIViewController {
    
    var Player: AVPlayer!
    var PlayerLayer: AVPlayerLayer!
     
    @IBAction func sendToDb(_ sender: UIButton) {
        UserDAO.shared.writeObjectToCloud(object: User.shared)
        UserDefaults.standard.set(true , forKey: "hasConfigurated")
        UserDefaults.standard.synchronize()
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


