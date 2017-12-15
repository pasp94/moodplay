//
//  PlayShuffleViewCell.swift
//  moodplay
//
//  Created by Pasquale Spisto on 15/12/2017.
//  Copyright © 2017 Pasquale Spisto. All rights reserved.
//

import UIKit

class PlayShuffleViewCell: UITableViewCell {

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func playMoodlist(_ sender: UIButton) {
    }
    
    @IBAction func randomizePlay(_ sender: UIButton) {
    }
}
