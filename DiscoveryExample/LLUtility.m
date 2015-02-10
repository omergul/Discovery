//
//  LLUtility.m
//  DailyPulse
//
//  Created by Ömer Faruk Gül on 2/19/13.
//  Copyright (c) 2013 √ñmer Faruk G√ºl. All rights reserved.
//

#import "LLUtility.h"


@implementation LLUtility

+ (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
+ (BOOL)isObjNull:(id)obj
{
    if(nil == obj || NSNull.null == obj)
        return YES;
    else
        return NO;
}
@end
