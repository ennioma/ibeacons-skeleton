//
//  EMBeacon.m
//  ibeacons-skeleton
//
//  Created by Ennio Masi on 03/06/14.
//  Copyright (c) 2014 Ennio Masi. All rights reserved.
//

#import "EMBeacon.h"

@implementation EMBeacon

@synthesize enteringCount = _enteringCount;
@synthesize latestRangingDate = _latestRangingDate;
@synthesize notificationColor = _notificationColor;
@synthesize notificationTexts = _notificationTexts;
@synthesize proximityUUID = _proximityUUID;

- (id) init {
    self = [super init];
    
    if (self) {
        self.enteringCount = 0;
    }
    
    return self;
}

- (NSString *)currentText {
    return [self.notificationTexts objectAtIndex:self.enteringCount % self.notificationTexts.count];
}

@end