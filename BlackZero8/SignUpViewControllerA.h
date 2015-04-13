//
//  UserViewController.h
//  BlackZero8
//
//  Created by Manjit Bedi on 2013-12-27.
//  Copyright (c) 2013 Manjit Bedi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "BaseViewController.h"
#import "BZUser.h"

@interface SignUpViewControllerA : BaseViewController <UITextFieldDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property BZUser *currentUser;

@property BOOL loggedIn;

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *firstname;
@property (weak, nonatomic) IBOutlet UITextField *lastname;



- (IBAction) textFieldDoneEditing: (id)sender ;
- (IBAction) clickNext ;
- (void) createNewUser;





@end
