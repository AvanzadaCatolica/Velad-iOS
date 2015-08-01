//
//  VLDGroupsViewController.m
//  Velad
//
//  Created by Renzo Crisóstomo on 01/08/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDGroupsViewController.h"
#import <Realm/Realm.h>
#import "VLDGroup.h"
#import "VLDGroupTableViewCell.h"
#import <Masonry/Masonry.h>
#import "VLDBasicPointsViewController.h"
#import "VLDGroupViewController.h"
#import "VLDWeekday.h"
#import "VLDAlert.h"

@interface VLDGroupsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic) RLMResults *groups;
@property (nonatomic) NSMutableArray *orders;

- (void)setupNavigationItem;
- (void)setupDataSource;
- (void)setupTableView;
- (void)setupLayout;
- (void)setupOrders;
- (void)updateRightBarButtonItems;
- (void)saveOrders;

@end

@implementation VLDGroupsViewController

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
    [self setupOrders];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    if (indexPath) {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    self.navigationItem.title = @"Grupos";
    [self updateRightBarButtonItems];
}

- (void)setupDataSource {
    self.groups = [VLDGroup sortedGroups];
}

- (void)setupTableView {
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[VLDGroupTableViewCell class]
           forCellReuseIdentifier:NSStringFromClass([VLDGroupTableViewCell class])];
}

- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.tableView.superview);
    }];
}

- (void)setupOrders {
    self.orders = [[NSMutableArray alloc] init];
    for (VLDGroup *group in self.groups) {
        [self.orders addObject:@(group.order)];
    }
}

#pragma mark - Private methods

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


- (void)saveOrders {
    NSMutableArray *previousOrder = [NSMutableArray array];
    for (VLDGroup *group in self.groups) {
        [previousOrder addObject:group];
    }
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [self.orders enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
        VLDGroup *group = [previousOrder objectAtIndex:index];
        group.order = [self.orders indexOfObject:@(group.order)];
    }];
    [realm commitWriteTransaction];
    [self setupOrders];
}

- (void)onTapAddButton:(id)sender {
    VLDGroupViewController *viewController = [[VLDGroupViewController alloc] initWithGroup:nil];
    viewController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController
                       animated:YES
                     completion:nil];
}

- (void)onTapDoneButton:(id)sender {
    [self setEditing:NO animated:YES];
    [self saveOrders];
}

- (void)onTapDeleteButton:(id)sender {
    [self setEditing:YES animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VLDGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([VLDGroupTableViewCell class])];
    cell.model = self.groups[indexPath.row];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self saveOrders];
        
        VLDGroup *group = self.groups[indexPath.row];
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        
        for (VLDBasicPoint *basicPoint in group.basicPoints) {
            [basicPoint deleteBasicPointInRealm:realm];
        }
        [realm deleteObjects:group.basicPoints];
        [realm deleteObject:group];
        
        [realm commitWriteTransaction];
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self.orders removeObjectAtIndex:indexPath.row];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSNumber *moved = [self.orders objectAtIndex:sourceIndexPath.row];
    [self.orders removeObjectAtIndex:sourceIndexPath.row];
    [self.orders insertObject:moved atIndex:destinationIndexPath.row];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VLDGroup *group = self.groups[indexPath.row];
    VLDBasicPointsViewController *viewController = [[VLDBasicPointsViewController alloc] init];
    viewController.group = group;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - VLDGroupViewControllerDelegate

- (void)groupViewController:(VLDGroupViewController *)viewController
      didFinishEditingGroup:(VLDGroup *)basicPoint {
    [self setupOrders];
}

@end
