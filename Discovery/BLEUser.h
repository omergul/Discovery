//
//  BLEUser.h
//  Discover
//
//  Created by Ömer Faruk Gül on 1/23/14.
//  Copyright (c) 2014 Ömer Farul Gül. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>
#import "EasedValue.h"

@interface BLEUser : NSObject

- (id)initWithPerpipheral:(CBPeripheral *)peripheral;

@property (strong, nonatomic, readonly) CBPeripheral *peripheral;
@property (strong, nonatomic, readonly) NSString *peripheralId;

// the unique id for our user.
@property (strong, nonatomic) NSString *username;
// indicates wheather the user's username is extracted from the peer device.
@property (nonatomic, getter=isIdentified) BOOL identified;

// rssi
@property (nonatomic) float rssi;
// proximity calculated by EasedValue class.
@property (nonatomic, readonly) NSInteger proximity;

// the last seen time of the user
@property (nonatomic) double updateTime;
@end
