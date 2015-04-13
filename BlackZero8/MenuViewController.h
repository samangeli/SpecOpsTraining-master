//
//  MenuViewController.h
//  BlackZero8
//
//  Created by Manjit Bedi on 2013-12-23.
//  Copyright (c) 2013 Manjit Bedi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface MenuViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property BOOL isMenuVisible;

- (void) setChildViewController:(UIViewController *) viewController;

@end
