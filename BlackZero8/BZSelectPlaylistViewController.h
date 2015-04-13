//
//  BZSelectPlaylistViewController.h
//  BlackZero8
//
//  Created by Piers Beckley on 15/05/2014.
//  Copyright (c) 2014 Manjit Bedi. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "BZMissionAudio.h"

@interface BZSelectPlaylistViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

//@property (weak, nonatomic) StateObject *state;


//@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) MPMediaPlaylist *aPlaylist;



@end
