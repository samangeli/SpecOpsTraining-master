//
//  BriefingsViewController.swift
//  Out of Sight
//
//  Created by Sam Angeli on 11/02/2015.
//  Copyright (c) 2015 Sam Angeli. All rights reserved.
//

import UIKit

@objc class BriefingsViewController: UIViewController {
    
    @IBOutlet var missionSummary: UITextView!
    @IBOutlet var missionName: UILabel!
    @IBOutlet var lastSpeed: UILabel!
    @IBOutlet var lastDistance: UILabel!
    @IBOutlet var bestSpeed: UILabel!
    @IBOutlet var bestDistance: UILabel!
    

    
    @IBOutlet var speedUnits: [UILabel]!
    @IBOutlet var distanceUnits: [UILabel]!
    
    
    var currentMission: BZMission = BZMission()
    var settings: AnyObject! = SettingsObject.sharedInstance()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
        
        var state: AnyObject! = StateObject.sharedManager()
        var missionIndex = Int (state.missionIndex)
        var OCmissions = state.downloadManager!.missions
        currentMission = OCmissions!.objectAtIndex(0) as BZMission
        
        
        self.missionName.text = currentMission.name
        self.missionSummary.text = currentMission.desc

        if (settings.useMetric == true) {
            for aLabel in speedUnits {
                aLabel.text = "KMPH"
            }
            for aLabel in distanceUnits {
                aLabel.text = "KM"
            }
        } else {
            for aLabel in speedUnits {
                aLabel.text = "MPH"
            }
            for aLabel in distanceUnits {
                aLabel.text = "MI"
            }
        }
        
        
        self.updateTimeAndDistanceSummaries()
        
    }
    
    
    func updateTimeAndDistanceSummaries() {
        let formatter: AnyObject! = Formatter.sharedInstance()
        
        self.lastSpeed.text = formatter.formattedSpeedString (currentMission.lastSpeed)
        self.lastDistance.text = formatter.formattedDistanceString (currentMission.lastDistance)
        self.bestSpeed.text = formatter.formattedSpeedString (currentMission.bestSpeed)
        self.bestDistance.text = formatter.formattedDistanceString (currentMission.bestDistance)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func MissionView(sender: AnyObject) {
        let MissionView = self.storyboard?.instantiateViewControllerWithIdentifier("TheMission") as
        MissionViewController
        self.navigationController?.pushViewController(MissionView, animated: true)
        
    }
    
    
    
    @IBAction func Back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
