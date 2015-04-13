//
//  BZMissionAudio.m
//  BlackZero8
//
//  Created by Piers Beckley on 02/06/2014.
//  Copyright (c) 2014 Manjit Bedi. All rights reserved.
//

#import "BZMissionAudio.h"
#import "StateObject.h"
#import "DownloadManager.h"
#import "BZMission.h"
#import "Event.h"

@interface BZMissionAudio ()

@property (weak, nonatomic) StateObject *state;



@end

@implementation BZMissionAudio

@synthesize currentMission;


- (id)init {
        if (self = [super init]) {
        self.state = [StateObject sharedManager];
        currentMission = [_state.downloadManager.missions objectAtIndex:_state.missionIndex];

        
        
    }
    return self;
}




- (NSMutableArray * ) sanitisePlaylist:(NSMutableArray *)thePlaylist {
    // Go through a Playlist and remove the songs which don't exist
    // In practice, these songs will be the ones which are on the playlist but not on the local device
    // ie the songs which are tagged in an iTunes Match playlist, but which haven't been downloaded to the iPhone
    
    NSMutableArray * theNewPlaylist = [NSMutableArray array];
    
    for (MPMediaItem * theNextSong in thePlaylist) {
        
        NSURL *songURL = [theNextSong valueForProperty: MPMediaItemPropertyAssetURL];
        
        if (songURL != nil) {
            // if there's no songURL, then the the playlist is an iTunes Match playlist,
            // and the song hasn't been downloaded from the cloud - so delete it and move on to the next one
            // there's probably a better way to check for this
            
            
            [theNewPlaylist addObject: theNextSong];
            

        }
        
    }


    return theNewPlaylist;

}

- (void)changePlaylist:(MPMediaPlaylist *)aPlaylist {
    // if the selected playlist exists and has songs in it
    // then point _state.selectedPlaylist to it
    // and clear the missionPlaylist there so it can be recreated
    
    
    NSMutableArray *songs = [NSMutableArray arrayWithArray: [aPlaylist items]];
    
    BZMissionAudio *missionAudio = [[BZMissionAudio alloc] init];
    
    songs = [missionAudio sanitisePlaylist: songs];
    
    if (!songs.count) {
        // if there are no songs left after we've sanitised the playlist, then there were no songs on the local device
        // so prompt the user to choose another playlist, or download 'em
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No songs stored locally"
                                                        message:@"This playlist has no songs stored on your device. Please download them from iCloud, or choose another playlist."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        
        return;
        
    }
    
    
    _state.selectedPlaylist = aPlaylist;
    _state.missionPlaylist = nil;
}

- (NSMutableArray *)createUpcomingEvents:(MPMediaPlaylist *)currentPlaylist {

    
    NSMutableArray *missionEvents = [NSMutableArray array];
    
    
    if (currentPlaylist) {
    
        // given a songs playlist, get the events list from the current mission
        // and intersperse the two items to create a joint songs / events playlist
        
        if ( [_state.missionEvents count] ) {
            //if we have a mission on the go, queue it up
            
            NSLog(@"Current Mission detected and enqueued");
            
            NSLog(@"Mission Playlist: %@", _state.missionPlaylist);
            
            for (AVAsset *theAsset in _state.missionPlaylist) {
                [missionEvents addObject: [AVPlayerItem playerItemWithAsset: theAsset]];
            }
            
            
        } else {
            // Otherwise get all the Events in the Current Mission
            // And queue their audio into the AVplayer
            // With a number of user tracks from their playlist between 'em (currently 1)
            
            //        int userTracks = _state.playlistTracksBetweenMissionAudio;
            
            NSMutableArray *songs = [NSMutableArray arrayWithArray: [currentPlaylist items]];
            
            
            songs = [self sanitisePlaylist: songs];
            
            for (MPMediaItem *song in songs) {
                NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
                NSLog (@"\t\t%@", songTitle);
            }
            
            
            for (Event *theEvent in currentMission.events) {
                
                // Get the first song from the selected library playlist on the iPhone
                
                MPMediaItem *nextSong = songs[0];
                NSURL *songURL = [nextSong valueForProperty: MPMediaItemPropertyAssetURL];
                
                
                // Add an event from the mission and an observer to detect when it finishes playing
                
                AVPlayerItem *missionAudio = [AVPlayerItem playerItemWithURL: [theEvent audioURL]];
                
                
                [missionEvents addObject: missionAudio];
                [[NSNotificationCenter defaultCenter] addObserver: self
                                                         selector:@selector(missionEventDidFinishPlaying:)
                                                             name:AVPlayerItemDidPlayToEndTimeNotification
                                                           object:missionAudio];
                
                
                // then add the song at the front of the list to the mission events player, and move the song to the back of the user's songlist
                // so the songs will repeat if there are fewer songs than events
                
                
                AVPlayerItem *songAudio = [AVPlayerItem playerItemWithURL: songURL];
                
                
                [missionEvents addObject: songAudio];
                
                [songs removeObjectAtIndex:0];
                [songs addObject:nextSong];
                
                
            }
            
            
            _state.missionPlaylist = missionEvents;
            
            
        }
    } else {
        // we must be on a simulator, so we have no playlists to play with; just queue the mission itself
        
        if ( [_state.missionEvents count] ) {
            //if we have a mission on the go, queue it up
            
            NSLog(@"Current Mission detected and enqueued");
            
            NSLog(@"Mission Playlist: %@", _state.missionPlaylist);
            
            for (AVAsset *theAsset in _state.missionPlaylist) {
                [missionEvents addObject: [AVPlayerItem playerItemWithAsset: theAsset]];
            }
            
            
        } else {
            // Otherwise get all the Events in the Current Mission
            // And queue their audio into the AVplayer
            
            
            for (Event *theEvent in currentMission.events) {
                
                
                
                // Add an event from the mission and an observer to detect when it finishes playing
                
                AVPlayerItem *missionAudio = [AVPlayerItem playerItemWithURL: [theEvent audioURL]];
                
                
                [missionEvents addObject: missionAudio];
                [[NSNotificationCenter defaultCenter] addObserver: self
                                                         selector:@selector(missionEventDidFinishPlaying:)
                                                             name:AVPlayerItemDidPlayToEndTimeNotification
                                                           object:missionAudio];
                
                
                
                
            }
            
            
            _state.missionPlaylist = missionEvents;

        
        }
        
    }
        
        
    return missionEvents;
}

- (void) missionEventDidFinishPlaying: (NSNotification *) notification {
    // This method is called after an event (but not a song) has finished playing
    // Remove the event from the front of the current events queue - this will mean that
    // when we start again, we won't replay already-played-through events
    
    
    [currentMission.events removeObjectAtIndex: 0];
    

    
}




-(void) dealloc {
    
    // make sure we don't have any calls left over from events after we're deallocated...
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    

    
}

@end


