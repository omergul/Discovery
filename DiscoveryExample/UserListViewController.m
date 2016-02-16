//
//  UserListViewController.m
//  Discover
//
//  Created by Ömer Faruk Gül on 1/23/14.
//  Copyright (c) 2014 Louvre Digital. All rights reserved.
//

#import "UserListViewController.h"
#import "BLEUser.h"
#import "LLUtility.h"
#import <Masonry.h>
#import "Discovery.h"

#define UPDATE_INTERVAL 2.0f

@interface UserListViewController ()
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSArray *users;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) Discovery *discovery;
@end

@implementation UserListViewController

- (id)initWithUsername:(NSString *)username
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _username = username;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self addGradientBgLayer:@[[UIColor colorWithHexString:@"50BBE6"], [UIColor colorWithHexString:@"EDD7F1"]]];
    
    self.navigationItem.title = @"Nearby People";
    
    self.users = [NSArray array];
    
    UIView *superview = self.view;
    
    // table view to list nearby users
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.rowHeight = 55;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor whiteColor];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(layoutMargins)]) {
        self.tableView.layoutMargins = UIEdgeInsetsZero;
    }
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superview);
    }];
    
    // create our UUID.
    NSString *uuidStr = @"B9407F30-F5F8-466E-AFF9-25556B57FE99";
    CBUUID *uuid = [CBUUID UUIDWithString:uuidStr];
    
    __weak typeof(self) weakSelf = self;
    
    // start Discovery
    self.discovery = [[Discovery alloc] initWithUUID:uuid];
    [self.discovery startDiscovering:^(NSArray *users, BOOL usersChanged) {
        weakSelf.users = users;
        [weakSelf.tableView reloadData];
        
        NSLog(@"Discovering users: %lu", (unsigned long)users.count);
    }];
    
    [self.discovery startAdvertisingWithUsername:self.username];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // pause, (it will disable timer and top scanning, but it will continue advertising)
    // this is important, otherwise due to the active timers your VC may not be deallocated.
    [self.discovery stopDiscovering];
    [self.discovery stopAdvertising];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"BLEUserCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    BLEUser *bleUser = [self.users objectAtIndex:indexPath.row];
    cell.textLabel.text = bleUser.username;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)bleUser.proximity];
    
    NSInteger proximity = bleUser.proximity;
    
    UIColor *bgColor;
    
    
    if (proximity < -85)
        // red
        bgColor = [UIColor colorWithHexString:@"ED4A5E"];
    else if (proximity < -65)
        // yellow
        bgColor = [UIColor colorWithHexString:@"F6EC6E"];
    else
        // green
        bgColor = [UIColor colorWithHexString:@"B8E986"];
        
    
    if ([cell respondsToSelector:@selector(layoutMargins)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    
    cell.backgroundColor = bgColor;
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"UserList is deallocated!");
}

@end
