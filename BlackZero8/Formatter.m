//
//  DurationFormatter.m
//  BlackZero8
//
//  Created by Manjit Bedi on 2014-04-07.
//  Copyright (c) 2014 Manjit Bedi. All rights reserved.
//

#import "Formatter.h"


@implementation Formatter


- (id)init {
    if (self = [super init]) {
        self.settings = [SettingsObject sharedInstance];
    }
    return self;
}

+ (id)sharedInstance {
    static Formatter *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


-(NSString *) formattedDurationString:(NSTimeInterval) duration {
    
    const NSTimeInterval maxDuration = 86399;
    NSUInteger total = duration;
    if(total > maxDuration)
        total = maxDuration;
    NSUInteger hours = total / (3600);
    NSUInteger minutes = (total / 60) % 60;
    NSUInteger seconds = total % 60;
    NSString *output = [NSString stringWithFormat:@"%02lu:%02lu:%02lu", (unsigned long)hours, (unsigned long)minutes, (unsigned long)seconds];

    return output;
}

-(NSString *) formattedDistanceString:(CGFloat) distance {
    
    const CGFloat maxDisplayedDistance = 99.99f;
    NSString *output;
    SettingsObject *settings = [SettingsObject sharedInstance];
    
    if(settings.useMetric)
        distance = distance / 1000.0f;
    else
        distance = distance / 1609.344f;
    
    if(distance > maxDisplayedDistance)
        distance = maxDisplayedDistance;
    
    output = [NSString stringWithFormat:@"%.02f", distance];
    
    return output;
}

- (NSString *) formattedSpeedString: (CGFloat) speed {
    
    const CGFloat maxDisplayedSpeed = 99.99f;

    SettingsObject *settings = [SettingsObject sharedInstance];
    
    // first convert the figure in km/second to miles/second if required
    
    if(settings.useMetric)
        speed = speed / 1000.0f;
    else
        speed = speed / 1609.344f;
    
    // then convert to hours
    
    speed = speed * 3600; //multiplied because we already divided out by the seconds are divided in km/second
    
    if(speed > maxDisplayedSpeed)
        speed = maxDisplayedSpeed;
    


    return  [NSString stringWithFormat:@"%.02f", speed];

}


-(NSString *) displayUnits {
    
    if(_settings.useMetric)
        return @"km";
    else
        return @"mi";
}

@end


