//
//  BLEUser.h
//  Discover
//
//  Created by Ömer Faruk Gül on 1/23/14.
//  Copyright (c) 2014 Louvre Digital. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>
#import "EasedValue.h"

@interface BLEUser : NSObject
@property (strong, nonatomic) NSString *peripheralId;
@property (strong, nonatomic) NSString *name;
@property (nonatomic) float rssi;
@property (nonatomic) NSInteger proximity;
@property (strong, nonatomic) EasedValue *easedProximity;
@property (nonatomic) double updateTime;
@property (strong, nonatomic) CBPeripheral *peripheral;
@end
