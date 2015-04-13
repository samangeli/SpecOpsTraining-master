//
//  MissionSummaryViewController.h
//  BlackZero8
//
//  Created by Manjit Bedi on 2014-01-04.
//  Copyright (c) 2014 Manjit Bedi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "BZMission.h"

@interface MissionSummaryViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *missionNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *missionStatus;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitsLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;

@property (weak, nonatomic) IBOutlet UILabel *lastSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastDistanceLabel;


@property (weak, nonatomic) IBOutlet UILabel *bestSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestDistanceLabel;

@property (weak, nonatomic) BZMission *currentMission;

- (void) updateTimeAndDistanceSummaries;


@end
