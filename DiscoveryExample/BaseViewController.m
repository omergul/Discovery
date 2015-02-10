//
//  BaseViewController.m
//  DiscoveryExample
//
//  Created by Ömer Faruk Gül on 08/02/15.
//  Copyright (c) 2015 Ömer Faruk Gül. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
@property (strong, nonatomic) CAGradientLayer *bgGradientLayer;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)addGradientBgLayer:(NSArray *)colors {
    
    if(self.bgGradientLayer) {
        [self.bgGradientLayer removeFromSuperlayer];
    }
    
    self.bgGradientLayer = [CAGradientLayer layer];
    
    NSMutableArray *arr = [NSMutableArray array];
    for(UIColor *color in colors) {
        [arr addObject:(id)color.CGColor];
    }
    
    self.bgGradientLayer.colors = arr;
    [self.view.layer insertSublayer:self.bgGradientLayer atIndex:0];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.bgGradientLayer.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
