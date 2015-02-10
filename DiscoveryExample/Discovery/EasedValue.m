//
//  EasedValue.m
//  
//
//  Created by Ben Purdy on 1/31/13.
//  Copyright (c) 2013 Instrument. All rights reserved.
//

#import "EasedValue.h"

@implementation EasedValue
{
    CGFloat velocity;
    CGFloat targetValue;
    CGFloat currentValue;
}

- (id)init
{
    self = [super init];
    
    velocity = 0.0f;
    targetValue = 0.0f;
    currentValue = 0.0f;
    
    return self;
}

- (void)setValue:(CGFloat)value
{
    targetValue = value;
}

- (CGFloat)value
{
    return currentValue;
}

- (void)update
{
    // determine speed at which the ease will happen
    // this is based on difference between target and current value
    velocity += (targetValue - currentValue) * 0.01f;
    velocity *= 0.7f;
    
    // ease the current value
    currentValue += velocity;
    
    // limit how small the ease can get
    if(fabsf(targetValue - currentValue) < 0.001f){
        currentValue = targetValue;
        velocity = 0.0f;
    }
    
    // keep above zero
    currentValue = MAX(0.0f, currentValue);
}

- (void)reset
{
    currentValue = targetValue;
}
@end
