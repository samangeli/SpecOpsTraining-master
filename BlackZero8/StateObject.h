//
//  StateObject.h
//  BlackZero8
//
//  Created by Manjit Bedi on 2013-12-27.
//  Copyright (c) 2013 Manjit Bedi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MediaPlayer/MediaPlayer.h>

@class DownloadManager;
@class BZMission;


typedef NS_ENUM(NSUInteger, RunState) {
    RunStateReady,
    RunStateRunning,
    RunStatePaused,
    RunStateFinished,
    RunStateAborted
};


@interface StateObject : NSObject

@property NSUInteger points;
@property (weak, nonatomic) DownloadManager *downloadManager;
@property (strong, nonatomic) NSDate *dateStart;
@property (strong, nonatomic) NSDate *pauseDate;
@property NSUInteger timeElapsedSeconds;
@property NSTimeInterval pausedTime;
@property RunState runState;
@property NSUInteger sceneIndex;
@property NSMutableArray *pickupsCatalog;
@property NSMutableArray *pickupsForCurrentRun;
@property NSMutableArray *kitbag;
@property NSTimeInterval runDuration;
@property NSUInteger missionIndex;
@property CGFloat weight;
@property NSArray *playlists;
@property (strong, nonatomic) MPMediaPlaylist *selectedPlaylist;
@property NSArray *missionEvents;                           // The events left to come in the current mission
@property (strong, nonatomic) NSMutableArray *missionPlaylist;     // The playlist left to come for the current mission
@property int playlistTracksBetweenMissionAudio;
@property NSUInteger currentEventIndex;


@property (strong, nonatomic) NSArray *inventory;

+ (id)sharedManager;
- (NSString *) nameForPickUpWithId:(NSUInteger) identifier;

- (NSUInteger) getNextMissionIndex;
- (NSArray *) listPlaylists;

@end
