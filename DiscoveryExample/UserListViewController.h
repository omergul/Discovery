//
//  UserListViewController.h
//  Discover
//
//  Created by Ömer Faruk Gül on 1/23/14.
//  Copyright (c) 2014 Louvre Digital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface UserListViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
- (id)initWithUsername:(NSString *)username;
@end
