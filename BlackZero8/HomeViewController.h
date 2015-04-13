//
//  HomeViewController.h
//  BlackZero8
//
//  Created by Manjit Bedi on 2014-01-03.
//  Copyright (c) 2014 Manjit Bedi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "common.h"
#import "BaseViewController.h"

@interface HomeViewController : BaseViewController {

}


@property (weak, nonatomic) IBOutlet UIButton *startButton;


@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *recruitButton;
@property (weak, nonatomic) IBOutlet UIButton *downloadMissionsAction;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;


@property (weak, nonatomic) IBOutlet UILabel *debugLabel;


- (IBAction)startNextMissionAction:(id)sender;
- (IBAction)recruitAction:(id)sender;
- (IBAction)downloadMissionsAction:(id)sender;


@end
