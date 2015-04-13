//
//  SettingsObject.h
//  BlackZero8
//
//  Created by Manjit Bedi on 2014-04-07.
//  Copyright (c) 2014 Manjit Bedi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsObject : NSObject

@property BOOL useMetric;

+ (id)sharedInstance;
- (void) saveSettings;

@end
