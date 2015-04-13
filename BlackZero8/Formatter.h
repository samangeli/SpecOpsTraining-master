//
//  DurationFormatter.h
//  BlackZero8
//
//  Created by Manjit Bedi on 2014-04-07.
//  Copyright (c) 2014 Manjit Bedi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsObject.h"

@interface Formatter : NSObject

@property (weak, nonatomic) SettingsObject *settings;

+ (id)sharedInstance;
- (NSString *) formattedDurationString:(NSTimeInterval) duration;
- (NSString *) formattedDistanceString:(CGFloat) distance;
- (NSString *) formattedSpeedString: (CGFloat) speed;
- (NSString *) displayUnits;

@end
