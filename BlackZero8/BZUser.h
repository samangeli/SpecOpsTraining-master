//
//  BZUser.h
//  BlackZero8
//
//  Created by Piers Beckley on 19/03/2014.
//  Copyright (c) 2014 Manjit Bedi. All rights reserved.
//

#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>

@interface BZUser : PFUser <PFSubclassing>


@property NSString * firstname;
@property NSString * lastname;
@property NSString * foundus;
@property NSString * sex;
@property NSString * age;
@property NSString * location;

// TODO: re-factor.  Ths was done to be allow the app to know if the user name is
// from an anonymoous user.  Anonymous user's have gibberish user names.
@property BOOL anonymous;

+ (void) updateUserWithDictionary: (NSDictionary *) userDictionary ;

@end
