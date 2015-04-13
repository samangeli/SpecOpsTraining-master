//
//  Mission.h
//  BlackZero8
//
//  Created by Manjit Bedi on 2013-12-28.
//  Copyright (c) 2013 Manjit Bedi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BZMission : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *subfolderName;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSMutableArray *events;
@property NSTimeInterval duration;


@property BOOL isDownloaded;            // the mission was downloaded from a server
@property BOOL isBundled;               // the mission was part of the main app bundle
@property BOOL completed;
@property NSUInteger numberOfRunsToCompleteMission;
@property NSDate *lastModified;         // when was this mission updated?

@property NSTimeInterval missionTime;   // if the mission is incomplete how much time did has been accumulated.



@property NSTimeInterval lastTime;      // how long did the mission take to run in total last time through?
@property NSTimeInterval bestTime;      // what's the fastest time the mission's ever taken to run?
@property CGFloat lastDistance;         // what distance was covered on the mission last time through?
@property CGFloat bestDistance;         // what's the longest distance this mission's ever been run in?
@property CGFloat lastSpeed;            // what's the speed this mission was run in last?
@property CGFloat bestSpeed;            // what's the best speed this mission's ever been run in?


- (BOOL) processDataForMission:(NSData *) data;
- (id) JSONDataForMission;
@end
