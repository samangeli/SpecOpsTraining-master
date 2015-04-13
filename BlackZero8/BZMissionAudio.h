//
//  BZMissionAudio.h
//  BlackZero8
//
//  Created by Piers Beckley on 02/06/2014.
//  Copyright (c) 2014 Manjit Bedi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "BZMission.h"

@interface BZMissionAudio : NSObject

@property (strong, nonatomic) AVQueuePlayer *audioPlayer; 

@property (weak, nonatomic) BZMission * currentMission;

- (NSMutableArray * ) sanitisePlaylist: (NSMutableArray *) thePlaylist;
- (NSMutableArray *) createUpcomingEvents: (MPMediaPlaylist *) thePlaylist;

- (void) changePlaylist: (MPMediaPlaylist *)aPlaylist;

@end
