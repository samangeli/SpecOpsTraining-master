//
//  MissionViewController.h
//  BlackZero8
//
//  Created by Manjit Bedi on 2013-12-23.
//  Copyright (c) 2013 Manjit Bedi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <AVFoundation/AVFoundation.h>
#import "BaseViewController.h"
#import "PSLocationManager.h"

@class BZMission;

@interface MissionViewController : BaseViewController <PSLocationManagerDelegate, MKMapViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *startPauseButton;
@property (weak, nonatomic) IBOutlet UIButton *endRunButton;
@property (weak, nonatomic) IBOutlet UIButton *resumeRunButton;

@property (weak, nonatomic) IBOutlet MKMapView *mapview;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceUnitsLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedUnitsLabel;

@property (weak, nonatomic) IBOutlet UILabel *paceLabel;
@property (weak, nonatomic) IBOutlet UILabel *caloriesLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitsLabel;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *progressPercentageLabel;
@property (weak, nonatomic) IBOutlet UILabel *gpsStrengthLabel;
@property (weak, nonatomic) IBOutlet UIView *missionCompleteView;
@property (weak, nonatomic) IBOutlet UILabel *missionStatus;

@property (strong, nonatomic) BZMission *currentMission;
@property (strong, nonatomic) AVQueuePlayer *audioPlayer;



- (IBAction)missionStartOrPause:(id)sender;

- (IBAction)startPauseAction:(id)sender;
- (IBAction)endAction:(id)sender;
- (IBAction)resumeAction:(id)sender;

- (IBAction)startMission;


@end
