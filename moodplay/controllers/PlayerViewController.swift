//
//  PlayerViewController.swift
//  moodplay
//
//  Created by Matteo Russo on 18/12/17.
//  Copyright © 2017 Pasquale Spisto. All rights reserved.
//

import UIKit
import AVFoundation


class PlayerViewController: UIViewController {
    
    

    var AudioPlayer = AVAudioPlayer()
    var Player: AVPlayer!
    var PlayerLayer: AVPlayerLayer!
    var songs = [Song] ()
    var index = 0
    var flag = 1
    

    
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var songArtist: UILabel!
    @IBOutlet weak var songAlbum: UILabel!
    @IBOutlet weak var songAlbumImage: UIImageView!
    
    @IBAction func playOrPause(_ sender: UIButton){
        
        if AudioPlayer.isPlaying == true
        {
            sender.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            AudioPlayer.stop()
            
        }
        else
        {
            sender.setImage(#imageLiteral(resourceName: "pause_push"), for: .normal)
            downloadFileFromURL(url: URL(string: songs[index].spotifyPreviewURL)! )
            
        }
    }
    @IBOutlet weak var playOrPauseButton: UIButton!
    
    func downloadFileFromURL(url: URL){
        
        var downloadTask = URLSessionDownloadTask()
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: {
            customURL, response, error in
            self.playUrl(url: customURL!)
        })
        downloadTask.resume()
    }
    
    func playUrl (url: URL){
        
        do {
            AudioPlayer = try AVAudioPlayer(contentsOf: url)
            
            playOrPauseButton.setImage(#imageLiteral(resourceName: "pause_push"), for: .normal)
            AudioPlayer.prepareToPlay()
            AudioPlayer.play()
            
            
            
        } catch  {
            print(error)
            return
        }
        
    }
    
  
    
    @IBAction func buttonLeftPressed(_ sender: Any) {
        
        if index != 0{
           index = index - 1
        }
        else
        {
            index = songs.count - 1
        }
        AudioPlayer.stop()
        downloadFileFromURL(url: URL(string: songs[index].spotifyPreviewURL)! )
        songTitle.text = songs[index].title
        songArtist.text = songs[index].author
        songAlbum.text = songs[index].album
        var data = Data()
        do{
            data = try Data(contentsOf: URL(string: songs[index].artworks[0])!)
            songAlbumImage.image = UIImage(data: data)
        }catch{
            print(error)
        }
        
        
    }
    
    @IBAction func buttonRightPressed(_ sender: Any) {
        
        index = (index + 1) % songs.count
        AudioPlayer.stop()
        downloadFileFromURL(url: URL(string: songs[index].spotifyPreviewURL)! )
        songTitle.text = songs[index].title
        songArtist.text = songs[index].author
        songAlbum.text = songs[index].album
        var data = Data()
        do{
            data = try Data(contentsOf: URL(string: songs[index].artworks[0])!)
            songAlbumImage.image = UIImage(data: data)
        }catch{
            print(error)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        playOrPauseButton.setImage(#imageLiteral(resourceName: "pause_push"), for: .normal)
        downloadFileFromURL(url: URL(string: songs[index].spotifyPreviewURL)! )
        
        //playOrPauseButton.setImage(#imageLiteral(resourceName: "pause_push"), for: .normal)
        
        
        songTitle.text = songs[index].title
        songArtist.text = songs[index].author
        songAlbum.text = songs[index].album
        var data = Data()
        do{
            data = try Data(contentsOf: URL(string: songs[index].artworks[0])!)
            songAlbumImage.image = UIImage(data: data)
        }catch{
            print(error)
        }
        let urlBackground = Bundle.main.url(forResource: "gradient", withExtension: "mov")
        
        
        
        Player = AVPlayer.init(url: urlBackground!)
        
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
    
        //songAlbumImage.image =
        // Do any additional setup after loading the view.
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
