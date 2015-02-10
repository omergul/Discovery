//
//  LLUtility.h
//  DailyPulse
//
//  Created by Ömer Faruk Gül on 2/19/13.
//  Copyright (c) 2013 √ñmer Faruk G√ºl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIColor+Hex.h>
#import <ViewUtils.h>
#import "LLControl.h"

/*
 *  System Versioning Preprocessor Macros
 */

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@interface LLUtility : NSObject
+ (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message;
+ (BOOL)isObjNull:(id)obj;
@end
