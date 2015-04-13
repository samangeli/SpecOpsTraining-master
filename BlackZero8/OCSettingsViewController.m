//
//  SettingsViewController.m
//  BlackZero8
//
//  Created by Manjit Bedi on 2013-12-27.
//  Copyright (c) 2013 Manjit Bedi. All rights reserved.
//

#import "OCSettingsViewController.h"
#import "SettingsObject.h"

#import "constants.h"

@interface OCSettingsViewController ()

@property (weak, nonatomic) SettingsObject *settings;

@end

@implementation OCSettingsViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
	self.settings = [SettingsObject sharedInstance];
    _unitSegmentedControl.selectedSegmentIndex = _settings.useMetric == true ? 0 : 1;
    

    NSDictionary *attributesDictionary = @{ NSFontAttributeName : [UIFont fontWithName:customFontName size:18] };
    [_unitSegmentedControl setTitleTextAttributes:attributesDictionary forState:UIControlStateNormal];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)changeUnitAction:(id)sender {
    
    if(_unitSegmentedControl.selectedSegmentIndex == 0)
        _settings.useMetric = true;
    else
        _settings.useMetric = false;
    
    [_settings saveSettings];
}

- (IBAction)closeVC:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:true completion:nil];
}


@end
