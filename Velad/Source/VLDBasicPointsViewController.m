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
#import "VLDBasicPointTableViewCell.h"
#import "VLDBasicPoint.h"
#import "VLDBasicPointViewController.h"
#import "VLDNotificationScheduler.h"
#import "VLDGroup.h"
#import "VLDAlert.h"

@interface VLDBasicPointsViewController () <UITableViewDataSource, UITableViewDelegate, VLDBasicPointViewControllerDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic) UIBarButtonItem *backButtonItem;
@property (nonatomic) VLDNotificationScheduler *notificationScheduler;

- (void)setupNavigationItem;
- (void)setupTableView;
- (void)setupLayout;
- (void)updateRightBarButtonItems;
- (void)onTapAddButton:(id)sender;
- (void)onTapDoneButton:(id)sender;
- (void)onTapDeleteButton:(id)sender;

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
    [self setupTableView];
    [self setupLayout];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    if (indexPath) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else {
        [self.tableView reloadData];
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
    [self updateRightBarButtonItems];
}

#pragma mark - Setup methods

- (void)setupNavigationItem {
    self.navigationItem.title = self.group.name;
    [self updateRightBarButtonItems];
}

- (void)setupTableView {
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[VLDBasicPointTableViewCell class]
           forCellReuseIdentifier:NSStringFromClass([VLDBasicPointTableViewCell class])];
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
        UIBarButtonItem *deleteButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
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
    return self.group.basicPoints.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VLDBasicPointTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([VLDBasicPointTableViewCell class])];
    cell.model = self.group.basicPoints[indexPath.row];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        VLDBasicPoint *basicPoint = self.group.basicPoints[indexPath.row];
        if (basicPoint.isEnabled) {
            [self.notificationScheduler unscheduleNotificationsForBasicPoint:basicPoint];
        }
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        
        [basicPoint deleteBasicPointInRealm:realm];
        [realm deleteObject:basicPoint];
        
        [realm commitWriteTransaction];
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    VLDBasicPoint *basicPoint = [self.group.basicPoints objectAtIndex:sourceIndexPath.row];
    [self.group.basicPoints removeObjectAtIndex:sourceIndexPath.row];
    [self.group.basicPoints insertObject:basicPoint atIndex:destinationIndexPath.row];
    
    [realm commitWriteTransaction];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VLDBasicPoint *basicPoint = self.group.basicPoints[indexPath.row];
    VLDBasicPointViewController *viewController = [[VLDBasicPointViewController alloc] initWithBasicPoint:basicPoint];
    viewController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController
                       animated:YES
                     completion:nil];
}

#pragma mark - VLDBasicPointViewControllerDelegate

- (void)basicPointViewController:(VLDBasicPointViewController *)viewController
      didFinishEditingBasicPoint:(VLDBasicPoint *)basicPoint {
    if (!basicPoint.isEnabled) {
        [self.notificationScheduler unscheduleNotificationsForBasicPoint:basicPoint];
    }
    
    NSUInteger index = [self.group.basicPoints indexOfObject:basicPoint];
    if (index != NSNotFound) {
        NSArray *indexPaths = @[[NSIndexPath indexPathForRow:index
                                                   inSection:0]];
        [self.tableView reloadRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
        return;
    }
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    [self.group.basicPoints addObject:basicPoint];
    
    [realm commitWriteTransaction];
}

@end
