//
//  LLControl.m
//  Mask
//
//  Created by Ömer Faruk Gül on 12/4/13.
//  Copyright (c) 2013 Louvre Digital. All rights reserved.
//

#import "LLControl.h"
#import "PlainTextField.h"
#import <EDColor.h>

@implementation LLControl
+ (UIButton *)whiteButton:(NSString *)title
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
    button.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:22.0f];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"E8E8E8"] forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    //button.titleEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20);
    return button;
}

+(UITextField *)textfild:(NSString *)placeholder
{
    UITextField *textfield = [[PlainTextField alloc] initWithFrame:CGRectZero];
    textfield.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    textfield.font = [UIFont systemFontOfSize:33];
    textfield.adjustsFontSizeToFitWidth = YES;
    textfield.textColor = [UIColor darkGrayColor];
    textfield.placeholder = placeholder;
    return textfield;
}

@end
