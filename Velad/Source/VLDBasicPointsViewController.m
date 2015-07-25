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
#import "VLDBasicPointViewController.h"
#import "VLDNotificationScheduler.h"

@interface VLDBasicPointsViewController () <UITableViewDataSource, UITableViewDelegate, VLDBasicPointViewControllerDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic) RLMResults *basicPoints;
@property (nonatomic) UIBarButtonItem *backButtonItem;
@property (nonatomic) VLDNotificationScheduler *notificationScheduler;

- (void)setupNavigationItem;
- (void)setupDataSource;
- (void)setupTableView;
- (void)setupLayout;
- (void)updateRightBarButtonItems;
- (void)onTapAddButton:(id)sender;

@end

@implementation VLDBasicPointsViewController

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor whiteColor];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
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

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
    [self updateRightBarButtonItems];
}

#pragma mark - Setup methods

- (void)setupNavigationItem {
    self.navigationItem.title = @"Puntos Básicos";
    [self updateRightBarButtonItems];
}

- (void)setupDataSource {
    self.basicPoints = [[VLDBasicPoint allObjects] sortedResultsUsingProperty:@"order" ascending:YES];
}

- (void)setupTableView {
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsSelectionDuringEditing = YES;
    [self.tableView registerClass:[VLDBasicPointCellTableViewCell class]
           forCellReuseIdentifier:NSStringFromClass([VLDBasicPointCellTableViewCell class])];
}

- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.tableView.superview);
    }];
}

#pragma mark - Private methods

- (VLDNotificationScheduler *)notificationScheduler {
    if (_notificationScheduler == nil) {
        _notificationScheduler = [[VLDNotificationScheduler alloc] init];
    }
    return _notificationScheduler;
}

- (void)updateRightBarButtonItems {
    if (self.isEditing) {
        UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                        target:self
                                                                                        action:@selector(onTapDoneButton:)];
        [self.navigationItem setRightBarButtonItems:@[doneButtonItem] animated:YES];
    } else {
        UIBarButtonItem *addBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Add"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(onTapAddButton:)];
        UIBarButtonItem *deleteButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Delete"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(onTapDeleteButton:)];
        [self.navigationItem setRightBarButtonItems:@[addBarButtonItem, deleteButtonItem] animated:YES];
    }
}

- (void)onTapAddButton:(id)sender {
    VLDBasicPointViewController *viewController = [[VLDBasicPointViewController alloc] initWithBasicPoint:nil];
    viewController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController
                       animated:YES
                     completion:nil];
}

- (void)onTapDoneButton:(id)sender {
    [self setEditing:NO animated:YES];
}

- (void)onTapDeleteButton:(id)sender {
    [self setEditing:YES animated:YES];
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

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        VLDBasicPoint *basicPoint = self.basicPoints[indexPath.row];
        [self.notificationScheduler unscheduleNotificationsForBasicPoint:basicPoint];
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        
        [realm deleteObject:basicPoint];
        
        [realm commitWriteTransaction];
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        if ([self.delegate respondsToSelector:@selector(basicPointsViewControllerDidChangeProperties:)]) {
            [self.delegate basicPointsViewControllerDidChangeProperties:self];
        }
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    VLDBasicPoint *sourceBasicPoint = self.basicPoints[sourceIndexPath.row];
    VLDBasicPoint *destinationBasicPoint = self.basicPoints[destinationIndexPath.row];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    NSInteger sourceOrder = sourceBasicPoint.order;
    sourceBasicPoint.order = destinationBasicPoint.order;
    destinationBasicPoint.order = sourceOrder;
    
    [realm commitWriteTransaction];
    
    if ([self.delegate respondsToSelector:@selector(basicPointsViewControllerDidChangeProperties:)]) {
        [self.delegate basicPointsViewControllerDidChangeProperties:self];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VLDBasicPoint *basicPoint = self.basicPoints[indexPath.row];
    VLDBasicPointViewController *viewController = [[VLDBasicPointViewController alloc] initWithBasicPoint:basicPoint];
    viewController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController
                       animated:YES
                     completion:nil];
    return;
}

#pragma mark - VLDBasicPointViewControllerDelegate

- (void)basicPointViewController:(VLDBasicPointViewController *)viewController
      didFinishEditingBasicPoint:(VLDBasicPoint *)basicPoint {
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    if (indexPath) {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                      withRowAnimation:UITableViewRowAnimationFade];
    }
    if ([self.delegate respondsToSelector:@selector(basicPointsViewControllerDidChangeProperties:)]) {
        [self.delegate basicPointsViewControllerDidChangeProperties:self];
    }
}

- (void)basicPointViewControllerDidCancelEditing:(VLDBasicPointViewController *)viewController {
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    if (indexPath) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

@end
