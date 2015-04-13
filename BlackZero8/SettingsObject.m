//
//  SettingsObject.m
//  BlackZero8
//
//  Created by Manjit Bedi on 2014-04-07.
//  Copyright (c) 2014 Manjit Bedi. All rights reserved.
//

#import "SettingsObject.h"
#import "constants.h"

@implementation SettingsObject

+ (id)sharedInstance {
    static SettingsObject *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}


- (id)init {
    if (self = [super init]) {

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if(defaults) {
            NSObject *obj = [defaults objectForKey:kSettingsPrefUnits];
            if(obj){
                _useMetric = [defaults boolForKey:kSettingsPrefUnits];
            } else {
                _useMetric = true;
            }
        }
    }
    return self;
}


- (void) saveSettings {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(defaults) {
        
        [defaults setBool:_useMetric forKey:kSettingsPrefUnits];
        [defaults synchronize];
    }
}


@end
