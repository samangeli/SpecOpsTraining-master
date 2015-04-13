//
//  MissionSelectViewController.m
//  BlackZero8
//
//  Created by Manjit Bedi on 2013-12-23.
//  Copyright (c) 2013 Manjit Bedi. All rights reserved.
//

#import "MissionSelectViewController.h"
#import "MissionSelectTableCell.h"
#import "MenuViewController.h"
#import "MissionViewController.h"


#import "StateObject.h"
#import "BZMission.h"
#import "DownloadManager.h"


@interface MissionSelectViewController ()

@property (weak, nonatomic) StateObject *state;

@end

@implementation MissionSelectViewController

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
    [_tableview reloadData];
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
    return [_state.downloadManager.missions count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MissionSelectTableCell";
    MissionSelectTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[MissionSelectTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    // Creating the background view in the storyboard was not working the way I liked...
    BZMission *mission = [_state.downloadManager.missions objectAtIndex:indexPath.row];
    cell.backgroundView = [[UIView alloc] initWithFrame:cell.contentView.frame];
    cell.nameLabel.text = mission.name;
    if(mission.completed)
        cell.statusLabel.text = @"Completed";
    else if(mission.lastTime > 0.0)
        cell.statusLabel.text = @"Incomplete";
    else
        cell.statusLabel.text = @"Ready";
    //cell.artworkImageView.image = [UIImage imageNamed:@"circleImage"];
    cell.missionDetailButton.tag = indexPath.row;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    UIView *backgroundView = cell.backgroundView;
    backgroundView.backgroundColor = [UIColor grayColor];
    backgroundView.layer.cornerRadius = 6.0f;
}



#pragma mark - UITableView Delegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   

    _state.missionIndex = indexPath.row;
    
    
    [self moveToNewViewController:@"summaryVC"];
    
}

#pragma mark -
- (IBAction)downloadMoreMissionsAction:(id)sender {

    
}

@end
