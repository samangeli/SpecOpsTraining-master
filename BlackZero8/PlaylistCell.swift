//
//  PlaylistCell.swift
//  Out of Sight
//
//  Created by Sam Angeli on 04/03/2015.
//  Copyright (c) 2015 Sam Angeli. All rights reserved.
//

import UIKit

class PlaylistCell: UITableViewCell {
    


    @IBOutlet weak var PlaylistIcon: UIImageView!
    @IBOutlet weak var PlaylistTitle: UILabel!
    @IBOutlet weak var PlaylistLabel: UILabel!
    
    
    override var highlighted: Bool {
        get {
            return super.highlighted
        }
        set {
            if newValue {
                backgroundColor = UIColor(red: (255/255), green: (255/255), blue: (255/255), alpha: 0)
            }
            else {
                backgroundColor = UIColor(red: (255/255), green: (255/255), blue: (255/255), alpha: 0)
            }
            super.highlighted = newValue
        }
    }
    
    
    
    
    func setCell(PlaylistIconImage: String, PlaylistTitle: String, PlaylistLabel: String)
    {
        self.PlaylistIcon.image = UIImage(named: PlaylistIconImage)
        self.PlaylistTitle.text = String(PlaylistTitle)
        self.PlaylistLabel.text = String(PlaylistLabel)

    }
    
    
    
    
}

