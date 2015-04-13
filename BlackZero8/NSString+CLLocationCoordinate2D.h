//
//  NSString+NSString_CLCoordinate2D.h
//  BlackZero8
//
//  Created by Manjit Bedi on 2014-04-10.
//  Copyright (c) 2014 Manjit Bedi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKGeometry.h>

@interface NSString (NSString_CLCoordinate2D)

+ (NSString *) NSStringFromCLLocationCoordinate2D:(CLLocationCoordinate2D) coordinate;

@end
