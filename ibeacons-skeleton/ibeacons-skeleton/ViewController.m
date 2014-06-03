//
//  ViewController.m
//  ibeacons-skeleton
//
//  Created by Ennio Masi on 01/06/14.
//  Copyright (c) 2014 Ennio Masi. All rights reserved.
//

#import "ViewController.h"

#import "EMBeacon.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize beacons = _beacons;
@synthesize bleCentralManager = _bleCentralManager;
@synthesize locationManager = _locationManager;
@synthesize messagingTV = _messagingTV;
@synthesize notificationArea = _notificationArea;
@synthesize regions = _regions;

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if (![CLLocationManager isRangingAvailable]) {
        self.messagingTV.text = @"Couldn't turn on ranging: Ranging is not available.";
        self.notificationArea.backgroundColor = [UIColor redColor];
    }
    
    self.bleCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    self.bleCentralManager.delegate = self;
    
    [self setupBeaconData];
    [self setupBeaconRegions];
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CB
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    // Determine the state of the peripheral
    if ([central state] == CBCentralManagerStatePoweredOff) {
        self.messagingTV.text = @"CoreBluetooth BLE hardware is powered off";
    }
    else if ([central state] == CBCentralManagerStatePoweredOn) {
        self.messagingTV.text = @"CoreBluetooth BLE hardware is powered on and ready";
    }
    else if ([central state] == CBCentralManagerStateUnauthorized) {
        self.messagingTV.text = @"CoreBluetooth BLE state is unauthorized";
    }
    else if ([central state] == CBCentralManagerStateUnknown) {
        self.messagingTV.text = @"CoreBluetooth BLE state is unknown";
    }
    else if ([central state] == CBCentralManagerStateUnsupported) {
        self.messagingTV.text = @"CoreBluetooth BLE hardware is unsupported on this platform";
    }
}

#pragma mark - CLLocationManager Delegate
- (void) locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    EMBeacon *beacon = [self.beacons objectForKey:region.identifier];
    if (beacon)
        [self.locationManager startRangingBeaconsInRegion:[self.regions objectForKey:region.identifier]];
}

- (void) locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    if ([beacons count] > 0) {
        CLBeacon *closestBeacon = [beacons firstObject];
        
        NSString *key = [[NSString alloc] initWithFormat:@"%@", closestBeacon.proximityUUID.UUIDString];
        EMBeacon *emBeacon = [self.beacons objectForKey:key];
        
        if (emBeacon && [self beaconsDetectedMoreThan:2 onBeacon:closestBeacon]) {
            if (closestBeacon.proximity == CLProximityImmediate) {
                emBeacon.enteringCount++;
                NSLog(@"Beacon Proximity: %d", closestBeacon.proximity);
                NSLog(@"Beacon RSSI: %ld", (long)closestBeacon.rssi);
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                    
                    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.messagingTV.text = [emBeacon currentText];
                            self.notificationArea.backgroundColor = emBeacon.notificationColor;
                        });
                    } else if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground || [[UIApplication sharedApplication] applicationState] == UIApplicationStateInactive) {
                        UILocalNotification *localAlarm = [[UILocalNotification alloc] init];
                        localAlarm.alertBody = [emBeacon currentText];
                        localAlarm.alertAction = @"slide to view";
                        localAlarm.soundName = UILocalNotificationDefaultSoundName;
                        localAlarm.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
                        localAlarm.timeZone = [NSTimeZone defaultTimeZone];
                        localAlarm.applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
                        localAlarm.hasAction = YES;
                        
                        [[UIApplication sharedApplication] scheduleLocalNotification:localAlarm];
                    }
                });
            }
        } else
            NSLog(@"REJECTED the beacon with %@ UUID", closestBeacon);
    } /*else {
        self.messagingTV.text = @"There are currently no Beacons within range.";
    }*/
}

- (void) locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    EMBeacon *beacon = [self.beacons objectForKey:region.identifier];
    if (beacon)
        [self.locationManager startRangingBeaconsInRegion:[self.regions objectForKey:region.identifier]];
}

- (void) locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"[didExitRegion] exit from region %@", region.identifier);
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    if (state == CLRegionStateInside) {
        NSLog(@"[didDetermineState] inside");
    } else {
        NSLog(@"[didDetermineState] outside");
    }
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region
              withError:(NSError *)error {
    NSLog(@"[rangingBeaconsDidFailForRegion] region %@ with error %@", region.identifier, error.description);
}

#pragma beacon management
- (void) setupBeaconData {
    EMBeacon *beacon01 = [[EMBeacon alloc] init];
    beacon01.proximityUUID = @"3BCDCFA4-C34F-416F-99F0-C2FA3AAE24D5";
    beacon01.notificationTexts = @[@"Welcome to the beacon01!", @"Welcome to the beacon01 again!"];
    beacon01.notificationColor = [UIColor colorWithRed:200.0f/255.0f green:110.0f/255.0f blue:223.0f/255.0f alpha:1.0f];

    EMBeacon *beacon02 = [[EMBeacon alloc] init];
    beacon02.proximityUUID = @"9AC5B302-2E84-48E3-BDA7-0690BDF46EDB";
    beacon02.notificationTexts = @[@"Welcome to the beacon02!", @"Welcome to the beacon02 again!"];
    beacon02.notificationColor = [UIColor colorWithRed:251.0f/255.0f green:43.0f/255.0f blue:105.0f/255.0f alpha:1.0f];
    
    self.beacons = [[NSDictionary alloc] initWithObjects:@[beacon01, beacon02] forKeys:@[beacon01.proximityUUID, beacon02.proximityUUID]];
    
    /*
     * TODO: store this data within the Keychain!!
     */
/*    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:FoundBeaconsDataStored];
    foundBeacons = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (!foundBeacons)
        foundBeacons = [[NSMutableDictionary alloc] initWithCapacity:0];*/
}

- (void) setupBeaconRegions {
    self.regions = [[NSMutableDictionary alloc] init];
    for (NSString *proximityUUID in self.beacons) {
        EMBeacon *beacon = [self.beacons objectForKey:proximityUUID];
        CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:beacon.proximityUUID] identifier:beacon.proximityUUID];
        beaconRegion.notifyEntryStateOnDisplay = YES;
        beaconRegion.notifyOnEntry = YES;
        beaconRegion.notifyOnExit = YES;
        [self.locationManager startMonitoringForRegion:beaconRegion];
        [self.regions setObject:beaconRegion forKey:beaconRegion.identifier];
    }
}

- (BOOL) beaconsDetectedMoreThan:(NSInteger)seconds onBeacon:(CLBeacon *)beacon {
    EMBeacon *emBeacon = [self.beacons objectForKey:beacon.proximityUUID.UUIDString];
    
    NSDate *currDate = [NSDate date];
    
    if (emBeacon.latestRangingDate == NULL) {
        emBeacon.latestRangingDate = currDate;
        return YES;
    }
    
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [cal setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    NSDateComponents *dateComponents = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:emBeacon.latestRangingDate toDate:currDate options:0];
    
    if ([dateComponents second] >= seconds) {
        emBeacon.latestRangingDate = currDate;

        return YES;
    }
    
    return NO;
}

@end