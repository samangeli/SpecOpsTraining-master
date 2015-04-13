//
//  MenuViewController.m
//  BlackZero8
//
//  Created by Manjit Bedi on 2013-12-23.
//  Copyright (c) 2013 Manjit Bedi. All rights reserved.
//

#import "MenuViewController.h"
#import "PSLocationManager.h"
#import "DownloadManager.h"
#import "StateObject.h"
#import "constants.h"

#import <Parse/Parse.h>

@interface MenuViewController ()

@property (strong, nonatomic) NSArray *menuLabels;
@property (strong, nonatomic) UIViewController *currentViewController;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuLabels =
        @[
          @"MISSIONS",
          @"SETTINGS",
          @"PLAYLIST SELECT",
          @"FAQ",
        ];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_menuLabels count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if(indexPath.row == 0)
        cell.textLabel.textColor = [UIColor whiteColor];
    else
        cell.textLabel.textColor = customRedColor;
        
    cell.textLabel.highlightedTextColor = [UIColor grayColor];
    cell.textLabel.text = _menuLabels[indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:customFontName size:22];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = customRedColor;
    bgColorView.layer.masksToBounds = YES;
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0)
        [cell setBackgroundColor:[UIColor colorWithRed:64.0/255.0 green:15.0/255.0 blue:18.0/255.0 alpha:1.0]];
    else
        [cell setBackgroundColor:[UIColor blackColor]];
}


#pragma mark - UITableView Delegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    StateObject *state = [StateObject sharedManager];
    
    NSString *vcName = nil;
    switch (indexPath.row) {

            
       
        case 0: {
                if(state.runState == RunStateRunning || state.runState == RunStatePaused ) {    // then a run is in progress, so go there
                    vcName = @"mainVC";
                } else                                                                          // otherwise go to the home screen
                    vcName = @"selectMissionVC";
            }
            break;
            
        case 1:
            vcName = @"settingsVC";
            break;

            
        case 2:
            vcName = @"PlaylistView";
            break;
            
        case 3:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.google.co.uk"]];
            break;

    }
    
    if(vcName != nil) {
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *newVC = [storyboard instantiateViewControllerWithIdentifier:vcName];
        [self setChildViewController:newVC];
        self.isMenuVisible = NO;
        CGFloat yPos = self.containerView.frame.origin.y;
        CGSize size = _containerView.frame.size;
        [UIView animateWithDuration:0.5 animations:^{
            self.containerView.frame = CGRectMake(0, yPos, size.width, size.height);
        }];
    }
}


#pragma mark -
- (void) setChildViewController:(UIViewController *) viewController{
    UIView *view = _containerView.subviews[0];
    if(view) {
        [_currentViewController willMoveToParentViewController:nil];
        [view removeFromSuperview];
        [_currentViewController removeFromParentViewController];
    }    
    [self addChildViewController:viewController];
    viewController.view.frame = CGRectMake(0, 0, _containerView.frame.size.width, _containerView.frame.size.height);
    [_containerView addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
}

@end
