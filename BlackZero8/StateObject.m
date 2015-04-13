//
//  StateObject.m
//  BlackZero8
//
//  Created by Manjit Bedi on 2013-12-27.
//  Copyright (c) 2013 Manjit Bedi. All rights reserved.
//

#import "StateObject.h"
#import "DownloadManager.h"
#import <MediaPlayer/MediaPlayer.h>

#import "BZMission.h"
#import "Event.h"
#import "PickUp.h"



// So the State Object basically holds all the state information for the app.

@implementation StateObject 

@synthesize playlists, selectedPlaylist, missionPlaylist, playlistTracksBetweenMissionAudio, missionEvents;

+ (id)sharedManager {
    static StateObject *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}


- (id)init {
    if (self = [super init]) {
        self.downloadManager = [DownloadManager sharedManager];
        self.kitbag = [[NSMutableArray alloc] initWithCapacity:10];
        self.pickupsForCurrentRun = [[NSMutableArray alloc] initWithCapacity:10];
        self.pickupsCatalog = [[NSMutableArray alloc] initWithCapacity:20];
        self.weight = 90.0f;
        self.runState = RunStateReady;
        playlistTracksBetweenMissionAudio = 1; // not currently used.
        [self loadPickupsCatalog];
    }
    return self;
}



- (NSArray *) listPlaylists {
    // return playlists in iPod
    
    MPMediaQuery *myPlaylistsQuery = [MPMediaQuery playlistsQuery];
    playlists = [myPlaylistsQuery collections];
    
    return playlists;
    
}




- (void) loadPickupsCatalog {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"pickups_catalog" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if(data) {
        NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if(json){
            for(NSDictionary *dict in json) {
                PickUp *newPickup = [[PickUp alloc] init];
                newPickup.points = [[dict objectForKey:@"points"] integerValue];
                newPickup.identifier = [[dict objectForKey:@"id"] integerValue];
                newPickup.name = [dict objectForKey:@"name"];
                newPickup.category = [[dict objectForKey:@"category"] integerValue];
                [self.pickupsCatalog addObject:newPickup];
            }
        }
    }
}


- (NSString *) nameForPickUpWithId:(NSUInteger) identifier {
    NSString *pickUpName = nil;
    for(PickUp *pickUp in self.pickupsCatalog) {
        if(pickUp.identifier == identifier)
            pickUpName = pickUp.name;
    }
    
    if(pickUpName == nil)
        pickUpName = @"pickup";
    
    return  pickUpName;
}


// Iterate through the missions and get the index of the first ready mission.
- (NSUInteger) getNextMissionIndex {
    
    NSUInteger index = NSNotFound;
    
    for(BZMission *mission in _downloadManager.missions) {
        if(mission.completed == NO) {
            index = [_downloadManager.missions indexOfObject:mission];
            break;
        }
    }
    
    return index;
}

@end
