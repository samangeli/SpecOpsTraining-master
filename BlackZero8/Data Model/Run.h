//
//  Run.h
//  BlackZero8
//
//  Created by Manjit Bedi on 2014-04-08.
//  Copyright (c) 2014 Manjit Bedi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Run : NSManagedObject

@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSNumber * calories;
@property (nonatomic, retain) NSNumber * averagePace;

@end
