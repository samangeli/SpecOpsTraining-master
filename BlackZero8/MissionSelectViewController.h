//
//  MissionSelectViewController.h
//  BlackZero8
//
//  Created by Manjit Bedi on 2013-12-23.
//  Copyright (c) 2013 Manjit Bedi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class BZMission;

@interface MissionSelectViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) BZMission *currentMission;
- (IBAction)downloadMoreMissionsAction:(id)sender;


@end
