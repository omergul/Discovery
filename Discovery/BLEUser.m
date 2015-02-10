//
//  BLEUser.m
//  Discover
//
//  Created by Ömer Faruk Gül on 1/23/14.
//  Copyright (c) 2014 Louvre Digital. All rights reserved.
//

#import "BLEUser.h"


@implementation BLEUser

- (id)init {
    self = [super init];
    if(self) {
        self.easedProximity = [[EasedValue alloc] init];
    }
    
    return self;
}

- (void)setRssi:(float)rssi {
    _rssi = rssi;
    _proximity = [self convertRSSItoProximity:rssi];
}

- (NSInteger)convertRSSItoProximity:(NSInteger)rssi {
    // eased value doesn't support negative values
    self.easedProximity.value = fabsf(rssi);
    [self.easedProximity update];
    NSInteger proximity = self.easedProximity.value * -1.0f;
    
    return proximity;
}

@end
