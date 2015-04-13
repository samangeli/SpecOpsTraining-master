//
//  BZAppLogic.m
//  BlackZero8
//
//  Created by Manjit Bedi on 2014-04-04.
//  Copyright (c) 2014 Manjit Bedi. All rights reserved.
//

#import <MapKit/MKGeometry.h>

#import "BZUser.h"
#import "BZAppLogic.h"
#import "DownloadManager.h"
#import "BZMission.h"
#import "Event.h"
#import "PickUp.h"
#import <MediaPlayer/MediaPlayer.h>


@interface  BZAppLogic ()

@property (strong, nonatomic) PFObject *currentRun;
@property NSUInteger eventIndex;
@property BOOL eventsAreFinished;
@property (weak, nonatomic) StateObject *state;

@end

@implementation BZAppLogic

+ (id)sharedInstance {
    static BZAppLogic *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}


- (id)init {
    if (self = [super init]) {

        self.state = [StateObject sharedManager];
        self.locationManager = [PSLocationManager sharedLocationManager];
        _locationManager.delegate = self;
        _state.currentEventIndex = 0;
        _startTime = 0.0;
        _startDistance = 0.0;
    }
    return self;
}


- (void) startUpdating {
    [_locationManager startLocationUpdates];
}


- (void) endUpdating {
    [_locationManager stopLocationUpdates];
}


- (void) setMission:(BZMission *) mission {
    self.currentMission = mission;
}


// Using the data from the last save of the mission resume from that point.
// The 2 details being the distance and duration.
- (void) continueMission {
   _startTime = _currentMission.lastTime;
   _startDistance = _currentMission.lastDistance;
    [self resumeRun];

    
    
}



- (void) newRun {
    // set up a new run with the location manager, and start calling the update method

    [_locationManager resetLocationUpdates];
    [_locationManager startLocationUpdates];
    
    [_state.missionPlaylist removeAllObjects]; // make sure there's nothing kicking around in the mission playlist

    
    _geoCoordinates = nil;
    self.geoCoordinates = [[NSMutableArray alloc] init];
    
    _eventsAreFinished = NO;
    
    PFUser *user = [PFUser currentUser];
    
    PFObject *newRun = [PFObject objectWithClassName:@"Run"];
    newRun[@"points"] = @0;
    newRun[@"startTime"] = [NSDate date];
    newRun[@"missioName"] = _currentMission.name;
    [newRun setObject:user forKey:@"parent"];
    [newRun saveInBackgroundWithBlock:^(BOOL succeded, NSError *error){
        if(succeded) {
            PFRelation *relation = [user relationforKey:@"Runs"];
            [relation addObject:newRun];
            [user saveInBackground];
        }else if( error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
    
    self.currentRun = newRun;
    
    
    [self startUpdating];
    [self performSelector:@selector(update) withObject:nil afterDelay:0.1];
}



- (void) endRun:(BOOL) completedRun {
    // closes down the run as complete
    // completedRun is TRUE if the mission was completed and FALSE if the user cancelled the run
    
    

    NSTimeInterval totalTimeForMission = _startTime + [self getMissionTime];
    CGFloat totalDistanceForMission = _startDistance + _locationManager.totalDistance;
    CGFloat totalSpeedForMission = totalDistanceForMission / totalTimeForMission;
    
    NSLog(@"run ended, distance %f, duration %f, speed %f", totalDistanceForMission, totalTimeForMission, totalSpeedForMission);
    
    BZUser *user = [BZUser currentUser];
    _currentRun[@"endTime"] = [NSDate date];
    _currentRun[@"time"] = [NSNumber numberWithUnsignedInteger:totalTimeForMission];
    _currentRun[@"distance"] = [NSNumber numberWithDouble:totalDistanceForMission];
    
    _state.runState = RunStateFinished;
    _currentMission.completed = completedRun;
    
    NSTimeInterval bestTime = _currentMission.bestTime;
    CGFloat bestDistance = _currentMission.bestDistance;
    CGFloat bestSpeed = _currentMission.bestSpeed;
    
    if (bestTime == 0 || totalTimeForMission < bestTime) bestTime = totalTimeForMission;
    if (bestDistance == 0 || totalDistanceForMission > bestDistance) bestDistance = totalDistanceForMission;
    if (bestSpeed == 0 || totalSpeedForMission > bestSpeed) bestSpeed = totalSpeedForMission;
    

    _currentMission.lastTime = totalTimeForMission;
    _currentMission.lastDistance =  totalDistanceForMission;
    _currentMission.bestTime = bestTime;
    _currentMission.bestDistance = bestDistance;
    _currentMission.lastSpeed = totalSpeedForMission;
    _currentMission.bestSpeed = bestSpeed;
    
    
    [_currentRun saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if( error != nil)
             NSLog(@"%@", [error localizedDescription]);
     }];
    _currentRun = nil;
    
    // Fetch the mission object if it exists for the current user.
    __block PFObject *missionObj = nil;
    
    PFQuery *query = [PFQuery queryWithClassName:@"Mission"];
    [query whereKey:@"mission.parent" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                if([object[@"name"] isEqualToString:_currentMission.name])
                    missionObj = object;
            }
        } else
            NSLog(@"Error: %@ %@", error, [error userInfo]);
    }];

    // If the mission has not been run before and created, create it now.
    if(missionObj == nil) {
        missionObj = [PFObject objectWithClassName:@"Mission"];
        missionObj[@"name"] = _currentMission.name;
        [missionObj setObject:user forKey:@"parent"];
        missionObj[@"completed"] = [NSNumber numberWithBool:completedRun];
    } else {
        // If the current run was not completed but the previous one was don't overwrite the value.
        NSNumber *completedNum = missionObj[@"completed"];
        if(completedNum && [completedNum boolValue] == NO && completedRun == YES)
            missionObj[@"completed"] = [NSNumber numberWithBool:YES];
    }
    
    [missionObj saveInBackgroundWithBlock:^(BOOL succeded, NSError *error){
         if(succeded) {
             PFRelation *relation = [user relationforKey:@"Missions"];
             [relation addObject:missionObj];
             [user saveInBackground];
         }else if( error != nil) {
             NSLog(@"%@", [error localizedDescription]);
         }
     }];
    
    // Save the data locally to a plist
    [[DownloadManager sharedManager] saveResults];

}


- (void) pauseRun {
    [_locationManager stopLocationUpdates];
    

}


-(void) resumeRun {
    // other than newRun, this is the other place the update selector gets kicked off from
    
    
    [_locationManager startLocationUpdates];
    [self performSelector:@selector(update) withObject:nil afterDelay:0.1];
    

    
}

- (void)refillEventsFileForCurrentMission {
    // then re-fill the currentMission events file with events from its data file
    // this is a bit hacky, but should at least solve the bug of only being able to complete a mission once
    
    NSError *error;
    NSString *filePathStr = [_currentMission.subfolderName stringByAppendingString:@"/mission.json"];
    NSData *data = [NSData dataWithContentsOfFile:filePathStr options:NSDataReadingMappedIfSafe error:&error];
    if(error) {
        NSLog(@"%@", [error localizedDescription]);
    } else {
        [_currentMission.events removeAllObjects];
        [_currentMission processDataForMission:data];
    }
}


#pragma mark -
- (void) update {
    
    if (_state.runState != RunStateRunning)
        return;
    
    

//    if(![_currentMission.events count]) {   // if there are no more events left, the mission is over
  
    if ([_currentMission.events count] == 21) { // shorten missions for debugging
    
    
        [self endRun:YES];
        
        if(_delegate && [_delegate respondsToSelector:@selector(runCompleted:)])
            [_delegate runCompleted:self];
        
    }
    
    
    if(_delegate && [_delegate respondsToSelector:@selector(updateDisplay:)])
        [_delegate updateDisplay:self];
    
    [self performSelector:@selector(update) withObject:nil afterDelay:1];
        //are we just recursing infinitely down our own loop here? would nsnotificationcentre do a better job?
    
}


- (NSTimeInterval) getMissionTime {
    // returns the total time spent so far on the current mission
    
    if (_state.runState == RunStatePaused)                  // if we're paused then return the saved value
        return _missionTime;
    else if (_state.runState == RunStateReady)              // if we haven't started it must be 0
        return 0;
    else
        return _startTime + _locationManager.totalSeconds;  // otherwise we must be running, so return where we started + how long we've run
}

- (CGFloat) getMissionDistance {
    return _startDistance + _locationManager.totalDistance;
}

- (CGFloat) getMissionSpeed {
    
    if (self.getMissionTime > 0 ) {
        return self.getMissionDistance / self.getMissionTime;
    } else {
        return 0;
    }
}



#pragma mark - Location manager delegate methods
- (void) locationManager:(PSLocationManager *)locationManager waypoint:(CLLocation *)waypoint calculatedSpeed:(double)calculatedSpeed {
    
    if (_state.runState != RunStateRunning)
        return;
    
    NSValue *value = [NSValue valueWithMKCoordinate:waypoint.coordinate];
    [_geoCoordinates addObject:value];
}


- (void)locationManager:(PSLocationManager *)locationManager error:(NSError *)error {

    NSLog(@"%@", [error localizedDescription]);
}

- (void) locationManager:(PSLocationManager *)locationManager didFailWithError:(NSError *)error {
    NSLog(@"here");
}


@end
