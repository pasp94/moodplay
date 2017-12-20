//
//  MoodlistTableViewController.swift
//  moodplay
//
//  Created by Pasquale Spisto on 15/12/2017.
//  Copyright © 2017 Pasquale Spisto. All rights reserved.
//

import UIKit
import AVFoundation


class MoodlistTableViewController: UITableViewController {
    
    var moodlist: Moodlist?
    
    var songs = [Song]()
    
    //Download URL and play
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Qui passiamo la tableview al player
        if let nextVC = segue.destination as? PlayerViewController{
            let cell = sender as! SongTableViewCell
            let indexPath = self.tableView?.indexPath(for: cell)
            nextVC.songs = songs
            nextVC.index = indexPath!.row - 1
            
        }
        
        if let nextVC = segue.destination as? AddToMoodlistTableViewController{
            let button = sender as! UIButton
            
            let cell = button.superview?.superview as! UITableViewCell
            let indexPath = self.tableView?.indexPath(for: cell)
            //let center = button.center
            
            
            
            //print((indexPath?.row)!-1)
            
            nextVC.song = songs[(indexPath?.row)!-1]
            
            
            //print(prova[0].song.title)
            nextVC.moodlists = MoodlistDAO.shared.readAllObjects() as! [Moodlist]
            
            //print("passata una nuova canzone",songs[(indexPath?.row)!].spotifyLink)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        var numberOfRows = 0
//        if section == 0 {
//            numberOfRows = (moodlist?.songs.count)! + 1
//        }
//
        //return 5
        return 1+songs.count
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath) as! PlayShuffleViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as! SongTableViewCell
        
//            let song = (moodlist?.songs[indexPath.row - 1])!
            //cell.titleLable.text = "Prova"
            
            cell.titleLable.text = songs[indexPath.row - 1].title
            cell.authorLabel.text = songs[indexPath.row - 1].author
            
            var data = Data()
            
            do{
                data = try Data(contentsOf: URL(string: songs[indexPath.row - 1].artworks[2])!)
                cell.imageViewOutlet.image = UIImage(data: data)
            }catch{
                print(error)
            }
        
            
            
            return cell
        }
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    
    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
