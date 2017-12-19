//
//  PlayerViewController.swift
//  moodplay
//
//  Created by Matteo Russo on 18/12/17.
//  Copyright © 2017 Pasquale Spisto. All rights reserved.
//

import UIKit
import AVFoundation



extension String {
    subscript(value: PartialRangeUpTo<Int>) -> Substring {
        get {
            return self[..<index(startIndex, offsetBy: value.upperBound)]
        }
    }
    
    subscript(value: PartialRangeThrough<Int>) -> Substring {
        get {
            return self[...index(startIndex, offsetBy: value.upperBound)]
        }
    }
    
    subscript(value: PartialRangeFrom<Int>) -> Substring {
        get {
            return self[index(startIndex, offsetBy: value.lowerBound)...]
        }
    }
}

class PlayerViewController: UIViewController {
    
    var seconds = 0
    var songDuration = 30
    var timer = Timer()
    var isTimerRunning = false
    var AudioPlayer = AVAudioPlayer()
    var Player: AVPlayer!
    var PlayerLayer: AVPlayerLayer!
    var songs = [Song] ()
    var index = 0
    var flag = 1

    
    
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var currentTime: UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var songArtist: UILabel!
    @IBOutlet weak var songAlbum: UILabel!
    @IBOutlet weak var songAlbumImage: UIImageView!
    
    
    @IBAction func volumeSlider(_ sender: UISlider) {
        AudioPlayer.volume = sender.value
    }
    
    @IBAction func playOrPause(_ sender: UIButton){
        
        if AudioPlayer.isPlaying == true
        {
            sender.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        
          AudioPlayer.stop()
          
            
        }
        else
        {
            sender.setImage(#imageLiteral(resourceName: "pause_push"), for: .normal)
            AudioPlayer.play()
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
            self.AudioPlayer = try AVAudioPlayer(contentsOf: url)
            
            DispatchQueue.main.async {
                self.playOrPauseButton.setImage(#imageLiteral(resourceName: "pause_push"), for: .normal)
                self.duration.text = "-"+String((self.AudioPlayer.duration/100)).replacingOccurrences(of: ".", with: ":")[...3]
                
            }
            
            AudioPlayer.prepareToPlay()
            AudioPlayer.play()
            
            
            
            
        } catch  {
            print(error)
            return
        }
        
    }
    func setStatusBarBackgroundColor(color: UIColor) {
        
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        
        statusBar.backgroundColor = color
    }
    
    @IBAction func back(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    func resetTimer(){
        timer.invalidate()
        runTimer()
    }
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(PlayerViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds += 1     //This will incrementthe seconds.
        currentTime.text = timeString(time: TimeInterval(seconds)) //This will update the label.
        let progressPercent = Float(progressBar.frame.width) / Float(songs[index].duration_ms)
        progressBar.progress += progressPercent * 17
        //print(progressPercent)
    }
    
    func back(sender: UIBarButtonItem) {
        // Perform your custom actions
        // ...
        // Go back to the previous ViewController
        AudioPlayer.stop()
    }
    
//    func runTimerMinus() {
//        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(PlayerViewController.updateTimerMinus)), userInfo: nil, repeats: true)
//    }
    
////    @objc func updateTimerMinus() {
//        self.songs[self.index].duration_ms += -1     //This will decrement(count down)the seconds.
//        duration.text = "-"+String((self.songs[self.index].duration_ms/100)).replacingOccurrences(of: ".", with: ":")[...3] //This will update the label.
//    }

func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
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
        
        resetTimer()
        
        
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
        resetTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AudioPlayer.stop()
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setStatusBarBackgroundColor(color: UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)) 
       runTimer()
        updateTimer()
//        runTimerMinus()
//        updateTimerMinus()
        
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
