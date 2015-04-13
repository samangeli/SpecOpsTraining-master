//
//  BZAppLogic.h
//  BlackZero8
//
//  Created by Manjit Bedi on 2014-04-04.
//  Copyright (c) 2014 Manjit Bedi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>

#import "StateObject.h"
#import "PSLocationManager.h"

@class BZAppLogic;
@class Event;

@protocol BZAppLogicDelegate <NSObject>

@optional
- (void) updateDisplay:(BZAppLogic *) appLogic;
- (void) runCompleted:(BZAppLogic *) appLogic;
@end

@interface BZAppLogic : NSObject <PSLocationManagerDelegate>

@property (nonatomic, weak) id<BZAppLogicDelegate> delegate;
@property BZMission *currentMission;
@property CGFloat totalCaloriesBurned;
@property CGFloat currentPace;
@property NSTimeInterval startTime;
@property NSTimeInterval missionTime;
@property CGFloat startDistance;

// Points as in score for achievements etc.
@property NSUInteger pointsThisRun;
@property NSUInteger pointsTotal;


// Geo-locations
@property (strong, nonatomic) NSMutableArray *geoCoordinates;
@property (weak, nonatomic) PSLocationManager *locationManager;

+ (id)sharedInstance;
- (void) startUpdating;
- (void) endUpdating;
- (void) setMission:(BZMission *) mission;
- (void) newRun;
- (void) endRun:(BOOL) completedRun;
- (void) pauseRun;
- (void) resumeRun;
- (void) continueMission; // resume a previously incomplete mission
- (void) refillEventsFileForCurrentMission;


- (NSTimeInterval) getMissionTime;
- (CGFloat) getMissionDistance;
- (CGFloat) getMissionSpeed;

@end
