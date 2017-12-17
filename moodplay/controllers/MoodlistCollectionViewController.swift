//
//  MoodlistCollectionViewController.swift
//  moodplay
//
//  Created by Andrea Mignano on 14/12/17.
//  Copyright © 2017 Pasquale Spisto. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MoodlistCell"

class MoodlistCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    //Define how many items per row
    fileprivate let itemsPerRow : CGFloat = 2
    
    //
    var moods = [Mood]() // Pasquale Pelliccia
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moods = MoodDAO.shared.readAllObjects() as! [Mood]
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Qui passiamo la moodlist alla tableview
        if let nextVC = segue.destination as? MoodlistTableViewController{
            let cell = sender as! MoodlistCollectionViewCell
            let indexPath = self.collectionView?.indexPath(for: cell)
            nextVC.songs = SongDAO.shared.fetchObjects(field: "mood", equalTo: moods[(indexPath?.row)!].name) as! [Song]
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
        
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        //return 3
        return moods.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MoodlistCollectionViewCell
    
        
        // Configure the cell
        let index = indexPath.item
        
        //cell.backgroundColor = UIColor.blue commentato da Pasquale Pelliccia
        cell.backgroundColor = UIColor(red: CGFloat(moods[indexPath.row].color.r), green: CGFloat(moods[indexPath.row].color.g), blue: CGFloat(moods[indexPath.row].color.b), alpha: 1.0)
        // cell.backgroundColor = UIColor(red: mood.color.r, green:mood.color.g, blue:mood.color.b, alpha:1.0)
        cell.layer.cornerRadius = 5
        // cell.titleLabel.text = moodlist.title
        //cell.titleLabel.text = "Titolo" commentato da Pasquale Pelliccia
        cell.titleLabel.text = moods[indexPath.row].name
        cell.titleLabel.textColor = UIColor.black

        
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: itemSize)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        self.performSegue(withIdentifier: "showSongs", sender: cell)
    }
    
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
