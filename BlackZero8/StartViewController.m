//
//  SpOpsStartViewController.m
//  BlackZero8
//
//  Created by Manjit Bedi on 2014-01-25.
//  Copyright (c) 2014 Manjit Bedi. All rights reserved.
//

#import "StartViewController.h"
#import "PSLocationManager.h"
#import "DownloadManager.h"

#import "StateObject.h"

@interface StartViewController ()

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    _appVersionLabel.text = [NSString stringWithFormat:@"Version %@", [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    
    _appVersionLabel.font = [UIFont fontWithName:@"Isonorm MN" size:20];
    
    
	// Do any additional setup after loading the view.
    [[PSLocationManager sharedLocationManager] prepLocationUpdates];
    [[PSLocationManager sharedLocationManager] startLocationUpdates];
    DownloadManager *downloadManager = [DownloadManager sharedManager];
    [downloadManager downloadManifest];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(next) name:kDownloadsCompleted object:downloadManager];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(manifestDownloaded) name:kManifestDownloaded object:downloadManager];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(missionDownloaded:) name:kMissionDownloaded object:downloadManager];
}


- (void) manifestDownloaded {
    
    _infoLabel.text = @"Manifest downloaded";
    
}


- (void) missionDownloaded:(NSNotification *) notification {
    NSString *missionInfoStr = [NSString stringWithFormat:@"%@ downloaded", [notification.userInfo objectForKey:@"name"]];
    _infoLabel.text = missionInfoStr;
}


- (void) next {
    // It is important to do this here after the dialogue manager has downloaded has set up the data.
    
    [self performSelector:@selector(gotoHomeView) withObject:self afterDelay:2.0f];
}

- (void) gotoHomeView {
    [StateObject sharedManager];
    [self performSegueWithIdentifier:@"goMenu" sender:self];
}

@end
