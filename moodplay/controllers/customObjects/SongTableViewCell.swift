//
//  SongTableViewCell.swift
//  moodplay
//
//  Created by Pasquale Spisto on 15/12/2017.
//  Copyright © 2017 Pasquale Spisto. All rights reserved.
//

import UIKit

class SongTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var imageViewOutlet: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addToMyMoodlist(_ sender: UIButton) {
    
    }
    

}
