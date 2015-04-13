//
//  PlaylistViewController.swift
//  Out of Sight
//
//  Created by Sam Angeli on 11/02/2015.
//  Copyright (c) 2015 Sam Angeli. All rights reserved.
//

import UIKit


class PlaylistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var state: AnyObject! = StateObject.sharedManager()
    
    @IBOutlet weak var PlaylistTableview: UITableView!
    var arrayOfPlaylists: [Playlist] = [Playlist]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.setUpPlaylists()
        
        // Remove insets and colour from table view
        PlaylistTableview.layoutMargins = UIEdgeInsetsZero
        var cellBackground = UIView (frame: CGRectZero)
        self.PlaylistTableview.tableFooterView = cellBackground
        
        self.PlaylistTableview.backgroundColor = UIColor.clearColor()
        // Do any additional setup after loading the view.
            
            
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // Begin Mission setup
    
    func setUpPlaylists()
    {

        var myPlaylists = state.listPlaylists()
        var Playlist1: Playlist
        
        for aPlaylist in myPlaylists! {
            Playlist1 = Playlist(PlaylistIcon: "icon_musicnotes.png", PlaylistTitle: aPlaylist.valueForProperty(MPMediaPlaylistPropertyName) as NSString, PlaylistLabel: "\(aPlaylist.count) SONGS")
       
            arrayOfPlaylists.append(Playlist1)
        
        }
        

        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrayOfPlaylists.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
        
    {
        

        
        //let cell:PlaylistCell = tableView.dequeueReusableCellWithIdentifier("Cell") as PlaylistCell
        let cell:PlaylistCell = tableView.dequeueReusableCellWithIdentifier("Cell") as PlaylistCell
        
        
        let playlist = arrayOfPlaylists[indexPath.row]
        
        cell.setCell(playlist.PlaylistIcon, PlaylistTitle: playlist.PlaylistTitle, PlaylistLabel: playlist.PlaylistLabel)
        
        // Style Cells
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.backgroundColor = UIColor.clearColor()
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorColor = UIColor(red: (105/255), green: (107/255), blue: (115/255), alpha: 0.2)
        
        return cell
    }


    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        
       
        let myPlaylists = state.listPlaylists()
        let thePlaylist: MPMediaPlaylist = myPlaylists[indexPath.row] as MPMediaPlaylist
        BZMissionAudio().changePlaylist(thePlaylist)
        
        
        
        let MissionView = self.storyboard?.instantiateViewControllerWithIdentifier("TheMission") as
        MissionViewController
        self.navigationController?.pushViewController(MissionView, animated: true)
        

        
    }
    
    
    @IBAction func Back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }    

}
