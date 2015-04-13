//
//  HomeViewController.m
//  BlackZero8
//
//  Created by Manjit Bedi on 2014-01-03.
//  Copyright (c) 2014 Manjit Bedi. All rights reserved.
//


#import "constants.h"

#import <Parse/Parse.h>

#import "HomeViewController.h"
#import "MenuViewController.h"
#import "MissionViewController.h"
#import "StateObject.h"
#import "DownloadManager.h"

#import "BZUser.h"

#import "BZMission.h"

@interface HomeViewController ()

@property (weak, nonatomic) StateObject *state;

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    BZUser *currentUser = [BZUser currentUser];
    NSNumber *anonNumber = currentUser[@"anonymous"];
    BOOL anonymousUser;
    
    if(anonNumber)
        anonymousUser = [anonNumber boolValue];
    else
        anonymousUser = YES;
    
    if(currentUser && !anonymousUser) {
        NSString *userName = currentUser[@"username"];
        if(userName)
            _userNameLabel.text = [NSString stringWithFormat:@"Trainee: %@", userName];
    }
    
    self.state = [StateObject sharedManager];
    
    // Ask the state object what is the index of the next mission.
    // If all the missions have been completed - then what?
    _state.missionIndex = [_state getNextMissionIndex];
    


    BZMission *mission = _state.downloadManager.missions[_state.missionIndex];
    [_startButton setTitle: [NSString stringWithFormat:@"START MISSION: %@", mission.name] forState:UIControlStateNormal];
    

    
#ifdef DEBUG
    _debugLabel.hidden = NO;
#endif

    
    PSLocationManager *locationManager = [PSLocationManager sharedLocationManager];
    locationManager.delegate = (id) self;

    
    [locationManager startLocationUpdates];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)startNextMissionAction:(id)sender {
    NSLog(@"Starting Next Mission...");
    PSLocationManager *locationManager = [PSLocationManager sharedLocationManager];
    locationManager.delegate = nil;
    
    _state.runState = RunStateReady;
    
    [self moveToNewViewController:@"summaryVC"];
    
}

- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];

}


#pragma mark -
- (IBAction)recruitAction:(id)sender {
    NSLog(@"Recruiting More Soldiers...");
    
}

    
- (IBAction)downloadMissionsAction:(id)sender {
    NSLog(@"Downloading More Missions...");

}


// Note: if the user is not moving there is no speed set and this delegate will not called.
#pragma mark -
- (void)locationManager:(PSLocationManager *)locationManager distanceUpdated:(CLLocationDistance)distance {
    
#ifdef DEBUG
    _debugLabel.hidden = NO;
    _debugLabel.text = @"Location updated";
#endif
}


- (void)locationManager:(PSLocationManager *)locationManager error:(NSError *)error {
    
#ifdef DEBUG
    _debugLabel.hidden = NO;
    _debugLabel.text = [error localizedDescription];
#endif
}


@end
