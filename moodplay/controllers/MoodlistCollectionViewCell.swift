//
//  MoodlistCollectionViewCell.swift
//  moodplay
//
//  Created by Andrea Mignano on 14/12/17.
//  Copyright © 2017 Pasquale Spisto. All rights reserved.
//

import UIKit

class MoodlistCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var moodlist : Moodlist? {
        didSet{
            if let moodlist = moodlist {
                titleLabel.text = moodlist.title
                
            }
        }
        
    }
    
}
