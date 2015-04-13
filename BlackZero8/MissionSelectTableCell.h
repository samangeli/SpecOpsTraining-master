//
//  MissionSelectTableCell.h
//  BlackZero8
//
//  Created by Manjit Bedi on 2013-12-24.
//  Copyright (c) 2013 Manjit Bedi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MissionSelectTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *artworkImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *missionDetailButton;
@end
