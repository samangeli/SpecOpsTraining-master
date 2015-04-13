//
//  SignInViewController.h
//  BlackZero8
//
//  Created by Piers Beckley on 08/02/2014.
//  Copyright (c) 2014 Manjit Bedi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>


@interface SignInViewController : BaseViewController {
    BOOL loggedIntoFacebook;
}

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;

@property (weak, nonatomic) PFUser *currentUser;

- (void) fillPFUserWithFBData;
- (void) changeFacebookLoginStatus;

@end

