//
//  RegisterViewController.m
//  Mask
//
//  Created by Ömer Faruk Gül on 12/4/13.
//  Copyright (c) 2013 Louvre Digital. All rights reserved.
//

#import "RegisterViewController.h"
#import "LLUtility.h"
#import "UserListViewController.h"
#import <Masonry.h>

@interface RegisterViewController ()
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UITextField *usernameField;
@end

@implementation RegisterViewController

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

    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                      NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Regular" size:22.0f]}];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    self.navigationItem.title = @"Discovery";
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = backButton;
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(registerButtonPressed)];
    [buttonItem setTitleTextAttributes:@{
                                         NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:16.0f],
                                         NSForegroundColorAttributeName: [UIColor whiteColor]
                                         } forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = buttonItem;
    
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    [self addGradientBgLayer:@[[UIColor colorWithHexString:@"50BBE6"], [UIColor colorWithHexString:@"EDD7F1"]]];
    
    
    // start creating views
    UIView *superview = self.view;

    // scrollview
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.scrollView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superview);
    }];
    
    // username field
    self.usernameField = [LLControl textfild:@"Username"];
    self.usernameField.frame = CGRectMake(0, 0, 100, 100);
    self.usernameField.delegate = self;
    self.usernameField.returnKeyType = UIReturnKeyGo;
    self.usernameField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.usernameField.tag = 12;
    self.usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.usernameField.keyboardAppearance = UIKeyboardAppearanceDark;
    [self.scrollView addSubview:self.usernameField];
    
    [self.usernameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        make.height.equalTo(@70);
        make.top.equalTo(@10);
    }];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.usernameField becomeFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self registerButtonPressed];
    return NO;
}

- (void)registerButtonPressed
{
    NSString *username = self.usernameField.text;
    
    if(username.length == 0) {
        [LLUtility showAlertWithTitle:@"Form" andMessage:@"Pick a username."];
        return;
    }
    
    UserListViewController *vc = [[UserListViewController alloc] initWithUsername:username];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
