//
//  MissionsViewController.swift
//  Out of Sight
//
//  Created by Sam Angeli on 11/02/2015.
//  Copyright (c) 2015 Sam Angeli. All rights reserved.
//

import UIKit

class MissionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var MissionTableView: UITableView!
    var arrayOfMissions: [Mission] = [Mission]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpMissions()
        
        // Remove insets and colour from table view
        MissionTableView.layoutMargins = UIEdgeInsetsZero
        var cellBackground = UIView (frame: CGRectZero)
        self.MissionTableView.tableFooterView = cellBackground
        
        self.MissionTableView.backgroundColor = UIColor.clearColor()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func Main(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
 
    // Begin Mission setup
    
    func setUpMissions()
    {
        var Mission1 = Mission(MissionIcon: "MissionIconActive.png", MissionTitle: "WELCOME TO THE JUNGLE", MissionLevel: "BEGINNER, 60 MINS", LockStatus: "LockOpen.png")

        arrayOfMissions.append(Mission1)

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrayOfMissions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
        
    {
        let cell:MissionCell = tableView.dequeueReusableCellWithIdentifier("Cell") as MissionCell
        let mission = arrayOfMissions[indexPath.row]
        
        cell.setCell(mission.MissionIcon, MissionTitleLabel: mission.MissionTitle, MissionLevelLabel: mission.MissionLevel, LockStatusImage: mission.LockStatus)
        

        
        // Style Cells
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.backgroundColor = UIColor.clearColor()
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorColor = UIColor(red: (105/255), green: (107/255), blue: (115/255), alpha: 0.2)
        
        return cell
    }


    @IBAction func unwindToMissionsView(sender: UIStoryboardSegue){
        let sourceViewController: AnyObject = sender.sourceViewController
        // Pull any data from the view controller which initiated the unwind segue.
    }


}
