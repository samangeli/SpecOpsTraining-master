//
//  SignInViewController.m
//  BlackZero8
//
//  Created by Piers Beckley on 08/02/2014.
//  Copyright (c) 2014 Manjit Bedi. All rights reserved.
//


#import "SignInViewController.h"


@interface SignInViewController ()

@property (nonatomic, assign) id currentResponder; //keyboard dismissal, also in SignUpViewController, needs refactoring

@end

@implementation SignInViewController

@synthesize username, password, currentUser;



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
    
    
    // keyboard dismissal code, also in SignUpViewController, should be refactored at some point
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:singleTap];
    
    loggedIntoFacebook = TRUE;  // later we'll pull this from the cached user object
    // but while we're testing this will do as a starting condition
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerUserDetails {
    
    [PFUser logOut];    // in the future we should probably try to retain some of the data associated with the anonymous user
    [self moveToNewViewController:@"signupVC"];
    
}


- (IBAction)signInUser {


    [PFUser logInWithUsernameInBackground:username.text password:password.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                            [self moveToNewViewController:@"switchUserVC"];
                                        } else {
                                            NSString *errorString = [error userInfo][@"error"];
                                            NSNumber *errorCode = [error userInfo][@"code"];
                                            NSLog(@"error: %@", errorString);
                                            
                                            // Show the errorString somewhere and let the user try again.
                                            
                                            int problem = [errorCode intValue];
                                            
                                            if (problem == 200 || problem == 208 || problem == 202 ) {
                                                //problem with user
                                                username.backgroundColor = [UIColor redColor];
                                            } else if ( problem == 201) {
                                                //problem with password
                                                password.backgroundColor = [UIColor redColor];
                                            } else if (problem == 101) {
                                                //bad credentials; they don't distinguish so can't say whether username or pw is to blame
                                                username.backgroundColor = [UIColor redColor];
                                                password. backgroundColor = [UIColor redColor];
                                            }
                                            

                                        }
                                    }];
    
    
    
     
}


- (IBAction)facebookButtonHandler:(id)sender {
    // The permissions requested from the user
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
            }
        } else if (user.isNew) {
            NSLog(@"User with facebook signed up and logged in!");
            [sender setTitle:@"LOG OUT" forState:UIControlStateNormal];
            [self fillPFUserWithFBData];
        } else {
            NSLog(@"User with facebook logged in!");
            [self fillPFUserWithFBData];
        }
  
    }];
}

-(void) changeFacebookLoginStatus {
    if (loggedIntoFacebook) {
        loggedIntoFacebook = FALSE;
    } else {
        loggedIntoFacebook = TRUE;
        
    }
    
}

- (void) fillPFUserWithFBData {
    // ...
    // Create request for user's Facebook data
    FBRequest *request = [FBRequest requestForMe];
    
    // Send request to Facebook
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            
            
            
            currentUser = [PFUser currentUser];
            
            currentUser[@"firstname"] = userData[@"first_name"];
            currentUser[@"lastname"] = userData [@"last_name"];
            currentUser[@"sex"] = userData[@"gender"];
            currentUser[@"location"] = userData[@"location"][@"name"];
            currentUser[@"email"] = userData[@"email"];
            
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; [dateFormat setDateFormat:@"MM/dd/yyyy"];
            NSDate* birthday = [dateFormat dateFromString: userData[@"birthday"]];
           
            NSDate* now = [NSDate date];
            NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                               components:NSYearCalendarUnit
                                               fromDate:birthday
                                               toDate:now
                                               options:0];
            currentUser[@"age"] = [NSString stringWithFormat:@"%ld", (long)[ageComponents year]];
            
    
            
            
            NSLog(@"%@", userData);
            
            NSLog(@"%@", [PFUser currentUser]);
            
            [currentUser saveEventually];
            
            [self moveToNewViewController:@"switchUserVC"];
            
            
            
        }
    }];
    

    
    
    
}


// Clear the keyboard when no longer needed
// Duplicate code to SignUpViewController, needs refactoring.

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
}


- (void)resignOnTap:(id)iSender {
    [self.currentResponder resignFirstResponder];
}


@end
