//
//  Event.h
//  BlackZero8
//
//  Created by Manjit Bedi on 2014-01-19.
//  Copyright (c) 2014 Manjit Bedi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


typedef NS_ENUM(NSUInteger, SOEventType) {
    SOEventTypeDialogue,
    SOEventTypePickup,
    SOEventTypeCheckpoint
};

@interface Event : NSObject
@property (strong, nonatomic) NSString *audioFileName;  // optional
@property (strong, nonatomic) NSURL *audioURL;
@property NSUInteger time;      // required
@property SOEventType eventType;    // required
@property NSUInteger pickupId;       // optional
@property AVPlayerItem *eventAudio;
@property NSString *name;
@end
