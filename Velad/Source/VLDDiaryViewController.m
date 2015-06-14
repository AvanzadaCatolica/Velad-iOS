//
//  VLDDiaryViewController.m
//  Velad
//
//  Created by Renzo Crisóstomo on 13/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDDiaryViewController.h"
#import "VLDDateIntervalPickerView.h"
#import <Masonry/Masonry.h>
#import "VLDNoteTableViewCell.h"
#import <Realm/Realm.h>
#import "VLDNote.h"
#import "VLDNoteViewController.h"

typedef NS_ENUM(NSUInteger, VLDDiaryMode) {
    VLDDiaryModeAll,
    VLDDiaryModeConfessable,
};

@interface VLDDiaryViewController () <UITableViewDataSource, UITableViewDelegate, VLDDateIntervalPickerViewDelegate, VLDNoteViewControllerDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) VLDDateIntervalPickerView *dateIntervalPickerView;
@property (nonatomic) RLMResults *notes;
@property (nonatomic, weak) UISegmentedControl *segmentedControl;

- (void)setupNavigationItem;
- (void)setupLayout;
- (void)setupTableView;
- (void)setupDateIntervalPickerView;
- (void)onValueChangedSegmentedControl:(id)sender;
- (void)onTapAddButton:(id)sender;
- (void)onTapActionButton:(id)sender;

@end

static CGFloat const kDatePickerHeight = 88;

@implementation VLDDiaryViewController

#pragma mark - Life cycle

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [view addSubview:tableView];
    self.tableView = tableView;
    VLDDateIntervalPickerView *dateIntervalPickerView = [[VLDDateIntervalPickerView alloc] initWithFrame:CGRectZero];
    [view addSubview:dateIntervalPickerView];
    self.dateIntervalPickerView = dateIntervalPickerView;
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDataSource];
    [self setupNavigationItem];
    [self setupLayout];
    [self setupTableView];
    [self setupDateIntervalPickerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIRectEdge)edgesForExtendedLayout {
    return [super edgesForExtendedLayout] ^ UIRectEdgeBottom;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
    [self updateLeftBarButtonItem];
}

#pragma mark - Setup methods

- (void)setupDataSource {
    VLDDiaryMode mode = self.segmentedControl.selectedSegmentIndex;
    if (mode == VLDDiaryModeAll) {
        self.notes = [VLDNote notesBetweenStartDate:self.dateIntervalPickerView.selectedStartDate
                                            endDate:self.dateIntervalPickerView.selectedEndDate];
    } else {
        self.notes = [VLDNote confessableNotesBetweenStartDate:self.dateIntervalPickerView.selectedStartDate
                                                       endDate:self.dateIntervalPickerView.selectedEndDate];
    }
}

- (void)setupNavigationItem {
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Todos", @"Confesables"]];
    segmentedControl.selectedSegmentIndex = 0;
    [segmentedControl addTarget:self
                         action:@selector(onValueChangedSegmentedControl:)
               forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
    self.segmentedControl = segmentedControl;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)setupLayout {
    [self.dateIntervalPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.dateIntervalPickerView.superview);
        make.trailing.equalTo(self.dateIntervalPickerView.superview);
        make.bottom.equalTo(self.dateIntervalPickerView.superview);
        make.height.equalTo(@(kDatePickerHeight));
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.tableView.superview);
        make.trailing.equalTo(self.tableView.superview);
        make.top.equalTo(self.tableView.superview);
        make.bottom.equalTo(self.dateIntervalPickerView.mas_top);
    }];
}

- (void)setupTableView {
    [self.tableView registerClass:[VLDNoteTableViewCell class]
           forCellReuseIdentifier:NSStringFromClass([VLDNoteTableViewCell class])];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)setupDateIntervalPickerView {
    self.dateIntervalPickerView.delegate = self;
}

#pragma mark - Private methods

- (void)onValueChangedSegmentedControl:(id)sender {
    [self updateLeftBarButtonItem];
    [self setupDataSource];
    [self.tableView reloadData];
}

- (void)updateLeftBarButtonItem {
    if (self.editing) {
        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                                target:self
                                                                                                action:@selector(onTapAddButton:)]];
    } else {
        VLDDiaryMode mode = self.segmentedControl.selectedSegmentIndex;
        if (mode == VLDDiaryModeConfessable) {
            [self.navigationItem
             setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                target:self
                                                                                action:@selector(onTapActionButton:)]
             animated:YES];
        } else {
            [self.navigationItem setLeftBarButtonItem:nil animated:YES];
        }
    }
}

- (void)onTapAddButton:(id)sender {
    VLDNoteViewController *viewController = [[VLDNoteViewController alloc] initWithNote:nil];
    viewController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)onTapActionButton:(id)sender {
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.notes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VLDNoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([VLDNoteTableViewCell class])];
    cell.model = self.notes[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        VLDNote *note = self.notes[indexPath.row];
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        
        [realm deleteObject:note];
        
        [realm commitWriteTransaction];
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VLDNote *note = self.notes[indexPath.row];
    VLDNoteViewController *viewController = [[VLDNoteViewController alloc] initWithNote:note];
    viewController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - VLDDateIntervalPickerViewDelegate

- (void)dateIntervalPickerViewDidChangeSelection:(VLDDateIntervalPickerView *)dateIntervalPickerView {
    [self setupDataSource];
    [self.tableView reloadData];
}

#pragma mark - VLDNoteViewControllerDelegate

- (void)noteViewControllerDidChangeProperties:(VLDNoteViewController *)viewController {
    [self.tableView reloadData];
}

- (void)noteViewControllerDidCancelEditing:(VLDNoteViewController *)viewController {
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    if (indexPath) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

@end
