//
//  MissionCell.swift
//  Out of Sight
//
//  Created by Sam Angeli on 12/02/2015.
//  Copyright (c) 2015 Sam Angeli. All rights reserved.
//

import UIKit

class MissionCell: UITableViewCell {

    @IBOutlet weak var MissionIcon: UIImageView!
    @IBOutlet weak var MissionTitle: UILabel!
    @IBOutlet weak var MissionLevel: UILabel!
    @IBOutlet weak var LockStatus: UIImageView!
    
    
    
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
    
    
    
    
    func setCell(MissionIconImage: String, MissionTitleLabel: String, MissionLevelLabel: String, LockStatusImage: String)
    {
        self.MissionIcon.image = UIImage(named: MissionIconImage)
        self.MissionTitle.text = String(MissionTitleLabel)
        self.MissionLevel.text = String(MissionLevelLabel)
        self.LockStatus.image = UIImage(named: LockStatusImage)
    }


    

}




