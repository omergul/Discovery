//
//  WelcomeViewController.m
//  DiscoveryExample
//
//  Created by Ömer Faruk Gül on 08/02/15.
//  Copyright (c) 2015 Ömer Faruk Gül. All rights reserved.
//

#import "WelcomeViewController.h"
#import <EDColor.h>
#import <Masonry.h>
#import "LLControl.h"
#import <ViewUtils.h>
#import "RegisterViewController.h"

@interface WelcomeViewController ()
@property (strong, nonatomic) UIButton *registerButton;
@property (strong, nonatomic) UILabel *logoLabel;
@end

@implementation WelcomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@" "
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = backButton;
    
    [self addGradientBgLayer:@[[UIColor colorWithHexString:@"1B78F4"], [UIColor colorWithHexString:@"25BAFB"]]];
    
    UIView *superview = self.view;
    
    self.logoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.logoLabel.text = @"Discovery!";
    self.logoLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:40];
    self.logoLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.logoLabel];
    
    [self.logoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superview);
        make.top.equalTo(@50);
    }];
    
    self.registerButton = [LLControl whiteButton:@"Login"];
    [self.registerButton addTarget:self action:@selector(registerButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registerButton];
    
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(superview);
        make.width.equalTo(@100);
    }];
    
    [[UITextField appearance] setKeyboardAppearance:UIKeyboardAppearanceDark];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)registerButtonPressed
{
    RegisterViewController *vc = [[RegisterViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.registerButton.width = self.view.width;
    self.registerButton.height = 60;
    self.registerButton.center = self.view.contentCenter;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
