//
//  EMBeacon.h
//  ibeacons-skeleton
//
//  Created by Ennio Masi on 03/06/14.
//  Copyright (c) 2014 Ennio Masi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMBeacon : NSObject

@property (nonatomic) NSInteger enteringCount;
@property (nonatomic, strong) UIColor *notificationColor;
@property (nonatomic, strong) NSArray *notificationTexts;
@property (nonatomic, strong) NSString *proximityUUID;
@property (nonatomic, strong) NSDate *latestRangingDate;

- (NSString *)currentText;

@end