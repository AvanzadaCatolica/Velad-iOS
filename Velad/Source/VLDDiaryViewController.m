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
#import "VLDDiaryModePickerView.h"

@interface VLDDiaryViewController () <UITableViewDataSource, UITableViewDelegate, VLDDateIntervalPickerViewDelegate, VLDNoteViewControllerDelegate, VLDUpdateNotesPresenterDataSource, VLDUpdateNotesPresenterDelegate, VLDDiaryModePickerViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) VLDDateIntervalPickerView *dateIntervalPickerView;
@property (nonatomic, weak) VLDDiaryModePickerView *diaryModePickerView;
@property (nonatomic) RLMResults *notes;
@property (nonatomic) VLDUpdateNotesPresenter *updateNotesPresenter;
@property (nonatomic) VLDEmptyView *emptyView;
@property (nonatomic) VLDDiaryMode mode;
@property (nonatomic) VLDNoteTableViewCell *referenceHeightCell;

- (void)setupNavigationItem;
- (void)setupLayout;
- (void)setupTableView;
- (void)setupDateIntervalPickerView;
- (void)setupDiaryModePickerView;
- (void)setupEmtpyView;
- (void)updateEmptyStatus;
- (void)updateLeftBarButtonItem;
- (void)updateRightBarButtonItems;
- (void)onTapAddButton:(id)sender;
- (void)onTapDoneButton:(id)sender;
- (void)onTapDeleteButton:(id)sender;
- (void)onTapActionButton:(id)sender;

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
    VLDDiaryModePickerView *diaryModePickerView = [[VLDDiaryModePickerView alloc] initWithMode:VLDDiaryModeAll];
    [view addSubview:diaryModePickerView];
    self.diaryModePickerView = diaryModePickerView;
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
    [self setupDiaryModePickerView];
    [self updateEmptyStatus];
}

- (UIRectEdge)edgesForExtendedLayout {
    return [super edgesForExtendedLayout] ^ UIRectEdgeBottom;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
    [self updateLeftBarButtonItem];
    [self updateRightBarButtonItems];
}

#pragma mark - Setup methods

- (void)setupDataSource {
    VLDDiaryMode mode = self.diaryModePickerView.mode;
    if (mode == VLDDiaryModeAll) {
        self.notes = [VLDNote notesBetweenStartDate:self.dateIntervalPickerView.selectedStartDate
                                            endDate:self.dateIntervalPickerView.selectedEndDate];
    } else if (mode == VLDDiaryModeConfessable) {
        self.notes = [VLDNote confessableNotesBetweenStartDate:self.dateIntervalPickerView.selectedStartDate
                                                       endDate:self.dateIntervalPickerView.selectedEndDate];
    } else if (mode == VLDDIaryModeGuidance) {
        self.notes = [VLDNote guidanceNotesBetweenStartDate:self.dateIntervalPickerView.selectedStartDate
                                                    endDate:self.dateIntervalPickerView.selectedEndDate];
    }
}

- (void)setupNavigationItem {
    self.navigationItem.title = @"Diario";
    [self updateLeftBarButtonItem];
    [self updateRightBarButtonItems];
}

- (void)setupLayout {
    [self.dateIntervalPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.dateIntervalPickerView.superview);
        make.trailing.equalTo(self.dateIntervalPickerView.superview);
        make.bottom.equalTo(self.dateIntervalPickerView.superview);
        make.height.equalTo(self.dateIntervalPickerView.superview).with.multipliedBy(0.2);
    }];
    [self.diaryModePickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.diaryModePickerView.superview);
        make.trailing.equalTo(self.diaryModePickerView.superview);
        make.top.equalTo(self.diaryModePickerView.superview);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.tableView.superview);
        make.trailing.equalTo(self.tableView.superview);
        make.top.equalTo(self.diaryModePickerView.mas_bottom);
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

- (void)setupDiaryModePickerView {
    self.diaryModePickerView.delegate = self;
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

- (void)updateLeftBarButtonItem {
    VLDDiaryMode mode = self.diaryModePickerView.mode;
    if (mode == VLDDiaryModeConfessable && self.notes.count >= 1 && !self.isEditing) {
        [self.navigationItem
         setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                            target:self
                                                                            action:@selector(onTapActionButton:)]
         animated:YES];
    } else {
        [self.navigationItem setLeftBarButtonItems:nil animated:YES];
    }
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

- (void)updateEmptyStatus {
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.emptyView.alpha = self.notes.count == 0 ? 1 : 0;
                         self.tableView.alpha = self.notes.count == 0 ? 0 : 1;
                     }];
}

- (void)onTapAddButton:(id)sender {
    VLDNoteViewController *viewController = [[VLDNoteViewController alloc] initWithNote:nil];
    viewController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)onTapDoneButton:(id)sender {
    [self setEditing:NO animated:YES];
}

- (void)onTapDeleteButton:(id)sender {
    [self setEditing:YES animated:YES];
}

- (void)onTapActionButton:(id)sender {
    [self.updateNotesPresenter present];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    VLDNote *note = self.notes[indexPath.row];
    NSString *reuseIdentifer = NSStringFromClass([VLDNoteTableViewCell class]);
    if (!self.referenceHeightCell) {
        self.referenceHeightCell = [[VLDNoteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                               reuseIdentifier:reuseIdentifer];
    }
    self.referenceHeightCell.model = note;
    [self.referenceHeightCell setNeedsLayout];
    [self.referenceHeightCell layoutIfNeeded];
    CGSize size = [self.referenceHeightCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f;
}

#pragma mark - VLDDateIntervalPickerViewDelegate

- (void)dateIntervalPickerView:(VLDDateIntervalPickerView *)dateIntervalPickerView didChangeSelectionWithDirection:(VLDArrowButtonDirection)direction {
    [self setupDataSource];
    [self updateLeftBarButtonItem];
    [self updateEmptyStatus];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                  withRowAnimation:direction == VLDArrowButtonDirectionLeft ? UITableViewRowAnimationRight : UITableViewRowAnimationLeft];
}

#pragma mark - VLDNoteViewControllerDelegate

- (void)noteViewControllerDidChangeProperties:(VLDNoteViewController *)viewController {
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                  withRowAnimation:UITableViewRowAnimationFade];
    [self updateLeftBarButtonItem];
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
    [self updateEmptyStatus];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                  withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - VLDDiaryModePickerViewDelegate

- (void)diaryModePickerViewDidChangeMode:(VLDDiaryModePickerView *)diaryModePickerView {
    [self setupDataSource];
    [self updateLeftBarButtonItem];
    [self updateEmptyStatus];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                  withRowAnimation:UITableViewRowAnimationFade];
}

@end
