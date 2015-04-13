//
//  SignUpViewControllerB.h
//  BlackZero8
//
//  Created by Piers Beckley on 17/02/2014.
//  Copyright (c) 2014 Manjit Bedi. All rights reserved.
//

#import "BaseViewController.h"
#import "BZUser.h"
#import <Parse/Parse.h>

@interface SignUpViewControllerB : BaseViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *sex;
@property (weak, nonatomic) IBOutlet UITextField *location;
@property (weak, nonatomic) IBOutlet UITextField *foundus;
@property (weak, nonatomic) IBOutlet UITextField *age;
@property (weak, nonatomic) IBOutlet UITextField *picture;

@property (weak, nonatomic) PFUser *currentUser;
@property BOOL loggedIn;

@end
