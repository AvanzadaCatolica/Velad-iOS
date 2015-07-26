//
//  VLDTodayViewController.m
//  Velad
//
//  Created by Renzo Crisóstomo on 13/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDTodayViewController.h"
#import <Realm/Realm.h>
#import "VLDBasicPoint.h"
#import "VLDRecord.h"
#import "VLDDailyRecordTableViewCell.h"
#import "VLDDatePickerView.h"
#import <Masonry/Masonry.h>
#import "NSString+VLDAdditions.h"
#import "VLDRecordNotesPresenter.h"
#import "VLDBasicPointsViewController.h"
#import "NSDate+VLDAdditions.h"

@interface VLDTodayViewController () <UITableViewDataSource, UITableViewDelegate, VLDRecordNotesPresenterDataSource, VLDRecordNotesPresenterDelegate, VLDDailyRecordTableViewCellDelegate, VLDDatePickerViewDelegate, VLDBasicPointsViewControllerDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic) NSArray *basicPoints;
@property (nonatomic, weak) VLDDatePickerView *datePickerView;
@property (nonatomic) VLDRecordNotesPresenter *recordNotesPresenter;

- (void)setupDataSource;
- (void)setupLayout;
- (void)setupTableView;
- (void)setupDatePickerView;
- (void)setupGestureRecognizer;
- (void)setupNavigationItem;

@end

@implementation VLDTodayViewController

#pragma mark - Life cycle

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [view addSubview:tableView];
    self.tableView = tableView;
    VLDDatePickerView *datePickerView = [[VLDDatePickerView alloc] initWithFrame:CGRectZero];
    [view addSubview:datePickerView];
    self.datePickerView = datePickerView;
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDataSource];
    [self setupLayout];
    [self setupTableView];
    [self setupDatePickerView];
    [self setupGestureRecognizer];
    [self setupNavigationItem];
}

- (UIRectEdge)edgesForExtendedLayout {
    return [super edgesForExtendedLayout] ^ UIRectEdgeBottom;
}

#pragma mark - Setup methods

- (void)setupDataSource {
    RLMResults *results = [VLDBasicPoint basicPoints];
    NSMutableArray *basicPoints = [NSMutableArray array];
    
    NSString *weekdaySymbol = [self.datePickerView.selectedDate vld_weekdaySymbol];
    for (VLDBasicPoint *basicPoint in results) {
        if ([basicPoint.weekDaySymbols indexOfObject:weekdaySymbol] != NSNotFound) {
            [basicPoints addObject:basicPoint];
        }
    }
    
    self.basicPoints = [basicPoints copy];
}

- (void)setupLayout {
    [self.datePickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.datePickerView.superview);
        make.trailing.equalTo(self.datePickerView.superview);
        make.bottom.equalTo(self.datePickerView.superview);
        make.height.equalTo(self.datePickerView.superview).with.multipliedBy(0.2);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.tableView.superview);
        make.trailing.equalTo(self.tableView.superview);
        make.top.equalTo(self.tableView.superview);
        make.bottom.equalTo(self.datePickerView.mas_top);
    }];
}

- (void)setupTableView {
    [self.tableView registerClass:[VLDDailyRecordTableViewCell class]
           forCellReuseIdentifier:NSStringFromClass([VLDDailyRecordTableViewCell class])];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)setupDatePickerView {
    self.datePickerView.delegate = self;
}

- (void)setupGestureRecognizer {
    UILongPressGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
}

- (void)setupNavigationItem {
    UIImage *listImage = [[UIImage imageNamed:@"List"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:listImage
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(onTapListButton:)];
    self.navigationItem.title = @"Hoy";
}

#pragma mark - Private methods

- (VLDRecordNotesPresenter *)recordNotesPresenter {
    if (_recordNotesPresenter == nil) {
        _recordNotesPresenter = [[VLDRecordNotesPresenter alloc] initWithDataSource:self];
        _recordNotesPresenter.delegate = self;
    }
    return _recordNotesPresenter;
}

- (VLDDailyRecord *)dailyRecordAtIndexPath:(NSIndexPath *)indexPath {
    VLDDailyRecord *dailyRecord = [[VLDDailyRecord alloc] init];
    
    VLDBasicPoint *basicPoint = self.basicPoints[indexPath.row];
    dailyRecord.basicPoint = basicPoint;
    
    RLMResults *records = [VLDRecord recordForBasicPoint:basicPoint onDate:self.datePickerView.selectedDate];
    dailyRecord.record = [records firstObject];
    
    return dailyRecord;
}

- (void)onLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gestureRecognizer locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
        VLDBasicPoint *basicPoint = self.basicPoints[indexPath.row];
        RLMResults *records = [VLDRecord recordForBasicPoint:basicPoint onDate:self.datePickerView.selectedDate];
        VLDRecord *record = [records firstObject];
        
        self.recordNotesPresenter.record = record;
        [self.recordNotesPresenter present];
        [self.tableView selectRowAtIndexPath:indexPath
                                    animated:YES
                              scrollPosition:UITableViewScrollPositionMiddle];
    }
}

- (void)onTapListButton:(id)sender {
    VLDBasicPointsViewController *viewController = [[VLDBasicPointsViewController alloc] init];
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Puntos Básicos";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.basicPoints.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VLDDailyRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([VLDDailyRecordTableViewCell class])];
    cell.model = [self dailyRecordAtIndexPath:indexPath];
    cell.delegate = self;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VLDBasicPoint *basicPoint = self.basicPoints[indexPath.row];
    RLMResults *records = [VLDRecord recordForBasicPoint:basicPoint onDate:self.datePickerView.selectedDate];
    VLDRecord *record = [records firstObject];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    if (record) {
        [realm deleteObject:record];
    } else {
        record = [[VLDRecord alloc] init];
        record.date = self.datePickerView.selectedDate;
        record.basicPoint = basicPoint;
        record.notes = @"";
        [realm addObject:record];
    }
    
    [realm commitWriteTransaction];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - VLDRecordNotesPresenterDataSource

- (VLDBasicPoint *)basicPointForRecordNotesPresenter:(VLDRecordNotesPresenter *)presenter {
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    return self.basicPoints[selectedIndexPath.row];
}

- (NSDate *)dateForRecordNotesPresenter:(VLDRecordNotesPresenter *)presenter {
    return self.datePickerView.selectedDate;
}

- (UIViewController *)viewControllerForRecordNotesPresenter:(VLDRecordNotesPresenter *)presenter {
    return self;
}

#pragma mark - VLDRecordNotesPresenterDelegate

- (void)recordNotesPresenterDidFinishRecording:(VLDRecordNotesPresenter *)presenter {
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    if (selectedIndexPath) {
        [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
        [self.tableView reloadRowsAtIndexPaths:@[selectedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)recordNotesPresenterDidCancelRecording:(VLDRecordNotesPresenter *)presenter {
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    if (selectedIndexPath) {
        [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
    }
}

#pragma mark - VLDDailyRecordTableViewCellDelegate

- (void)dailyRecordTableViewCellDidPressInfoButton:(VLDDailyRecordTableViewCell *)cell {
    self.recordNotesPresenter.record = cell.model.record;
    [self.recordNotesPresenter present];
}

#pragma mark - VLDDatePickerViewDelegate

- (void)datePickerView:(VLDDatePickerView *)datePickerView didChangeSelectionWithDirection:(VLDArrowButtonDirection)direction {
    [self setupDataSource];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                  withRowAnimation:direction == VLDArrowButtonDirectionLeft? UITableViewRowAnimationRight : UITableViewRowAnimationLeft];
}

#pragma mark - VLDBasicPointsViewControllerDelegate

- (void)basicPointsViewControllerDidChangeProperties:(VLDBasicPointsViewController *)viewController {
    [self setupDataSource];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                  withRowAnimation:UITableViewRowAnimationFade];
}

@end
