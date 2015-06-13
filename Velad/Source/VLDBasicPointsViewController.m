//
//  VLDBasicPointsViewController.m
//  Velad
//
//  Created by Renzo Crisóstomo on 13/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDBasicPointsViewController.h"
#import <Masonry/Masonry.h>
#import <Realm/Realm.h>
#import "VLDBasicPointCellTableViewCell.h"
#import "VLDBasicPoint.h"

@interface VLDBasicPointsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic) RLMResults *basicPoints;

- (void)setupNavigationItem;
- (void)setupDataSource;
- (void)setupTableView;
- (void)setupLayout;

@end

@implementation VLDBasicPointsViewController

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor whiteColor];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    [view addSubview:tableView];
    self.tableView = tableView;
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationItem];
    [self setupDataSource];
    [self setupTableView];
    [self setupLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Setup methods

- (void)setupNavigationItem {
    self.navigationItem.title = @"Puntos Básicos";
}

- (void)setupDataSource {
    self.basicPoints = [[VLDBasicPoint allObjects] sortedResultsUsingProperty:@"order" ascending:YES];
}

- (void)setupTableView {
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[VLDBasicPointCellTableViewCell class]
           forCellReuseIdentifier:NSStringFromClass([VLDBasicPointCellTableViewCell class])];
}

- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.tableView.superview);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.basicPoints.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VLDBasicPointCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([VLDBasicPointCellTableViewCell class])];
    cell.model = self.basicPoints[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VLDBasicPoint *basicPoint = self.basicPoints[indexPath.row];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    basicPoint.enabled = !basicPoint.enabled;
    
    [realm commitWriteTransaction];
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    if ([self.delegate respondsToSelector:@selector(basicPointsViewControllerDidChangeProperties:)]) {
        [self.delegate basicPointsViewControllerDidChangeProperties:self];
    }
}

@end
