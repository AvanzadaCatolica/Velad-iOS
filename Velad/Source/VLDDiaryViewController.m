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
#import "VLDUpdateNotesPresenter.h"
#import "VLDEmptyView.h"

typedef NS_ENUM(NSUInteger, VLDDiaryMode) {
    VLDDiaryModeAll,
    VLDDiaryModeConfessable,
};

@interface VLDDiaryViewController () <UITableViewDataSource, UITableViewDelegate, VLDDateIntervalPickerViewDelegate, VLDNoteViewControllerDelegate, VLDUpdateNotesPresenterDataSource, VLDUpdateNotesPresenterDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) VLDDateIntervalPickerView *dateIntervalPickerView;
@property (nonatomic) RLMResults *notes;
@property (nonatomic, weak) UISegmentedControl *segmentedControl;
@property (nonatomic) VLDUpdateNotesPresenter *updateNotesPresenter;
@property (nonatomic) VLDEmptyView *emptyView;

- (void)setupNavigationItem;
- (void)setupLayout;
- (void)setupTableView;
- (void)setupDateIntervalPickerView;
- (void)setupEmtpyView;
- (void)onValueChangedSegmentedControl:(id)sender;
- (void)onTapAddButton:(id)sender;
- (void)onTapActionButton:(id)sender;
- (void)updateEmptyStatus;

@end

@implementation VLDDiaryViewController

#pragma mark - Life cycle

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [view addSubview:tableView];
    self.tableView = tableView;
    VLDDateIntervalPickerView *dateIntervalPickerView = [[VLDDateIntervalPickerView alloc] initWithType:VLDDateIntervalPickerViewTypeWeekly];
    [view addSubview:dateIntervalPickerView];
    self.dateIntervalPickerView = dateIntervalPickerView;
    VLDEmptyView *emptyView = [[VLDEmptyView alloc] init];
    [view addSubview:emptyView];
    self.emptyView = emptyView;
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationItem];
    [self setupDataSource];
    [self setupEmtpyView];
    [self setupLayout];
    [self setupTableView];
    [self setupDateIntervalPickerView];
    [self updateEmptyStatus];
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
        make.height.equalTo(self.dateIntervalPickerView.superview).with.multipliedBy(0.2);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.tableView.superview);
        make.trailing.equalTo(self.tableView.superview);
        make.top.equalTo(self.tableView.superview);
        make.bottom.equalTo(self.dateIntervalPickerView.mas_top);
    }];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.emptyView.superview);
        make.trailing.equalTo(self.emptyView.superview);
        make.top.equalTo(self.emptyView.superview);
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

- (void)setupEmtpyView {
    self.emptyView.alpha = 0;
}

#pragma mark - Private methods

- (VLDUpdateNotesPresenter *)updateNotesPresenter {
    if (_updateNotesPresenter == nil) {
        _updateNotesPresenter = [[VLDUpdateNotesPresenter alloc] initWithDataSource:self];
        _updateNotesPresenter.delegate = self;
    }
    return _updateNotesPresenter;
}

- (void)onValueChangedSegmentedControl:(id)sender {
    [self setupDataSource];
    [self updateEmptyStatus];
    [self updateLeftBarButtonItem];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                  withRowAnimation:UITableViewRowAnimationFade];
}

- (void)updateLeftBarButtonItem {
    if (self.editing) {
        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                                target:self
                                                                                                action:@selector(onTapAddButton:)]];
    } else {
        VLDDiaryMode mode = self.segmentedControl.selectedSegmentIndex;
        if (mode == VLDDiaryModeConfessable && self.notes.count >= 1) {
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
    [self.updateNotesPresenter present];
}

- (void)updateEmptyStatus {
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.emptyView.alpha = self.notes.count == 0 ? 1 : 0;
                         self.tableView.alpha = self.notes.count == 0 ? 0 : 1;
                     }];
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
        [self updateLeftBarButtonItem];
        [self updateEmptyStatus];
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
    [self updateEmptyStatus];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                  withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - VLDNoteViewControllerDelegate

- (void)noteViewControllerDidChangeProperties:(VLDNoteViewController *)viewController {
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                  withRowAnimation:UITableViewRowAnimationFade];
    [self updateEmptyStatus];
}

- (void)noteViewControllerDidCancelEditing:(VLDNoteViewController *)viewController {
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    if (indexPath) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - VLDUpdateNotesPresenterDataSource

- (RLMResults *)notesForUpdateNotesPresenter:(VLDUpdateNotesPresenter *)presenter {
    return self.notes;
}

- (UIViewController *)viewControllerForUpdatesNotesPresenter:(VLDUpdateNotesPresenter *)presenter {
    return self;
}

#pragma mark - VLDUpdateNotesPresenterDelegate

- (void)updateNotesPresenterDidFinishUpdate:(VLDUpdateNotesPresenter *)presenter {
    [self updateLeftBarButtonItem];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                  withRowAnimation:UITableViewRowAnimationFade];
}

@end
