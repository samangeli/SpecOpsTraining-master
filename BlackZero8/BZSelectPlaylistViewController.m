//
//  BZSelectPlaylistViewController.m
//  BlackZero8
//
//  Created by Piers Beckley on 15/05/2014.
//  Copyright (c) 2014 Manjit Bedi. All rights reserved.
//

#import "BZSelectPlaylistViewController.h"
#import "MissionSelectTableCell.h"
#import "MenuViewController.h"
#import "StateObject.h"
#import "BZMissionAudio.h"

#import <MediaPlayer/MediaPlayer.h>

@interface BZSelectPlaylistViewController ()

@property (weak, nonatomic) StateObject *state;

@end


@implementation BZSelectPlaylistViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.state = [StateObject sharedManager];
//    [_tableview reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableView Datasource
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 3.0f;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_state listPlaylists] count]; // The number of playlists in the user's phone
}


- (UITableViewCell *)tableViw:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MissionSelectTableCell";
    MissionSelectTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[MissionSelectTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
   
    cell.backgroundView = [[UIView alloc] initWithFrame:cell.contentView.frame];
    
    // Set the text for each cell to the name of the relevant playlist in the list of playlists
    cell.nameLabel.text = [[[_state listPlaylists] objectAtIndex:indexPath.row] valueForProperty: MPMediaPlaylistPropertyName] ;

    cell.missionDetailButton.tag = indexPath.row;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    UIView *backgroundView = cell.backgroundView;
    backgroundView.backgroundColor = [UIColor grayColor];
    backgroundView.layer.cornerRadius = 6.0f;
}



#pragma mark - UITableView Delegate methods

//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    // choose a new playlist
//    
//    
//    MPMediaPlaylist *aPlaylist = [[_state listPlaylists] objectAtIndex:indexPath.row];
//    
//    [BZMissionAudio changePlaylist:aPlaylist];
//    
//    
//    //if we've come from a mission that's been paused or no mission has been selected, return to the menu after selecting a playlist
//    
//    if (_state.runState == RunStatePaused) {
//        [self showMenuAction:nil];
//        
//        // if that's not the case, we must have been dropped here from a mission start, because no playlist was selected; so return to the mission as soon as one has been
//        
//    } else {
//        [self moveToNewViewController:@"mainVC"];
//    }
//}



@end

