//
//  BaseViewController.h
//  BlackZero8
//
//  Created by Manjit Bedi on 2013-12-26.
//  Copyright (c) 2013 Manjit Bedi. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BaseViewController : UIViewController

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *titles;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labels;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labelsSize2;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labelsSize3;


@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *counters;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *mediumCounters;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *smallButtons;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;

- (IBAction)showMenuAction:(id)sender;
- (void) moveToNewViewController: (NSString *) newVC;


@end
