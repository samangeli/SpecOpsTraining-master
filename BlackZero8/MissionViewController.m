//
//  MissionViewController.m
//  BlackZero8
//
//  Created by Manjit Bedi on 2013-12-23.
//  Copyright (c) 2013 Manjit Bedi. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>


#import "NSString+CLLocationCoordinate2D.h"

#import "constants.h"
#import "MenuViewController.h"
#import "MissionViewController.h"
#import "MissionSummaryViewController.h"
#import "DownloadManager.h"

#import "BlackZero8-swift.h"

#import "StateObject.h"
#import "SettingsObject.h"

#import "Formatter.h"


#import "BZAppLogic.h"

#import "BZMission.h"
#import "Event.h"
#import "PickUp.h"

#import "BZMissionAudio.h"

@interface  MissionViewController ()  {
    
    CLLocationCoordinate2D previousLineCoords[2];
}

@property (strong, nonatomic) MKPolylineView *overlayView;
@property (weak, nonatomic) StateObject *state;
@property (weak, nonatomic) SettingsObject *settings;
@property (strong, nonatomic) NSMutableArray *mapAnnotations;
@property (strong, nonatomic) AVSpeechSynthesizer *synth;
@property (weak, nonatomic) BZAppLogic *appLogic;
@property (strong, nonatomic) MKPolyline *routeLine;
@property BOOL promptResumeRun;
@property BOOL resumeMission;
@property (weak, nonatomic) MPMediaPlaylist *currentPlaylist;
@property (strong, nonatomic) BZMissionAudio *missionAudio;
@property BOOL interruptedOnPlayback;



- (void) makeTheEarthGreenWithAPolygon;
- (void) plotMapLastLineSegment;
- (void) plotMap;
- (BOOL) locationServicesAreSwitchedOff;
@end

@implementation MissionViewController

@synthesize speedUnitsLabel, distanceUnitsLabel;


- (void) viewDidLoad {
    [super viewDidLoad];
    
    // set or create the state and applogic
    
    self.state = [StateObject sharedManager];
    self.appLogic = [BZAppLogic sharedInstance];
    self.settings = [SettingsObject sharedInstance];
    
    
    // check which mission we're on and set it
    _currentMission = _state.downloadManager.missions[_state.missionIndex];
    
    // make sure audio can continue to play in background
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    NSError *setCategoryError = nil;
    BOOL success = [audioSession setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
    if (!success) NSLog(@"Error setting category for avplayer: %@", setCategoryError);
    
    NSError *activationError = nil;
    success = [audioSession setActive:YES error:&activationError];
    if (!success) NSLog(@"Error activating avplayer: %@", activationError);
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(audioPlayerInterruption:)
                                                 name: AVAudioSessionInterruptionNotification
                                               object: audioSession];

    
    // if we're on iOS 8, check for authorisation

    #ifdef __IPHONE_8_0
        if(IS_OS_8_OR_LATER) {
            // Use one or the other, not both. Depending on what you put in info.plist
            [[PSLocationManager sharedLocationManager].locationManager requestAlwaysAuthorization];
        }
    #endif
        
      
    if(_currentMission == nil && _appLogic.currentMission != nil) {
        _currentMission = _appLogic.currentMission;
    } else {
        [_appLogic setMission:_currentMission];
    }
    
    if(_state.runState == RunStateRunning || _state.runState == RunStatePaused)
        [_startPauseButton setTitle:@"PAUSE" forState:UIControlStateNormal];
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@", _currentMission.name];
    
    _mapview.showsUserLocation = YES;
    [self makeTheEarthGreenWithAPolygon];
    
    // This gets used if there is no audio file for a pickup object.
    self.synth = [[AVSpeechSynthesizer alloc] init];
    
    // pull through the current info for distance and time
    _distanceLabel.text = [[Formatter sharedInstance] formattedDistanceString: _currentMission.lastDistance];
    _durationLabel.text = [[Formatter sharedInstance] formattedDurationString: _currentMission.lastTime];
    
    // sort the units
    
    if (_settings.useMetric == true) {
        speedUnitsLabel.text = @"KMPH";
        distanceUnitsLabel.text = @"KM";
    } else {
        speedUnitsLabel.text = @"MPH";
        distanceUnitsLabel.text = @"MI";
    }
    
    
}



- (BOOL)canBecomeFirstResponder {
    // to receive audio controls while in BG
    return YES;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    
    if (_state.runState == RunStatePaused) {
        _startPauseButton.hidden = YES;
        _endRunButton.hidden = NO;
        _resumeRunButton.hidden = NO;
        _state.runState = RunStatePaused;
        _mapview.userTrackingMode = MKUserTrackingModeNone;
        
    }
    
    
    if(_state.runState == RunStateReady) {
        
        // test that a) we're in an already started mission and that b) it isn't finished.
        // c) prevents the alertbox firing twice if a playlist hasn't been selected
        if(_currentMission.lastTime != 0 &&_currentMission.completed == NO && _state.selectedPlaylist) {
        _promptResumeRun = YES;
        _state.runState = RunStatePaused;
        NSString *messageStr = NSLocalizedString(@"Resume the incomplete mission?", "alert view prompt");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:messageStr delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Resume", nil];
        [alert show];
        }
        
    }
    
    if(_state.runState == RunStateRunning)
        _mapview.userTrackingMode = MKUserTrackingModeFollow;
    
    Formatter *formatter = [Formatter sharedInstance];
    _unitsLabel.text = [formatter displayUnits];
    
    if(_state.runState == RunStateRunning || _state.runState == RunStatePaused) {
        _appLogic.delegate = (id) self;
        [self resumeRun];
    }
    
    
    
    // so audio continues playing in background when iPhone locks
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        switch (receivedEvent.subtype) {
            case UIEventSubtypeRemoteControlPause:
                [self startPauseAction:nil];
                break;
            case UIEventSubtypeRemoteControlPlay:
                [self resumeAction:nil];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                [_audioPlayer seekToTime:kCMTimeZero];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                [_audioPlayer advanceToNextItem];
                break;
            default:
                break;
        }
    }
}


#pragma mark -


- (BOOL) locationServicesAreSwitchedOff {
    // so we alert the user, and feed back the information
    
    if ([CLLocationManager authorizationStatus] == 2 ) { // user has turned Location Services off
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Services must be enabled"
                                                        message:@"To use the Out of Sight app, please enable Location Services in Settings."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        return TRUE;
        
    }
    else {
        return FALSE;
    }
}

- (IBAction)missionStartOrPause:(id)sender {
    // this is our main mission button
    
   
    if(_state.runState == RunStateReady || _state.runState == RunStateFinished) {
        
        // then we are at the start page, so the button needs to start a mission
        
        
        [self startMission];
        
    } else if(_state.runState == RunStateRunning){
        // then we're already in a mission, so the button needs to pause it
        
        [self startPauseAction:sender];
    } else if (_state.runState == RunStatePaused) {
        // then we're in a mission that has been paused, so the button needs to resume it
        
        [self resumeAction:(id) sender];
    }

}

- (IBAction)showMenuAction:(id)sender {
    
    _appLogic.delegate = nil;
  
    
    if (_state.runState == RunStateRunning) {
        //if we're in the middle of a mission, pause it
        [self startPauseAction: sender];
        [[self navigationController] popViewControllerAnimated:true];
        
    }
    
    if (_state.runState == RunStateFinished) {

        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass: [BriefingsViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }



    
}

- (IBAction)startMission {
    
    
    
    //begin debug test
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *bundleURL = [[NSBundle mainBundle] bundleURL];
    NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtURL:bundleURL
                                          includingPropertiesForKeys:@[NSURLNameKey, NSURLIsDirectoryKey]
                                                             options:NSDirectoryEnumerationSkipsHiddenFiles
                                                        errorHandler:^BOOL(NSURL *url, NSError *error)
                                         {
                                             if (error) {
                                                 NSLog(@"[Error] %@ (%@)", error, url);
                                                 return NO;
                                             }
                                             
                                             return YES;
                                         }];
    
    NSMutableArray *mutableFileURLs = [NSMutableArray array];
    for (NSURL *fileURL in enumerator) {
        NSString *filename;
        [fileURL getResourceValue:&filename forKey:NSURLNameKey error:nil];
        
        NSNumber *isDirectory;
        [fileURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:nil];
        
        // Skip directories with '_' prefix, for example
        if ([filename hasPrefix:@"_"] && [isDirectory boolValue]) {
            [enumerator skipDescendants];
            continue;
        }
        
        if (![isDirectory boolValue]) {
            [mutableFileURLs addObject:fileURL];
        }
    }
    
//    NSLog(@"%@", mutableFileURLs);
    
    //end debug test
    
    
    // called whenever a mission is started or resumed
    
    if ([self locationServicesAreSwitchedOff])  // if user has turned Location Services off, don't start
        return;

    #if !(TARGET_IPHONE_SIMULATOR)
    
    
        // get current playlist; set it if it doesn't already exist
        
        _currentPlaylist = [_state selectedPlaylist];
        
        if (!_currentPlaylist) {
            // if there's no playlist and we're not on a simulator
            // then pop open the Select Playlist VC and choose one

            [self moveToNewViewController:@"PlaylistView"];
            
            return;
        }
        
        NSLog(@"Currently selected playlist is : %@", [_currentPlaylist valueForProperty:MPMediaPlaylistPropertyName]);
        
        NSMutableArray *missionEvents;
        _missionAudio = [[BZMissionAudio alloc] init];
        
        missionEvents = [_missionAudio createUpcomingEvents:_currentPlaylist];
        
        _audioPlayer = [AVQueuePlayer queuePlayerWithItems: missionEvents];
        
        [_startPauseButton setTitle:@"PAUSE" forState:UIControlStateNormal];
        _state.runState = RunStateRunning;
        
        
        _appLogic.delegate = (id) self;
        
        
        // Reset UI
        [self removeRouteLines];
        _mapAnnotations = nil;
        
        // Set UI for a new run
        self.mapAnnotations = [[NSMutableArray alloc] init];
        _missionCompleteView.hidden = YES;
        _mapview.userTrackingMode = MKUserTrackingModeFollow;
        [_startPauseButton setTitle:@"PAUSE" forState:UIControlStateNormal];
        
        [_appLogic newRun]; 
        
        [_audioPlayer play];

    #else
    
    
    NSLog(@"No playlist; we're on a simulator");
    
    NSMutableArray *missionEvents;
    _missionAudio = [[BZMissionAudio alloc] init];
    
    missionEvents = [_missionAudio createUpcomingEvents:nil];
    
    _audioPlayer = [AVQueuePlayer queuePlayerWithItems: missionEvents];
    
    [_startPauseButton setTitle:@"PAUSE" forState:UIControlStateNormal];
    _state.runState = RunStateRunning;
    
    
    _appLogic.delegate = (id) self;
    
    
    // Reset UI
    [self removeRouteLines];
    _mapAnnotations = nil;
    
    // Set UI for a new run
    self.mapAnnotations = [[NSMutableArray alloc] init];
    _missionCompleteView.hidden = YES;
    _mapview.userTrackingMode = MKUserTrackingModeFollow;
    [_startPauseButton setTitle:@"PAUSE" forState:UIControlStateNormal];
    
    [_appLogic newRun];
    
    [_audioPlayer play];

    #endif
    

}





- (IBAction)startPauseAction:(id)sender {
    
    
    _startPauseButton.hidden = YES;
    _endRunButton.hidden = NO;
    _resumeRunButton.hidden = NO;
    _mapview.userTrackingMode = MKUserTrackingModeNone;
    
    _state.runState = RunStatePaused;
    
    // save the time when the button was tapped by the user
    _appLogic.missionTime = _appLogic.locationManager.totalSeconds;
    NSLog(@"mission time %f", _appLogic.missionTime);
    NSLog(@"mission distance %f", _appLogic.locationManager.totalDistance);
    
    
    if(_audioPlayer) {
        // if we have an audio player, pause it and save the unplayed items in the queue as AVassets
        [_audioPlayer pause];
        NSArray *missionAVPlayerItems = [_audioPlayer items];
        NSMutableArray *missionAVAssets = [NSMutableArray array];
        
        for (AVPlayerItem *eachItem in missionAVPlayerItems) {
            [missionAVAssets addObject: [eachItem asset]];
        }
        
        _state.missionPlaylist = missionAVAssets;
    }
    
    [_appLogic pauseRun];
    
}


- (IBAction)endAction:(id)sender {
    
    // runState must be Paused for this to be called...
 
    if (_state.runState == RunStateRunning || _state.runState == RunStatePaused) {
        
        NSString *str = NSLocalizedString(@"End Run?", @"End the current run");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:str delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"End Run", nil];
        
        alert.delegate = self;
        [alert show];
        
        
    }
}


- (IBAction)resumeAction:(id)sender {
    //  called when the resume button is pressed while app is paused during a run;
    // not called from the "resume run?" alert if the user has gone to the menu
    
    
    if ([self locationServicesAreSwitchedOff])  // if user has turned Location Services off, don't start
        return;
    
    if(_state.runState == RunStatePaused){
        
        _resumeRunButton.hidden = YES;
        _endRunButton.hidden = YES;
        _startPauseButton.hidden = NO;
        _state.runState = RunStateRunning;
        _mapview.userTrackingMode = MKUserTrackingModeFollow;
        
        
        if(_audioPlayer)
            [_audioPlayer play];
        
        [_appLogic resumeRun];
    }
}


#pragma mark -
- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    NSLog(@"ERROR %@ (most likely Location Services are switched off)", [error localizedDescription]);
}


// Add a filled polygon to the map to tint the colour to green.
- (void) makeTheEarthGreenWithAPolygon {
    // Is this dumb setting the co-ordinates to the entire world?
    MKMapPoint points[5];
    points[0].x = MKMapRectWorld.origin.x;
    points[0].y = MKMapRectWorld.origin.y;
    points[1].x = MKMapRectWorld.origin.x + MKMapRectWorld.size.width;
    points[1].y = MKMapRectWorld.origin.y;
    points[2].x = MKMapRectWorld.origin.x + MKMapRectWorld.size.width;
    points[2].y = MKMapRectWorld.origin.y + MKMapRectWorld.size.height;
    points[3].x = MKMapRectWorld.origin.x;
    points[3].y = MKMapRectWorld.origin.y + MKMapRectWorld.size.height;
    MKPolygon *polygon = [MKPolygon polygonWithPoints:points count:4];
    [self.mapview addOverlay:polygon];
}

// TODO: make this work more efficiently
- (void) plotMapLastLineSegment {
    NSMutableArray *geoCoordinates = _appLogic.geoCoordinates;
    NSUInteger numOfPoints = [geoCoordinates count];
    if(numOfPoints < 2)
        return;
    
    // Only draw the last line segment
    CLLocationCoordinate2D locations[2];
    NSValue *value = geoCoordinates[numOfPoints -2];
    CLLocationCoordinate2D coordinate = [value MKCoordinateValue];
    locations[0] = coordinate;
    
    value = geoCoordinates[numOfPoints -1];
    coordinate = [value MKCoordinateValue];
    locations[1] = coordinate;
    
    if(locations[0].longitude == previousLineCoords[0].longitude && locations[0].latitude == previousLineCoords[0].latitude
       && locations[1].longitude == previousLineCoords[1].longitude && locations[1].latitude == previousLineCoords[1].latitude )
        return;
    
    previousLineCoords[0] = locations[0];
    previousLineCoords[1] = locations[1];
    
#ifdef DEBUG
    if(numOfPoints == 2 ) {
        NSLog(@"2 maps points pt1 %@ to pt2 %@", [NSString NSStringFromCLLocationCoordinate2D:locations[0]], [NSString NSStringFromCLLocationCoordinate2D:locations[1]]);
    } else if (numOfPoints == 100)
        NSLog(@"100 maps points");
    else if (numOfPoints == 200)
        NSLog(@"200 maps points");
#endif
    self.routeLine = [MKPolyline polylineWithCoordinates:locations count:2];
    // Add overlay to map.
    [_mapview addOverlay:_routeLine];
}

- (void) plotMap {
    NSMutableArray *geoCoordinates = _appLogic.geoCoordinates;
    NSUInteger numOfPoints = [geoCoordinates count];
    if(numOfPoints < 2)
        return;
    
    CLLocationCoordinate2D *locations = malloc(sizeof(CLLocationCoordinate2D) * numOfPoints);
    int count = 0;
    for (int i = 0; i < numOfPoints; i++) {
        NSValue *value = [geoCoordinates objectAtIndex:i];
        CLLocationCoordinate2D point = [value MKCoordinateValue];
        locations[count] = point;
        count++;
    }
    // Create the polyline based on the array of points.
    MKPolyline *routeLine = [MKPolyline polylineWithCoordinates:locations count:numOfPoints];
    // Add overlay to map.
    [_mapview addOverlay:routeLine];
    
    free(locations);

}


// Remove everything except the green polygon covering the world
- (void) removeRouteLines {
    for (id<MKOverlay> overlayToRemove in _mapview.overlays) {
        if (![overlayToRemove isKindOfClass:[MKPolygon class]]){
            [_mapview removeOverlay:overlayToRemove];
        }
    }
}



- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:MKPolygon.class]) {
        MKPolygonRenderer *renderer = [[MKPolygonRenderer alloc] initWithOverlay:overlay];
        renderer.strokeColor = [UIColor clearColor];
        renderer.fillColor = [UIColor colorWithRed:0.0 green:0.3 blue:0.0 alpha:0.3];
        return renderer;
    } else {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        renderer.lineWidth = 5.0;
        renderer.strokeColor = [UIColor colorWithRed:251.0/255.0 green:87.0/255.0 blue:50.0/255.0 alpha:1.0];
        return renderer;
    }
}



- (void) resumeRun {
    // appears to only be called when view is loaded
    // looks like it basically updates the display with the saved data, both map and time/distance
    // so this would probably be the place to check for the event queue and playlist...
    // so how does this interface with [_appLogic resumeRun], called from pause on screen?
    
    if (_state.missionPlaylist == nil) {
        NSLog(@"The mission playlist is empty right now");
        NSLog(@"The current playlist is %@", [_state.selectedPlaylist valueForProperty:MPMediaPlaylistPropertyName]);
        
        
        _missionAudio = [[BZMissionAudio alloc] init];
        
        
        // we have to create a new audioplayer because the MVC is created anew from the menu each time - so our previous one has been deallocated
        
        NSMutableArray *upcomingEvents = [_missionAudio createUpcomingEvents: _state.selectedPlaylist];
        
        _audioPlayer = [AVQueuePlayer queuePlayerWithItems: upcomingEvents];
        
        // OK! looking better, but we're resetting to the beginning of the queue rather than saving off the events list.
        
        
        
        
    }
    
    
    
    self.mapAnnotations = [[NSMutableArray alloc] init];
    _appLogic.delegate = (id) self;
    [self updateDisplay:_appLogic];
    [self plotMap];
}


// Update the views objects
#pragma mark - app logic delegate methods
- (void) updateDisplay:(BZAppLogic *) appLogic {

    // Plot the route taken by the runner
    [self plotMapLastLineSegment];
    
    // is missionTime defined here only if paused? can we test
    
    NSTimeInterval missionTime = [_appLogic getMissionTime];

    _distanceLabel.text = [[Formatter sharedInstance] formattedDistanceString:[_appLogic getMissionDistance]];
    _durationLabel.text = [[Formatter sharedInstance] formattedDurationString:missionTime];
    _speedLabel.text = [[Formatter sharedInstance] formattedSpeedString: [_appLogic getMissionSpeed]];
    
    
}




- (void) runCompleted:(BZAppLogic *) appLogic {
    // Pull up a mission complete overview, kill the audio, and scrub the  mission events array and playlists so they can be filled with the next mission.
    // Probably needs to be renamed to missionCompleted now that missions and runs are separate things...
    
    // how does this relate to [applogic runcomplete] and [MVC endrun] ????
    
    if (_currentMission.completed) {
        _missionStatus.text = @"Mission Completed"; // tell them so
        
        // and then clear the slate

        _state.missionPlaylist = nil;
        
        
        [_appLogic refillEventsFileForCurrentMission];

        
    } else {
        _missionStatus.text = @"Run Completed";
    }

    
    _missionCompleteView.hidden = NO;
    _startPauseButton.hidden = YES;
    
    [_audioPlayer pause];
    _audioPlayer = nil;
    
    
    
}




#pragma mark - audio player delegate

- (void) audioPlayerInterruption: (NSNotification *) notification {
    NSLog(@"Beginning Interruption");
    
    if ([[[notification userInfo] objectForKey: AVAudioSessionInterruptionTypeKey] intValue] == AVAudioSessionInterruptionTypeBegan) {
        
        if (_state.runState == RunStateRunning) {
            // if the interruption notification is a begin interruption, we've probably got a phone call; pause the app.
            
            _interruptedOnPlayback = YES;
            [self startPauseAction: nil];
        }
        
    } else {
        // otherwise, it must be an end interruption; so resume the mission
        
        
        NSLog(@"Ending Interruption");
        
        if (_interruptedOnPlayback) {
            _interruptedOnPlayback = NO;
            [self resumeAction:nil];
        }
        
    }
}



#pragma mark -
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // this is called when an AlertView box is clicked
    // seems a bit dodgy to me, running all of the alertViews through here...
    
    if(_promptResumeRun) {
        // if the alertView is the "do you want to resume a run?" alertView, then...
        
        
        _promptResumeRun = NO;
        
        if(buttonIndex == 1){
            [_appLogic continueMission];
            _resumeMission = YES;

            [_startPauseButton setTitle:@"RESUME" forState:UIControlStateNormal];
            _state.runState = RunStateReady;    
        } else {
            [_state.missionPlaylist removeAllObjects]; // empty the current mission playlist
            [_appLogic refillEventsFileForCurrentMission];  // and refill the events file
            [self startMission];                        // so that we can start the mission from scratch
            _state.runState = RunStateReady;
        }
    } else {
        // then the alertView must be the "do you want to end a run?" alertView
        
        
        if(buttonIndex == 1) {
            // ie if the user has chasen to end the run
            
            // clean up the interface
            // (should this be refactored somewhere else?)
            

            // Free up any overlays left over from the previous run.
            _overlayView = nil;
            _mapAnnotations = nil;
            [_appLogic endRun:NO]; // should be endMission: NO, needs renaming for clarity
            
            // Update the UI
            [_startPauseButton setTitle:@"START" forState:UIControlStateNormal];
            _startPauseButton.hidden = NO;
            _endRunButton.hidden = YES;
            _resumeRunButton.hidden = YES;
            
            
            // set the run state to ready
            _state.runState = RunStateReady;
            
            // and mark the run as complete
            [self runCompleted:_appLogic];
        }

    }
}
@end
