//
//  PickUp.h
//  BlackZero8
//
//  Created by Manjit Bedi on 2014-01-03.
//  Copyright (c) 2014 Manjit Bedi. All rights reserved.
//

#import <Foundation/Foundation.h>

// medical, weaponry, communications, supplies, navigation, extras

typedef NS_ENUM(NSUInteger, PickUpCategory) {
    PickUpCategoryMedical,
    PickUpCategoryWeaponry,
    PickUpCategoryCommunication,
    PickUpCategorySupply,
    PickUpCategoryNavigation,
    PickUpCategoryExtra
};

@interface PickUp : NSObject
@property NSUInteger identifier;
@property PickUpCategory category;
@property NSUInteger points;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *imageName;
@property BOOL expanded;        // this is used when displaying items in the inventory table view

@end
