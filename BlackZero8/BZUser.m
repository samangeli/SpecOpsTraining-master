//
//  BZUser.m
//  BlackZero8
//
//  Created by Piers Beckley on 19/03/2014.
//  Copyright (c) 2014 Manjit Bedi. All rights reserved.
//

#import "BZUser.h"
#import <Parse/PFObject+Subclass.h>

@implementation BZUser

@synthesize firstname, lastname, foundus, sex, age, location, anonymous;


+ (void) updateUserWithDictionary: userDictionary {
    
    BZUser *currentUser = [BZUser currentUser];
    for(id key in userDictionary) {
        currentUser[key] = [userDictionary objectForKey: key];
    }
}

@end