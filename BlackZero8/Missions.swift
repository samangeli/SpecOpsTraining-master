//
//  Missions.swift
//  Out of Sight
//
//  Created by Sam Angeli on 12/02/2015.
//  Copyright (c) 2015 Sam Angeli. All rights reserved.
//

import UIKit
import Foundation

class Mission
{
    var MissionIcon = "blank"
    var MissionTitle = "This could say anything"
    var MissionLevel = "MissionLevel"
    var LockStatus = "blank new"
    
    init(MissionIcon: String, MissionTitle: String, MissionLevel: String, LockStatus: String)
    {
        self.MissionIcon = MissionIcon
        self.MissionTitle = MissionTitle
        self.MissionLevel = MissionLevel
        self.LockStatus = LockStatus
    }

}

