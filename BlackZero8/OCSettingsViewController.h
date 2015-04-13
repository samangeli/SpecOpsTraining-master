//
//  SettingsViewController.h
//  BlackZero8
//
//  Created by Manjit Bedi on 2013-12-27.
//  Copyright (c) 2013 Manjit Bedi. All rights reserved.
//

#import "BaseViewController.h"

@interface OCSettingsViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *unitSegmentedControl;
- (IBAction)changeUnitAction:(id)sender;

@end
