//
//  DownloadManager.m
//  BlackZero8
//
//  Created by Manjit Bedi on 2013-12-28.
//  Copyright (c) 2013 Manjit Bedi. All rights reserved.
//

#import "AFNetworking.h"
#import "DownloadManager.h"
#import "SSZipArchive.h"

// Data Model
#import "BZMission.h"
#import "Event.h"

@interface DownloadManager ()

@property (strong, nonatomic) NSArray *missionDicts;
@property NSUInteger numberOfDownloads;
@property NSUInteger numberOfDownloadsCompleted;

@end

@implementation DownloadManager

+ (id)sharedManager {
    static DownloadManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}


- (id)init {
    if (self = [super init]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documentsDir = [paths objectAtIndex:0];
        _missions = [[NSMutableArray alloc] initWithCapacity:6];
        _numberOfDownloads = 0;
        
        [self loadDownloadData];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"missions" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        if(data) {
            NSError *error;
            self.missionDicts = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];

        }
    }
    return self;
}


// TODO : re-factor.
- (BOOL) areMissionsInstalled {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *listOfFiles = [fileManager contentsOfDirectoryAtPath:_documentsDir error:nil];
    if(listOfFiles == nil || [listOfFiles count] == 0)
        return NO;
    
    NSURL *directoryToScan = [NSURL fileURLWithPath:_documentsDir];
    NSDirectoryEnumerator *dirEnumerator = [fileManager enumeratorAtURL:directoryToScan
                                                  includingPropertiesForKeys:[NSArray arrayWithObjects:NSURLNameKey,
                                                                              NSURLIsDirectoryKey,nil]
                                                                     options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                errorHandler:nil];
    
    // Enumerate the dirEnumerator results, each value is stored in allURLs
    for (NSURL *theURL in dirEnumerator) {
        // Retrieve the file name. From NSURLNameKey, cached during the enumeration.
        NSString *fileName;
        [theURL getResourceValue:&fileName forKey:NSURLNameKey error:NULL];
        // Retrieve whether a directory. From NSURLIsDirectoryKey, also cached during the enumeration.
        NSNumber *isDirectory;
        [theURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:NULL];
        if([isDirectory boolValue])
            return YES;
    }
    
    return NO;
}


- (void) installLocalContent {
    // Some missions are bundled with the app
    // Install them
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"missions" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // Date format from server: 2014-01-23 21:04:20
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    if(data) {
        NSError *error;
        self.missionDicts = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if(_missionDicts) {
            
            // 
            NSLog(@"There are %lu missions in the app bundle", (unsigned long)[_missionDicts count]);
            NSMutableArray *bundledMissionList = [NSMutableArray array];
            for (BZMission *aMission in _missionDicts) {
                [bundledMissionList addObject: [aMission valueForKey:@"missionName"]];
            }
            NSLog(@"It's missions %@", bundledMissionList);
            
            for(NSDictionary *dict in _missionDicts) {
                NSString *zipFileName = [dict objectForKey:@"fileName"];
                if(zipFileName) {
                    NSString *folderName = [zipFileName stringByDeletingPathExtension];
                    NSLog(@"download mission to path '%@'", folderName);

                    NSString *destinationPath = [_documentsDir stringByAppendingPathComponent:folderName];
                    NSString *sourceFilePath = [[NSBundle mainBundle] pathForResource:zipFileName ofType:nil];
                    if([SSZipArchive unzipFileAtPath:sourceFilePath toDestination:destinationPath]) {
                        BZMission *newMission = [[BZMission alloc] init];
                        newMission.name = [dict objectForKey:@"missionName"];
                        newMission.subfolderName  = [destinationPath copy];
                        newMission.isBundled = YES;
                        NSString *lastModifiedString = [dict objectForKey:@"published"];
                        newMission.lastModified = [dateFormatter dateFromString: lastModifiedString];
                        NSError *error;
                        NSString *filePath = [newMission.subfolderName stringByAppendingString:@"/mission.json"];
                        NSData *data = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&error];
                        if(error) {
                            NSLog(@"%@", [error localizedDescription]);
                        } else {
                            
                            if([newMission processDataForMission:data])
                                [_missions addObject:newMission];
                            else
                                NSLog(@"mission %@ could not be processed, bad data", newMission.name);
                        }
                    }
                }
            }
        } else if (error){
            NSLog(@"JSON %@", [error localizedDescription]);
        }
    }
    
    [self saveDownloadData];
}


- (BOOL) downloadManifest {
    __block BOOL status;
    
#if DEBUG > 1
    NSLog(@"Download manifest from remote server: %@", kManifestURL);
#endif
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:kManifestURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kManifestDownloaded object:self];
        
        
        [self processMissionsManifest:responseObject];
        status = YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        status = NO;
    }];

    
    return status;
}


- (void) processMissionsManifest:(id) manifest {
    // Check the class type for the object; is it an array?
    BOOL downloading = NO;
    if([manifest isKindOfClass:[NSArray class]]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        // Date format from server: 2014-01-23 21:04:20
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];


        // Check installed missions against the missions in the manifest
        NSArray *missionsOnWebsite = manifest;
        
        
        for(NSDictionary *missionDict in missionsOnWebsite){            // for each mission info in manifest.json...
            BOOL missionNotDownloaded = TRUE;
            NSString *remoteMissionName = [missionDict objectForKey:@"missionName"];
            
            // Iterate through the missions in the Manifest and the locally installed
            // missions.
            
            // If the file creation date for the installed mission is earlier then
            // the last modifed date for the mission on the server, download the mission
            // and install it locally.
            
            for(BZMission *installedMission in _missions){
                NSString *installedMissionName = installedMission.name;
                if([installedMissionName isEqualToString:remoteMissionName]) {
                    missionNotDownloaded = FALSE;
                    
#if DEBUG > 1
                    NSLog(@"mission '%@' exists - do date check", installedMissionName);
#endif
                    
                    // Get the date that manifest.json says the mission was last updated
                    // This is marked at UTC in the manifest
                    NSString *lastModifiedStr = [missionDict objectForKey:@"lastModified"];
                    NSDate *lastModifiedDate = [dateFormatter dateFromString:lastModifiedStr];
                    
                    
                    // Get the last updated info for the mission
                    NSDate *lastModifiedLocalDate = installedMission.lastModified;

#if DEBUG > 1
                    NSLog(@"\nlocal modification date %@\nremote publication date %@", lastModifiedLocalDate, lastModifiedDate);
#endif
                    // compare string to file creation time for mission locally
                    NSDate *result = [lastModifiedLocalDate laterDate:lastModifiedDate];
                    if(result == lastModifiedDate){
                        // Ok, download the mission and unzip it!
                        NSLog(@"Downloading updated version of mission %@ from server",installedMissionName);
                        [self addMissionToQueue:[missionDict objectForKey:@"URL"]];
                        downloading = YES;
                    }
                } 
            }
            
            // If the mission have not been found in the installed missions, download it now.
            if(missionNotDownloaded == TRUE) {
                // This might mess up by adding a new mission while enumerating through the array of
                // missions. TODO: re-factor
#if DEBUG > 1
                NSLog(@"new mission '%@' download it", remoteMissionName);
#endif
                [self addMissionToQueue:[missionDict objectForKey:@"URL"]];
                downloading = YES;
            }
        }
    }
    
    if(downloading == NO)
        [[NSNotificationCenter defaultCenter] postNotificationName:kDownloadsCompleted object:self]; 
}


-(NSDate *) toGlobalTime:(NSDate *)date {
    NSTimeZone *tz = [NSTimeZone localTimeZone];
    NSInteger seconds = -[tz secondsFromGMTForDate:date];
    return [NSDate dateWithTimeInterval: seconds sinceDate:date];
}



// Check if missions with the specified file name exists in the documents folders
// The mission file name is the name of a folder. The audio files etc would be in the folder.
- (BOOL) isMissionDownloaded:(NSString *) missionName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [_documentsDir stringByAppendingFormat:@"/%@", missionName];
    return [fileManager fileExistsAtPath:filePath];
}


// TODO: this does not use a queue at the moment.  Will this work as is?
- (void) addMissionToQueue:(NSString *) remotePath {
    _numberOfDownloads++;
    NSString *folderName = [[remotePath lastPathComponent] stringByDeletingPathExtension];
    NSLog(@"download mission to path '%@'", folderName);
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:remotePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryPath = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]];
        return [documentsDirectoryPath URLByAppendingPathComponent:[targetPath lastPathComponent]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        NSString *destinationPath = [_documentsDir stringByAppendingPathComponent:folderName];
        // Install the mission in the documents folder.  The folder name is derived
        // from the zip file name less the extension.
        if([SSZipArchive unzipFileAtPath:[filePath path] toDestination:destinationPath]) {
            BZMission *newMission = [[BZMission alloc] init];
            newMission.subfolderName  = [destinationPath copy];
            newMission.isDownloaded = YES;
            NSError *error;
            NSString *filePathStr = [newMission.subfolderName stringByAppendingString:@"/mission.json"];
            NSData *data = [NSData dataWithContentsOfFile:filePathStr options:NSDataReadingMappedIfSafe error:&error];
            if(error) {
                NSLog(@"%@", [error localizedDescription]);
            } else {
                if([newMission processDataForMission:data]) {
                    [_missions addObject:newMission];
                    [self updateMission:newMission];
                }else
                    NSLog(@"mission %@ could not be processed, bad data", newMission.name);
            }

            NSDictionary *userDict = @{ @"name" : newMission.name};
            [[NSNotificationCenter defaultCenter] postNotificationName:kMissionDownloaded object:self userInfo:userDict];
            
            // Now delete the zip file!
            [[NSFileManager defaultManager] removeItemAtPath:[filePath path] error:nil];
        }
        
        // TODO: What do if the unzipping failed
        _numberOfDownloadsCompleted++;
        
        NSLog(@"downloaded %lu of %lu", (unsigned long)_numberOfDownloadsCompleted, (unsigned long)_numberOfDownloads );
        if(_numberOfDownloadsCompleted == _numberOfDownloads) {
            [self saveDownloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:kDownloadsCompleted object:self];
        }
    }];
    [downloadTask resume];
}



// If the mission exists update it otherwise add the mission
- (void) updateMission:(BZMission *) missionToUpdate {
    BOOL missionFound = false;
    for(BZMission *mission in _missions) {
        if([mission.name isEqualToString:missionToUpdate.name]){
            missionFound = YES;
            mission.name = missionToUpdate.name;
            mission.duration = missionToUpdate.duration;
            mission.events = missionToUpdate.events;
            mission.lastModified = missionToUpdate.lastModified;
        }
    }

    if(missionFound == NO)
        [_missions addObject:missionToUpdate];
}

#pragma mark -
// TODO: should this be changed to use Core Data?
- (void) saveDownloadData {
    NSMutableDictionary *saveDict = [[NSMutableDictionary alloc] init];
    NSMutableArray *missonsArray = [[NSMutableArray alloc] initWithCapacity:[_missions count]];
    for(BZMission *mission in _missions) {
        NSMutableDictionary *dataToSave = [[NSMutableDictionary alloc] initWithCapacity:5];
        [dataToSave setObject:mission.name forKey:@"name"];
        [dataToSave setObject:mission.desc forKey:@"description"];
        [dataToSave setObject:[NSNumber numberWithDouble:mission.duration] forKey:@"duration"];
        [dataToSave setObject:[NSNumber numberWithBool:mission.completed] forKey:@"completed"];
        [dataToSave setObject:mission.subfolderName forKey:@"subFolderName"];
        [dataToSave setObject:mission.lastModified forKey:@"lastModified"];
        [dataToSave setObject:[NSNumber numberWithDouble: mission.lastTime] forKey:@"lastTime"];
        [dataToSave setObject:[NSNumber numberWithDouble: mission.bestTime] forKey:@"bestTime"];
        [dataToSave setObject:[NSNumber numberWithDouble: mission.lastDistance] forKey:@"lastDistance"];
        [dataToSave setObject:[NSNumber numberWithDouble: mission.bestDistance] forKey:@"bestDistance"];
        [dataToSave setObject:[NSNumber numberWithDouble: mission.lastSpeed] forKey:@"lastSpeed"];
        [dataToSave setObject:[NSNumber numberWithDouble: mission.bestSpeed] forKey:@"bestSpeed"];
        [missonsArray addObject:dataToSave];
    }
    [saveDict setObject:missonsArray forKey:@"missions"];
    NSString *path = [_documentsDir stringByAppendingString:@"/data"];
    [saveDict writeToFile:path atomically:NO];
}
    
    
- (void) loadDownloadData {
    // goes through the local data area, setting up missions for what it finds there
    NSString *path = [_documentsDir stringByAppendingString:@"/data"];
    NSDictionary *loadedDataDict = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSArray *temp = [loadedDataDict objectForKey:@"missions"];
    // Create mission objects from the foundation objects
    for(NSDictionary *dictionary in temp){
        BZMission *newMission = [[BZMission alloc] init];
        newMission.name = [dictionary objectForKey:@"name"];
        newMission.desc = [dictionary objectForKey:@"description"];
        newMission.duration = [[dictionary objectForKey:@"duration"] unsignedLongValue];
        newMission.subfolderName = [dictionary objectForKey:@"subFolderName"];
        newMission.completed = [[dictionary objectForKey:@"completed"] boolValue];
        newMission.lastModified = [dictionary objectForKey:@"lastModified"];
        newMission.lastTime = [[dictionary objectForKey:@"lastTime"] doubleValue];
        newMission.bestTime = [[dictionary objectForKey:@"bestTime"] doubleValue];
        newMission.lastDistance = [[dictionary objectForKey:@"lastDistance"] doubleValue];
        newMission.bestDistance = [[dictionary objectForKey:@"lastDistance"] doubleValue];
        newMission.lastSpeed = [[dictionary objectForKey:@"lastSpeed"] doubleValue];
        newMission.bestSpeed = [[dictionary objectForKey:@"lastSpeed"] doubleValue];
        
        
        NSError *error;
        NSString *filePath = [newMission.subfolderName stringByAppendingString:@"/mission.json"];
        NSData *data = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&error];
        if(error) {
            NSLog(@"%@", [error localizedDescription]);
        } else {
            if([newMission processDataForMission:data])
                [_missions addObject:newMission];
            else
                NSLog(@"mission %@ could not be processed, bad data", newMission.name);
        }
    }
}


- (void) saveResults {
    
    [self saveDownloadData];
}

- (void) loadResults {
    [self loadDownloadData];
}

@end
