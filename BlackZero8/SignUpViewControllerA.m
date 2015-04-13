//
//  UserViewController.m
//  BlackZero8
//
//  Created by Manjit Bedi on 2013-12-27.
//  Copyright (c) 2013 Manjit Bedi. All rights reserved.
//

#import "SignUpViewControllerA.h"



@interface SignUpViewControllerA ()

@property (nonatomic, assign) id currentResponder;

@end


@implementation SignUpViewControllerA


@synthesize username, password, firstname, lastname, email, loggedIn, currentUser;




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
	// Do any additional setup after loading the view.
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:singleTap];
    
    
    currentUser = [BZUser currentUser];         // Do we have a current user?
    
    if (currentUser) {                          // If user logged in, retrieve current deets
        username.text =  currentUser.username;
        password.text = currentUser.password;
        email.text = currentUser.email;
        firstname.text = currentUser[@"firstname"];
        lastname.text = currentUser[@"lastname"];
    }
    


}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Clear the keyboard when no longer needed

- (IBAction) textFieldDoneEditing: (id) sender
{
    self.currentResponder = nil;
    [sender resignFirstResponder];
}

- (BOOL) textFieldShouldReturn: (UITextField *) textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentResponder = textField;
    textField.backgroundColor = [UIColor whiteColor]; // clears red if there's an error
    
    if(textField == email) {
        
    }
}


- (void)resignOnTap:(id)iSender {
    [self.currentResponder resignFirstResponder];
}


// update the user data

- (NSMutableDictionary *) updateUserData {
    
    NSMutableDictionary * userData = [[NSMutableDictionary alloc] init];
    
    [userData setObject:firstname.text forKey:@"firstname"];
    [userData setObject:lastname.text forKey:@"lastname"];
    
    
    return userData;
}

- (void)showErrors:(NSError *)error {
    NSString *errorString = [error userInfo][@"error"];
    NSNumber *errorCode = [error userInfo][@"code"];
    NSLog(@"error: %@", errorString);
    
    // Show the errorString somewhere and let the user try again.
    
    int problem = [errorCode intValue];
    
    if (problem == 200 || problem == 208 || problem == 202) {
        //problem with user
        username.backgroundColor = [UIColor redColor];
    }
    else if ((problem > 200 && problem < 206) || problem == 125) {
        //problem with email
        email.backgroundColor = [UIColor redColor];
    }
}

- (void) createNewUser {
    
    currentUser = [BZUser object];
    
    currentUser.username = username.text;
    currentUser.password = password.text;
    currentUser.email = email.text;
    
    [currentUser setObject:firstname.text forKey:@"firstname"];
    [currentUser setObject:lastname.text forKey:@"lastname"];
    
    [currentUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [self moveToNewViewController:@"signupVCB"];
        } else {
            [self showErrors:error];
        }
    }];
    
}



- (IBAction) clickNext {
    
    
    currentUser = [BZUser currentUser];             // if we have a logged in user set them...
    
    
    if (currentUser) {
        NSDictionary *userDataDictionary = [self updateUserData];
        [BZUser updateUserWithDictionary: userDataDictionary];
        
        [currentUser saveEventually:^(BOOL succeeded, NSError *error) {
            
            if (!error) {
                // Hooray! Let them use the app now.
                currentUser.anonymous = NO;
                [self  moveToNewViewController:@"signupVCB"];
            } else {
                [self showErrors:error];  
            }
            
        }];
        
        
    } else {                 // create one
        [self createNewUser];
    }
   
    
}






@end
