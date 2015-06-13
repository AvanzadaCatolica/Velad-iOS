//
//  VLDBasicPointsViewController.m
//  Velad
//
//  Created by Renzo Crisóstomo on 13/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDBasicPointsViewController.h"

@interface VLDBasicPointsViewController ()

- (void)setupNavigationItem;

@end

@implementation VLDBasicPointsViewController

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Setup methods

- (void)setupNavigationItem {
    self.navigationItem.title = @"Puntos Básicos";
}

@end
