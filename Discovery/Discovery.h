//
//  Discovery.h
//  DiscoveryExample
//
//  Created by Ömer Faruk Gül on 08/02/15.
//  Copyright (c) 2015 Ömer Faruk Gül. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>

@interface Discovery : NSObject

@property (strong, nonatomic, readonly) CBUUID *uuid;

-(instancetype)initWithUUID:(CBUUID*)uuid;
@end
