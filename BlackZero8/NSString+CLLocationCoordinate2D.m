//
//  NSString+NSString_CLCoordinate2D.m
//  BlackZero8
//
//  Created by Manjit Bedi on 2014-04-10.
//  Copyright (c) 2014 Manjit Bedi. All rights reserved.
//

#import "NSString+CLLocationCoordinate2D.h"

@implementation NSString (NSString_CLCoordinate2D)


+ (NSString *) NSStringFromCLLocationCoordinate2D:(CLLocationCoordinate2D) coordinate {
    
    return [NSString stringWithFormat:@"{ %02.02f %02.02f}", coordinate.latitude, coordinate.longitude];
}

@end
