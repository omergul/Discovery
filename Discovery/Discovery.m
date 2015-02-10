//
//  Discovery.m
//  DiscoveryExample
//
//  Created by Ömer Faruk Gül on 08/02/15.
//  Copyright (c) 2015 Ömer Faruk Gül. All rights reserved.
//

#import "Discovery.h"

@implementation Discovery
-(instancetype)initWithUUID:(CBUUID *)uuid {
    self = [super init];
    if(self) {
        _uuid = uuid;
    }
    
    return self;
}
@end
