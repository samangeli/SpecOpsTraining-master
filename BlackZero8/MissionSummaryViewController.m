//
//  MissionSummaryViewController.m
//  BlackZero8
//
//  Created by Manjit Bedi on 2014-01-04.
//  Copyright (c) 2014 Manjit Bedi. All rights reserved.
//

#import "MissionSummaryViewController.h"
#import "StateObject.h"
#import "DownloadManager.h"
#import "MenuViewController.h"
#import "MissionViewController.h"
#import "BZAppLogic.h"
#import "Formatter.h"


@interface MissionSummaryViewController ()

@property (weak, nonatomic) StateObject *state;

@end

@implementation MissionSummaryViewController

@synthesize summaryLabel, missionStatus;




- (void)viewDidLoad {
    [super viewDidLoad];
    self.state = [StateObject sharedManager];
    _currentMission = [_state.downloadManager.missions objectAtIndex:_state.missionIndex];
    
    _nameLabel.text = _currentMission.name;
    
    
    summaryLabel.text = _currentMission.desc;
    
    if (_currentMission.completed)
        missionStatus.text = @"Mission Status: Completed";
    else if(_currentMission.lastTime > 0.0)
        missionStatus.text = @"Mission Status: Incomplete";
    else
        missionStatus.text = @"Mission Status: Unlocked";
    
    
    
    [self updateTimeAndDistanceSummaries];

    
}

- (void) updateTimeAndDistanceSummaries {
    // show how long the last mission took to run and its distance
    
    DownloadManager *downloadManager = [[DownloadManager alloc] init];
    
    [downloadManager loadResults];

//    _lastDurationLabel.text = [[Formatter sharedInstance] formattedDurationString: _currentMission.lastTime];
    _lastDistanceLabel.text = [[Formatter sharedInstance] formattedDistanceString: _currentMission.lastDistance];
    _lastSpeedLabel.text = [[Formatter sharedInstance] formattedSpeedString: _currentMission.lastSpeed];
//    _bestDurationLabel.text = [[Formatter sharedInstance] formattedDurationString: _currentMission.bestTime];
    _bestDistanceLabel.text = [[Formatter sharedInstance] formattedDistanceString: _currentMission.bestDistance];
    _bestSpeedLabel.text = [[Formatter sharedInstance] formattedSpeedString: _currentMission.bestSpeed];
        
    
    
}

- (void) viewDidLayoutSubviews {
    // Put the mission summary in the top left of its frame
    summaryLabel.numberOfLines = 0;
    [summaryLabel sizeToFit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_state.pickupsForCurrentRun count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSUInteger identifier = [[_state.pickupsForCurrentRun objectAtIndex:indexPath.row] unsignedIntegerValue];
    NSString *name = [_state nameForPickUpWithId:identifier];
    cell.textLabel.text = name;
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (IBAction)selectMission {

    _state.runState = RunStateReady;
    PSLocationManager *locationManager = [PSLocationManager sharedLocationManager];
    locationManager.delegate = nil;
    
    [self moveToNewViewController:@"mainVC"];
    
}


@end
