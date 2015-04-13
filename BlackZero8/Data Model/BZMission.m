//
//  Mission.m
//  BlackZero8
//
//  Created by Manjit Bedi on 2013-12-28.
//  Copyright (c) 2013 Manjit Bedi. All rights reserved.
//

#import "BZMission.h"
#import "Event.h"

@implementation BZMission

@synthesize lastModified, lastTime, bestTime;

- (id)init {
    if (self = [super init]) {
        self.completed = NO;
        self.events = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
}


- (BOOL) processDataForMission:(NSData *) data {
    // reads from the file passed in, and sets up all of the mission's variables appropriately
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // Date format from server: 2014-01-23 21:04:20
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    NSError *error = nil;
    if(data) {
        NSDictionary *missionDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if(error) {
            NSLog(@"%@", [error localizedDescription]);
        }
        if(missionDict) {
            
            // The mission name and duration may already be set but it is possible they have been updated
            // in the CMS thus the data in the download file.
            self.name = [missionDict objectForKey:@"name"];
            self.desc = [missionDict objectForKey:@"brief"];
            NSObject *durationObject = [missionDict objectForKey:@"duration"];
            if([durationObject isKindOfClass:[NSNumber class]])
                self.duration = [(NSNumber *)durationObject unsignedLongValue];
            else if (self.duration == 0)
                self.duration = 60 * 10; // default
            NSArray *scenes = [missionDict objectForKey:@"events"];
            self.lastModified = [dateFormatter dateFromString: [missionDict objectForKey:@"publicationDate"]]; // We use this key as it's the date the file was published or republished
   
            
            for(NSDictionary *sceneDict in scenes){
                
                // create and initialise an Event for that scene
                Event *event = [[Event alloc] init];
                
                NSObject *audioNameObject = [sceneDict objectForKey:@"audio"];
                if([audioNameObject isKindOfClass:[NSString class]])
                    event.audioFileName = (NSString *) audioNameObject;
                else
                    return FALSE;
                
                NSString *audioFilePath = [NSString stringWithFormat:@"%@/%@", self.subfolderName, (NSString *) audioNameObject];
                

                NSURL *audioURL = [NSURL fileURLWithPath:audioFilePath];
                event.audioURL = audioURL;
                event.name = [sceneDict objectForKey:@"eventName"];
                
                event.time = [[sceneDict objectForKey:@"timeCode"] floatValue];
                NSString *eventTypeName = [sceneDict objectForKey:@"eventType"];
                char firstChar = [eventTypeName characterAtIndex:0];
                switch (firstChar) {
                    case 'd':
                        event.eventType = SOEventTypeDialogue;
                        break;
                    case 'p':
                        event.eventType = SOEventTypePickup;
                        event.pickupId = [[sceneDict objectForKey:@"pickupId"] unsignedIntegerValue];
                        break;
                    case 'c':
                        event.eventType = SOEventTypeCheckpoint;
                        break;
                }
                [self.events addObject:event];
            }
            
        }
    }
    
    return TRUE;
}


- (id) JSONDataForMission{

    NSString *filePath = [self.subfolderName stringByAppendingString:@"/mission.json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:nil];
    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    return json;
}





@end
