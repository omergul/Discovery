//
//  Discovery.h
//  DiscoveryExample
//
//  Created by Ömer Faruk Gül on 08/02/15.
//  Copyright (c) 2015 Ömer Faruk Gül. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>
#import "BLEUser.h"

@interface Discovery : NSObject<CBCentralManagerDelegate, CBPeripheralManagerDelegate, CBPeripheralDelegate>


/**
 * Initialize the Discovery object with a UUID specific to your app, and a username specific to your device.
 * The usersBlock is triggered periodically in order of users' proximity. It
 */
- (instancetype)initWithUUID:(CBUUID *)uuid
                    username:(NSString *)username
                  usersBlock:(void (^)(NSArray *users, BOOL usersChanged))usersBlock;

/**
 * Returns the user user from our user dictionary according to its peripheralId.
 */
- (BLEUser *)userWithPeripheralId:(NSString *)peripheralId;

/**
 * UUID is used for id as advertisement, peripheral services and characteristics.
 * It should be unique to you app, not to your device. Otherwise the peers won't be able to discover each other.
 */
@property (strong, nonatomic, readonly) CBUUID *uuid;

/**
 * This is the value that should be unique to your device.
 * The users will be identified with username. This value is advertised as the user ID.
 */
@property (strong, nonatomic, readonly) NSString *username;

/**
 * Central and Peripheral managers and the queue for the manager events.
 */
@property (nonatomic) dispatch_queue_t queue;
@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;

/**
 * Set this to YES, if your app will disappear, or set to NO when it will appear.
 * You don't have to set YES when your app goes to background state, Discovery handles that.
 */
@property (nonatomic, getter=isPaused) BOOL paused;

/*
 * This dictionary holds all the discovered devices related to our UUID.
 * However it also contains the users that are NOT already identified.
 * We use periperal ID's as the keys.
 */
@property (strong, nonatomic) NSMutableDictionary *usersMap;

/*
 * Discovery removes the users if can not re-see them after some amount of time, assuming the device-user is gone.
 * The default value is 3 seconds. You can set your own values.
 */
@property (nonatomic) NSTimeInterval userTimeoutInterval;

/*
 * Update interval is the interval that your usersBlock gets triggered.
 */
@property (nonatomic) NSTimeInterval updateInterval;

@end
