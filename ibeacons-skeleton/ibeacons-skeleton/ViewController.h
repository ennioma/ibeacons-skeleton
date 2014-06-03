//
//  ViewController.h
//  ibeacons-skeleton
//
//  Created by Ennio Masi on 01/06/14.
//  Copyright (c) 2014 Ennio Masi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController<CBCentralManagerDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *messagingTV;
@property (weak, nonatomic) IBOutlet UIView *notificationArea;

@property (nonatomic, strong) NSDictionary *beacons;
@property (nonatomic, strong) NSMutableDictionary *regions;

@property (nonatomic, strong) CBCentralManager *bleCentralManager;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end
