//
//  BaseViewController.m
//  BlackZero8
//
//  Created by Manjit Bedi on 2013-12-26.
//  Copyright (c) 2013 Manjit Bedi. All rights reserved.
//

#import "constants.h"
#import "BaseViewController.h"
#import "MenuViewController.h"

#define kExposedWidth  260

@interface BaseViewController ()

@end

@implementation BaseViewController

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    UIImage *image = [UIImage imageNamed:@"BackgroundImage"];
    CGRect newFrame = self.view.frame;
    newFrame.origin.y = 60;
    _backgroundImageView = [[UIImageView alloc] initWithImage:image];
    _backgroundImageView.frame = newFrame;
    [self.view insertSubview:_backgroundImageView atIndex:0];

    for(UIButton *button in _smallButtons) {
        button.titleLabel.font = [UIFont fontWithName:customFontName size:14];
    }
        
    for(UIButton *button in _buttons){
        button.titleLabel.font = [UIFont fontWithName:customFontName size:20];
    }
        
    for(UILabel *label in _titles)
        label.font = [UIFont fontWithName:customFontName size:17];
    
    for(UILabel *label in _labels)
        label.font = [UIFont fontWithName:customFontName size:18];

    for(UILabel *label in _labelsSize2)
        label.font = [UIFont fontWithName:customFontName size:12];

    for(UILabel *label in _labelsSize3)
        label.font = [UIFont fontWithName:customFontName size:12];
    
    for(UILabel *label in _counters)
        label.font = [UIFont fontWithName:customFontName size:50.0];
    
    for(UILabel *label in _mediumCounters)
        label.font = [UIFont fontWithName:customFontName size:35.5];
}


- (IBAction)showMenuAction:(id)sender {
    // The main menu button in the top left of every VC
    
    MenuViewController *parentViewController;
    parentViewController = (MenuViewController *) self.parentViewController;
    CGFloat yPos = parentViewController.containerView.frame.origin.y;
    CGSize size = self.view.frame.size;
    if (!parentViewController.isMenuVisible) {
        parentViewController.isMenuVisible = YES;
        [UIView animateWithDuration:0.5 animations:^{
            parentViewController.containerView.frame = CGRectMake(kExposedWidth, yPos, size.width, size.height);
        }];
    } else {
        parentViewController.isMenuVisible = NO;
        [UIView animateWithDuration:0.5 animations:^{
            parentViewController.containerView.frame = CGRectMake(0, yPos, size.width, size.height);
        }];
    }
}

- (void) moveToNewViewController: (NSString *) storyboardID {
    // called from a child view controller, this will hand control to the new VC
    // identified in storyboardID

    
    
    
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *newVC = [storyboard instantiateViewControllerWithIdentifier: storyboardID];
    
    [self.navigationController pushViewController:newVC animated:YES];

    
    
    
//    UIViewController *parentViewController = [self parentViewController];

    
    
    //
//    [parentViewController addChildViewController:newVC];
//    [newVC.view layoutIfNeeded]; // ensures viewDidLoad called before animation starts
//    
//    [self willMoveToParentViewController:nil];
//    
//    [parentViewController transitionFromViewController:self
//                                      toViewController:newVC
//                                              duration:0.5
//                                               options:UIViewAnimationOptionTransitionCrossDissolve
//                                            animations:^{
//                                            }
//                                            completion:^(BOOL finished) {
//                                                [newVC didMoveToParentViewController:parentViewController];
//                                                [self removeFromParentViewController];
//                                            }];
//    
//    [newVC didMoveToParentViewController:parentViewController];
//    [self removeFromParentViewController];
}


@end
