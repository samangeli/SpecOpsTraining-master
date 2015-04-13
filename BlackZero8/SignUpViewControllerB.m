//
//  SignUpViewControllerB.m
//  BlackZero8
//
//  Created by Piers Beckley on 17/02/2014.
//  Copyright (c) 2014 Manjit Bedi. All rights reserved.
//

#import "SignUpViewControllerB.h"


@interface SignUpViewControllerB ()

@property (nonatomic, assign) id currentResponder;

@end

@implementation SignUpViewControllerB

@synthesize sex, location, foundus, age, currentUser, loggedIn;

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
    
    currentUser = [BZUser currentUser];
    
    if (currentUser) {                          // If user logged in, retrieve current deets
        sex.text =  currentUser[@"sex"];
        location.text = currentUser[@"location"];
        foundus.text = currentUser[@"foundus"];
        age.text = currentUser[@"age"];
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
}


- (void)resignOnTap:(id)iSender {
    [self.currentResponder resignFirstResponder];
}


// update the user data

- (NSMutableDictionary *) updateUserData {
    
    NSMutableDictionary * userData = [[NSMutableDictionary alloc] init];
    

    [userData setObject:sex.text forKey:@"sex"];
    [userData setObject:location.text forKey:@"location"];
    [userData setObject:foundus.text forKey:@"foundus"];
    [userData setObject:age.text forKey:@"age"];
    
    
    return userData;
}

- (IBAction) clickNext: (UIButton *) sender {
      
    
    NSDictionary *userDataDictionary = [self updateUserData];
    [BZUser updateUserWithDictionary: userDataDictionary];
    

    [currentUser saveEventually:^(BOOL succeeded, NSError *error) {
        
        if (!error) {
            // Hooray! Let them use the app now.
            if (sender.tag == 100)
                [self moveToNewViewController:@"signupVC"];
            else
                [self moveToNewViewController:@"switchUserVC"];
        } else {
            NSString *errorString = [error userInfo][@"error"];
            NSLog(@"error: %@", errorString);

            
        }
        
    }];
        

}

@end
