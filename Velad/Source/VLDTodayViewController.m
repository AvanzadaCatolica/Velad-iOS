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

@interface VLDTodayViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) RLMResults *basicPoints;
@property (nonatomic, weak) IBOutlet VLDDatePickerView *datePickerView;

- (void)setupDataSource;

@end

static CGFloat const kDatePickerHeight = 44;

@implementation VLDTodayViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDataSource];
    [self setupLayout];
    [self setupTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIRectEdge)edgesForExtendedLayout {
    return [super edgesForExtendedLayout] ^ UIRectEdgeBottom;
}

#pragma mark - Setup

- (void)setupDataSource {
    self.basicPoints = [VLDBasicPoint basicPoints];
}

- (void)setupLayout {
    [self.datePickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.datePickerView.superview);
        make.trailing.equalTo(self.datePickerView.superview);
        make.bottom.equalTo(self.datePickerView.superview);
        make.height.equalTo(@(kDatePickerHeight));
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
}

#pragma mark - Private methods

- (VLDDailyRecord *)dailyRecordAtIndexPath:(NSIndexPath *)indexPath {
    VLDDailyRecord *dailyRecord = [[VLDDailyRecord alloc] init];
    
    VLDBasicPoint *basicPoint = self.basicPoints[indexPath.row];
    dailyRecord.basicPoint = basicPoint;
    
    RLMResults *records = [VLDRecord recordForBasicPoint:basicPoint onDate:self.datePickerView.selectedDate];
    dailyRecord.record = records.count > 0 ? records[0] : nil;
    
    return dailyRecord;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.basicPoints.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VLDDailyRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([VLDDailyRecordTableViewCell class])];
    cell.model = [self dailyRecordAtIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate

@end
