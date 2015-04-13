//
//  SwitchUserViewController.m
//  SpecOpsTraining
//
//  Created by Piers Beckley on 14/02/2014.
//  Copyright (c) 2014 Manjit Bedi. All rights reserved.
//

#import "SwitchUserViewController.h"

@interface SwitchUserViewController ()


@end

@implementation SwitchUserViewController


@synthesize welcomeMessage, currentUser;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    currentUser = [PFUser currentUser];
    
    NSString *firstName = currentUser[@"firstname"];
    
    if (currentUser && ![PFAnonymousUtils isLinkedWithUser:[PFUser currentUser]]) { // if there is a current user cached who is not the anonymous user, welcome them
        welcomeMessage.text = [NSString stringWithFormat:@"Hi %@", firstName];

    } else {
                
        [self moveToNewViewController:@"signinVC"];
        
    }

}




- (IBAction) signInButtonPressed: (id) sender {
    
    [PFUser logOut];    //later, we'll want to save anonymous scores and associate them with the new user created. for now, we'll throw 'em away.
    [self moveToNewViewController:@"signinVC"];
    
}
          


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
