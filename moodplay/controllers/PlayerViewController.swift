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
    var timer1 = Timer()
    var isTimerRunning = false
    var AudioPlayer = AVAudioPlayer()
    var Player: AVPlayer!
    var PlayerLayer: AVPlayerLayer!
    var songs = [Song] ()
    var index = 0
    var flag = 1
    var timerIsOn = false
    var riproduci = false
    var shuffle = false
    
    
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var currentTime: UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var songTitle: MarqueeLabel!
    @IBOutlet weak var songArtist: MarqueeLabel!
    @IBOutlet weak var songAlbum: MarqueeLabel!
    @IBOutlet weak var songAlbumImage: UIImageView!
    
    
    @IBAction func volumeSlider(_ sender: UISlider) {
        AudioPlayer.volume = sender.value
    }
    
    @IBAction func playOrPause(_ sender: UIButton){
        
        if AudioPlayer.isPlaying == true
        {
            sender.setImage(#imageLiteral(resourceName: "icons8-play_filled"), for: .normal)
           pauseTimer()
        
          AudioPlayer.stop()
          
            
        }
        else
        {
            sender.setImage(#imageLiteral(resourceName: "icons8-pause_filled"), for: .normal)
            AudioPlayer.play()
            runTimer()
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
                self.playOrPauseButton.setImage(#imageLiteral(resourceName: "icons8-pause_filled"), for: .normal)
                self.duration.text = "0"+String((self.AudioPlayer.duration/100)).replacingOccurrences(of: ".", with: ":")[...3]
                
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
            AudioPlayer.stop()
            stopTimer()
        }
    }
    
    func pauseTimer(){
        timer.invalidate()
    }
    
    func resetTimer(){
        timer.invalidate()
        seconds = 0
        progressBar.progress = 0
        runTimer()
    }
    
    func stopTimer(){
        timer.invalidate()
        seconds = 0
        progressBar.progress = 0
        
    }
    
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PlayerViewController.updateTimer), userInfo: nil, repeats: true)
        
    }
    
    func runAutoPlay() {
        timer1 = Timer.scheduledTimer(timeInterval: 1, target: self,selector: #selector(PlayerViewController.autoPlay), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds += 1     //This will incrementthe seconds.
        currentTime.text = timeString(time: TimeInterval(seconds)) //This will update the label.
         let progressPercent = Float(progressBar.frame.width) / 30000
        progressBar.progress += progressPercent * 3
        if progressBar.progress == 1 {
            pauseTimer()
        }
        

    }
    
    @objc func autoPlay() {
        if currentTime.text == duration.text{ // play automatically next song
            resetTimer()
            if self.shuffle
            {
                index = Int(UInt32(arc4random_uniform(UInt32(songs.count))))
            }
            else
            {
                index = (index + 1) % songs.count
            }
            
            AudioPlayer.stop()
            downloadFileFromURL(url: URL(string: songs[index].spotifyPreviewURL)! )
            songTitle.text = " " + songs[index].title
            songArtist.text = " " + songs[index].author
            songAlbum.text = " " + songs[index].album
            currentTime.text = ""
            
            var data = Data()
            do{
                data = try Data(contentsOf: URL(string: songs[index].artworks[0])!)
                songAlbumImage.image = UIImage(data: data)
            }catch{
                print(error)
            }
            
        }
    }
    


func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }

    @IBAction func buttonLeftPressed(_ sender: Any) {
        resetTimer()
        if index != 0{
           index = index - 1
        }
        else
        {
            index = songs.count - 1
        }
        AudioPlayer.stop()
        downloadFileFromURL(url: URL(string: songs[index].spotifyPreviewURL)! )
        songTitle.text = " " + songs[index].title
        songArtist.text = " " + songs[index].author
        songAlbum.text = " " + songs[index].album
        currentTime.text = ""
        var data = Data()
        do{
            data = try Data(contentsOf: URL(string: songs[index].artworks[0])!)
            songAlbumImage.image = UIImage(data: data)
        }catch{
            print(error)
        }
        
        
        
        
    }
    
    @IBAction func buttonRightPressed(_ sender: Any) {
        resetTimer()
        index = (index + 1) % songs.count
        AudioPlayer.stop()
        downloadFileFromURL(url: URL(string: songs[index].spotifyPreviewURL)! )
        songTitle.text = " " + songs[index].title
        songArtist.text = " " + songs[index].author
        songAlbum.text = " " + songs[index].album
        currentTime.text = ""
    
        var data = Data()
        do{
            data = try Data(contentsOf: URL(string: songs[index].artworks[0])!)
            songAlbumImage.image = UIImage(data: data)
        }catch{
            print(error)
        }
      

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AudioPlayer.stop()
        self.shuffle = false
        self.riproduci = false
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        setStatusBarBackgroundColor(color: UIColor.black)
//            UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0))
        downloadFileFromURL(url: URL(string: songs[index].spotifyPreviewURL)! )
        runTimer()
        runAutoPlay()
        playOrPauseButton.setImage(#imageLiteral(resourceName: "icons8-pause_filled"), for: .normal)
        //playOrPauseButton.setImage(#imageLiteral(resourceName: "pause_push"), for: .normal)
        songTitle.text = " " + songs[index].title
        songArtist.text = " " + songs[index].author
        songAlbum.text = " " + songs[index].album
        var data = Data()
        do{
            data = try Data(contentsOf: URL(string: songs[index].artworks[0])!)
            songAlbumImage.image = UIImage(data: data)
        }catch{
            print(error)
        }
        let urlBackground = Bundle.main.url(forResource: "gradient", withExtension: "mov")
     
        
        
        songTitle.tag = 101
        songTitle.type = .continuous
        songTitle.animationCurve = .easeInOut
        
        songArtist.tag = 101
        songArtist.type = .continuous
        songArtist.animationCurve = .easeInOut
        
        songAlbum.tag = 101
        songAlbum.type = .continuous
        songAlbum.animationCurve = .easeInOut
        // Text string, fade length, leading buffer, trailing buffer, and scroll
        // duration for this label are set via Interface Builder's Attributes Inspector!
        
        // Do any additional setup after loading the view, typically from a nib.
        
        
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
