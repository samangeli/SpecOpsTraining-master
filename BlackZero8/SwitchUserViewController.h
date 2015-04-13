//
//  SwitchUserViewController.h
//  SpecOpsTraining
//
//  Created by Piers Beckley on 14/02/2014.
//  Copyright (c) 2014 Manjit Bedi. All rights reserved.
//

#import "BaseViewController.h"
#import <Parse/Parse.h>

@interface SwitchUserViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UILabel *welcomeMessage;
@property (weak, nonatomic) PFUser *currentUser;


- (IBAction)signInButtonPressed:(id)sender;

@end
