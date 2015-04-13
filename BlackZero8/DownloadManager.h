//
//  DownloadManager.h
//  BlackZero8
//
//  Created by Manjit Bedi on 2013-12-28.
//  Copyright (c) 2013 Manjit Bedi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kManifestDownloaded     @"SpecOpsManifestDownloaded"
#define kDownloadsCompleted     @"SpecOpsDownloadsCompleted"
#define kMissionDownloaded      @"SpecOpsMissionDownloaded"


// TODO : change URL when service is about to go live
#define kManifestURL    @"http://fatpigeons.com/specops/wordpress/wp-content/themes/twentyfourteen-child/downloads/manifest.json"

@interface DownloadManager : NSObject
@property (strong, nonatomic) NSString *documentsDir;

@property (strong, readonly, nonatomic) NSMutableArray *missions;
    
+ (id)sharedManager;

// Return YES if there is at least one mission folder in the documents folder.
- (BOOL) areMissionsInstalled;

// The app will have at least one mission as a zip file in the app bundle.
// Installing the mission will unzip to the Documents folder in the app sandbox.
- (void) installLocalContent;

// Download the latest mission manifest from a remote location.
// The file should be a permalink on the CMS server.
- (BOOL) downloadManifest;

// MissionName is the name of the mission file without the extension (.zip).
// Method returns YES is a directory with the name exits in the documents folder.
- (BOOL) isMissionDownloaded:(NSString *) missionName;

- (void) saveResults;   // save mission data to a local plist
- (void) loadResults;   // load mission data from a local plist


@end
