//
//  Discovery.m
//  DiscoveryExample
//
//  Created by Ömer Faruk Gül on 08/02/15.
//  Copyright (c) 2015 Ömer Faruk Gül. All rights reserved.
//

#import "Discovery.h"

@interface Discovery()
@property (nonatomic, copy) void (^usersBlock)(NSArray *users, BOOL usersChanged);
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation Discovery
- (instancetype)initWithUUID:(CBUUID *)uuid
                 username:(NSString *)username
                  usersBlock:(void (^)(NSArray *users, BOOL usersChanged))usersBlock {
    self = [super init];
    if(self) {
        _uuid = uuid;
        _username = username;
        _usersBlock = usersBlock;
        
        _paused = NO;
        
        _userTimeoutInterval = 3;
        _updateInterval = 2;
        
        // listen for UIApplicationDidEnterBackgroundNotification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appDidEnterBackground:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        
        // listen for UIApplicationDidEnterBackgroundNotification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appWillEnterForeground:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        
        
        // we will hold the detected users here
        self.usersMap = [NSMutableDictionary dictionary];
        
        // start the central and peripheral managers
        self.queue = dispatch_queue_create("com.omerfarukgul.discovery", DISPATCH_QUEUE_SERIAL);
        
        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:self.queue];
        self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:self.queue];
        
        [self startTimer];
    }
    
    return self;
}


- (void)startTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.updateInterval target:self
                                                selector:@selector(checkList) userInfo:nil repeats:YES];
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)setUpdateInterval:(NSTimeInterval)updateInterval {
    _updateInterval = updateInterval;
    
    // restart the timers
    [self stopTimer];
    [self startTimer];
}

- (void)setPaused:(BOOL)paused {
    
    if(_paused == paused)
        return;
    
    _paused = paused;
    
    if(paused) {
        [self stopTimer];
        [self.centralManager stopScan];
    }
    else {
        [self startTimer];
        [self startDetecting];
    }
}

- (void)appDidEnterBackground:(NSNotification *)notification {
    [self startTimer];
}

- (void)appWillEnterForeground:(NSNotification *)notification {
    [self stopTimer];
}

- (void)startAdvertising {
    
    NSDictionary *advertisingData = @{CBAdvertisementDataLocalNameKey:self.username,
                                      CBAdvertisementDataServiceUUIDsKey:@[self.uuid]
                                      };
    
    // create our characteristics
    CBMutableCharacteristic *characteristic =
    [[CBMutableCharacteristic alloc] initWithType:self.uuid
                                       properties:CBCharacteristicPropertyRead
                                            value:[self.username dataUsingEncoding:NSUTF8StringEncoding]
                                      permissions:CBAttributePermissionsReadable];
    
    // create the service with the characteristics
    CBMutableService *service = [[CBMutableService alloc] initWithType:self.uuid primary:YES];
    service.characteristics = @[characteristic];
    [self.peripheralManager addService:service];
    
    [self.peripheralManager startAdvertising:advertisingData];
}

- (void)startDetecting {
    
    NSDictionary *scanOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@(YES)};
    NSArray *services = @[self.uuid];
    
    // we only listen to the service that belongs to our uuid
    // this is important for performance and battery consumption
    [self.centralManager scanForPeripheralsWithServices:services options:scanOptions];
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error {
    
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    if(peripheral.state == CBPeripheralManagerStatePoweredOn) {
        [self startAdvertising];
    }
    else {
        //NSLog(@"Peripheral manager state: %d", peripheral.state);
    }
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state == CBCentralManagerStatePoweredOn) {
        [self startDetecting];
    }
    else {
        //NSLog(@"Central manager state: %d", central.state);
    }
}

- (void)updateList {
    [self updateList:YES];
}

- (void)updateList:(BOOL)usersChanged {
    // sort
    NSMutableArray *users = [[[self usersMap] allValues] mutableCopy];
    
    // we sort the list according to "proximity".
    // so the client will receive ordered users according to the proximity.
    [users sortUsingDescriptors: [NSArray arrayWithObjects: [NSSortDescriptor sortDescriptorWithKey:@"proximity"
                                                                                          ascending:NO], nil]];
    
    if(self.usersBlock) {
        self.usersBlock(users, usersChanged);
    }
}

- (void)checkList {
    
    double currentTime = [[NSDate date] timeIntervalSince1970];
    
    BOOL isRemovedUser = NO;
    
    for (NSString* key in self.usersMap) {
        BLEUser *bleUser = [self.usersMap objectForKey:key];
        
        NSTimeInterval diff = currentTime - bleUser.updateTime;
        
        // We remove the user if we haven't seen him for the userTimeInterval amount of seconds.
        // You can simply set the userTimeInterval variable anything you want.
        if(diff > self.userTimeoutInterval) {
            isRemovedUser = YES;
            [self.usersMap removeObjectForKey:key];
        }
    }
    
    // update the list if we removed a user.
    if(isRemovedUser) {
        [self updateList];
    }
    else {
        // simply update the list, because the order of the users may have changed.
        [self updateList:NO];
    }
}

- (BLEUser *)userWithPeripheralId:(NSString *)peripheralId {
    return [self.usersMap valueForKey:peripheralId];
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
    //NSLog(@"User is discovered: %@ %@ at %@", peripheral.name, peripheral.identifier, RSSI);
    
    NSString *username = advertisementData[CBAdvertisementDataLocalNameKey];

    //NSLog(@"Discovered name : %@", name);
    
    BLEUser *bleUser = [self userWithPeripheralId:peripheral.identifier.UUIDString];
    if(bleUser == nil) {
        //NSLog(@"Adding ble user: %@", name);
        bleUser = [[BLEUser alloc] initWithPerpipheral:peripheral];
        bleUser.username = nil;
        bleUser.identified = NO;
        bleUser.peripheral.delegate = self;
        
        [self.usersMap setObject:bleUser forKey:bleUser.peripheralId];
    }
    
    if(!bleUser.isIdentified) {
        // We check if we can get the username from the advertisement data,
        // in case the advertising peer application is working at foreground
        // if we get the name from advertisement we don't have to establish a peripheral connection
        if (username != (id)[NSNull null] && username.length > 0 ) {
            bleUser.username = username;
            bleUser.identified = YES;
            
            // we update our list for callback block
            [self updateList];
        }
        else {
            // nope we could not get the username from CBAdvertisementDataLocalNameKey,
            // we have to connect to the peripheral and try to get the characteristic data
            // add we will extract the username from characteristics.
            
            if(peripheral.state == CBPeripheralStateDisconnected) {
                [self.centralManager connectPeripheral:peripheral options:nil];
            }
        }
    }
    
    // update the rss and update time
    bleUser.rssi = [RSSI floatValue];
    bleUser.updateTime = [[NSDate date] timeIntervalSince1970];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Peripheral connection failure: %@. (%@)", peripheral, [error localizedDescription]);
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    BLEUser *user = [self userWithPeripheralId:peripheral.identifier.UUIDString];
    NSLog(@"Peripheral Connected: %@", user);
    
    // Search only for services that match our UUID
    // the connection does not guarantee that we will discover the services.
    // if the device is too far away, it may not be possible to discover the service we want.
    [peripheral discoverServices:@[self.uuid]];
}


#pragma mark - CBPeripheralDelegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    // loop the services
    // since we are looking forn only one service, services array probably contains only one or zero item
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    //BLEUser *user = [self userWithPeripheralId:peripheral.identifier.UUIDString];
    //NSLog(@"Did discover characteristics of: %@ - %@", user.username, service.characteristics);
    
    if (!error) {
        // loop through to find our characteristic
        for (CBCharacteristic *characteristic in service.characteristics) {
            if ([characteristic.UUID isEqual:self.uuid]) {
                [peripheral readValueForCharacteristic:characteristic];
                //[peripheral setNotifyValue:YES forCharacteristic:characteristic];
            }
        }
    }
    
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSString *valueStr = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    //NSLog(@"CBCharacteristic updated value: %@", valueStr);
    
    // if the value is not nil, we found our username!
    if(valueStr != nil) {
        BLEUser *user = [self userWithPeripheralId:peripheral.identifier.UUIDString];
        user.username = valueStr;
        user.identified = YES;
        
        [self updateList];
        
        // cancel the subscription to our characteristic
        [peripheral setNotifyValue:NO forCharacteristic:characteristic];
        
        // and disconnect from the peripehral
        [self.centralManager cancelPeripheralConnection:peripheral];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"Characteristic Update Notification: %@", error);
}

@end
