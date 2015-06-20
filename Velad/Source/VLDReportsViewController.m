//
//  VLDReportsViewController.m
//  Velad
//
//  Created by Renzo Crisóstomo on 13/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDReportsViewController.h"
#import "VLDDateIntervalPickerView.h"
#import <Masonry/Masonry.h>
#import <Realm/Realm.h>
#import "VLDReportsViewModel.h"
#import "VLDRecord.h"
#import <BEMSimpleLineGraph/BEMSimpleLineGraphView.h>
#import "UIColor+VLDAdditions.h"
#import "VLDBasicPoint.h"
#import "VLDReportsResultView.h"

typedef NS_ENUM(NSUInteger, VLDReportsMode) {
    VLDReportsModeWeekly,
    VLDReportsModeMontly,
};

@interface VLDReportsViewController () <BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate, VLDReportsResultViewDataSource, VLDDateIntervalPickerViewDelegate>

@property (nonatomic, weak) UISegmentedControl *segmentedControl;
@property (nonatomic, weak) VLDDateIntervalPickerView *dateIntervalPickerView;
@property (nonatomic, weak) BEMSimpleLineGraphView *lineGraphView;
@property (nonatomic, weak) VLDReportsResultView *reportsResultView;
@property (nonatomic) NSArray *viewModels;
@property (nonatomic) NSDateFormatter *dateFormatter;
@property (nonatomic) NSUInteger lineGraphLastClosestIndex;

- (void)setupNavigationItem;
- (void)setupLayout;
- (void)setupDataSource;
- (void)setupChart;
- (void)setupDateIntervalPickerView;
- (void)onValueChangedSegmentedControl:(id)sender;
- (void)onTapMailButton:(id)sender;

@end

@implementation VLDReportsViewController

#pragma mark - Life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        _lineGraphLastClosestIndex = NSNotFound;
    }
    
    return self;
}

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    BEMSimpleLineGraphView *lineGraphView = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectZero];
    [view addSubview:lineGraphView];
    self.lineGraphView = lineGraphView;
    VLDDateIntervalPickerView *dateIntervalPickerView = [[VLDDateIntervalPickerView alloc] initWithType:VLDDateIntervalPickerViewTypeWeekly];
    [view addSubview:dateIntervalPickerView];
    self.dateIntervalPickerView = dateIntervalPickerView;
    VLDReportsResultView *reportsResultView = [[VLDReportsResultView alloc] initWithDataSource:self mode:VLDReportsResultViewModeWeekly];
    [view addSubview:reportsResultView];
    self.reportsResultView = reportsResultView;
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationItem];
    [self setupLayout];
    [self setupChart];
    [self setupDateIntervalPickerView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupDataSource];
    [self.lineGraphView reloadGraph];
    [self.reportsResultView reloadResultViewWithMode:self.reportsResultView.mode];
}

- (UIRectEdge)edgesForExtendedLayout {
    return [super edgesForExtendedLayout] ^ UIRectEdgeBottom;
}

#pragma mark - Setup methods

- (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"d/MM";
        _dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"es"];
    }
    return _dateFormatter;
}

- (void)setupNavigationItem {
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Semanal", @"Mensual"]];
    segmentedControl.selectedSegmentIndex = VLDReportsModeWeekly;
    [segmentedControl addTarget:self
                         action:@selector(onValueChangedSegmentedControl:)
               forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
    self.segmentedControl = segmentedControl;
    UIImage *mailImage = [[UIImage imageNamed:@"Mail"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:mailImage
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(onTapMailButton:)];
}

- (void)setupLayout {
    [self.lineGraphView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.dateIntervalPickerView.superview).with.offset(20);
        make.trailing.equalTo(self.dateIntervalPickerView.superview).with.offset(-20);
        make.top.equalTo(self.dateIntervalPickerView.superview).with.offset(20);
        make.height.equalTo(self.dateIntervalPickerView.superview).with.multipliedBy(0.3);
    }];
    [self.dateIntervalPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.dateIntervalPickerView.superview);
        make.trailing.equalTo(self.dateIntervalPickerView.superview);
        make.bottom.equalTo(self.dateIntervalPickerView.superview);
        make.height.equalTo(self.dateIntervalPickerView.superview).with.multipliedBy(0.2);
    }];
    [self.reportsResultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.dateIntervalPickerView.superview);
        make.trailing.equalTo(self.dateIntervalPickerView.superview);
        make.bottom.equalTo(self.dateIntervalPickerView.mas_top);
        make.top.equalTo(self.lineGraphView.mas_bottom);
    }];
}

- (void)setupDataSource {
    NSArray *steps = [self.dateIntervalPickerView dayStepsForSelection];
    NSMutableArray *viewModels = [NSMutableArray array];
    RLMResults *basicPoints = [VLDBasicPoint basicPoints];
    for (NSDictionary *step in steps) {
        NSUInteger count = 0;
        for (VLDBasicPoint *basicPoint in basicPoints) {
            RLMResults *records = [VLDRecord recordsForBasicPoint:basicPoint
                                                 betweenStartDate:step[VLDDateIntervalPickerViewStepStartKey]
                                                          endDate:step[VLDDateIntervalPickerViewStepEndKey]];
            count += records.count;
        }
        VLDReportsViewModel *viewModel = [[VLDReportsViewModel alloc] initWithDate:step[VLDDateIntervalPickerViewStepStartKey]
                                                                             count:count];
        [viewModels addObject:viewModel];
    }
    self.viewModels = [viewModels copy];
}

- (void)setupChart {
    self.lineGraphView.dataSource = self;
    self.lineGraphView.delegate = self;
    self.lineGraphView.enableYAxisLabel = YES;
    self.lineGraphView.enableReferenceAxisFrame = YES;
    self.lineGraphView.enableTouchReport = YES;
    self.lineGraphView.enablePopUpReport = YES;
    self.lineGraphView.animationGraphEntranceTime = 1;
    self.lineGraphView.colorTop = [UIColor groupTableViewBackgroundColor];
    self.lineGraphView.colorBottom = [UIColor groupTableViewBackgroundColor];
    self.lineGraphView.colorLine = [UIColor vld_mainColor];
    self.lineGraphView.colorPoint = [UIColor vld_mainColor];
}

- (void)setupDateIntervalPickerView {
    self.dateIntervalPickerView.delegate = self;
}

#pragma mark - Private methods

- (void)onValueChangedSegmentedControl:(id)sender {
    VLDReportsMode mode = self.segmentedControl.selectedSegmentIndex;
    self.lineGraphLastClosestIndex = NSNotFound;
    [self.dateIntervalPickerView resetPicketWithType:mode == VLDReportsModeWeekly? VLDDateIntervalPickerViewTypeWeekly : VLDDateIntervalPickerViewTypeMonthly];
    [self setupDataSource];
    [self.lineGraphView reloadGraph];
    [self.reportsResultView reloadResultViewWithMode:mode == VLDReportsModeWeekly? VLDReportsResultViewModeWeekly : VLDReportsResultViewModeMonthly];
}

- (void)onTapMailButton:(id)sender {
    
}

#pragma mark - BEMSimpleLineGraphDataSource

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return self.viewModels.count;
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    VLDReportsViewModel *viewModel = self.viewModels[index];
    return viewModel.count;
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    VLDReportsViewModel *viewModel = self.viewModels[index];
    return [self.dateFormatter stringFromDate:viewModel.date];
}

#pragma mark - BEMSimpleLineGraphDelegate

- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return self.viewModels.count;
}

- (NSInteger)numberOfYAxisLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 2;
}

- (NSString *)yAxisSuffixOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return @" ";
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didTouchGraphWithClosestIndex:(NSInteger)index {
    self.lineGraphLastClosestIndex = index;
}

- (NSString *)popUpSuffixForlineGraph:(BEMSimpleLineGraphView *)graph {
    if (self.lineGraphLastClosestIndex != NSNotFound) {
        VLDReportsViewModel *viewModel = self.viewModels[self.lineGraphLastClosestIndex];
        return [NSString stringWithFormat:@" en %@", [self.dateFormatter stringFromDate:viewModel.date]];
    }
    return @" en 00/00";
}

#pragma mark - VLDReportsResultViewDataSource

- (NSUInteger)maximumPossibleScoreForReportsResultView:(VLDReportsResultView *)reportsResultView {
    RLMResults *basicPoints = [VLDBasicPoint basicPoints];
    NSArray *steps = [self.dateIntervalPickerView dayStepsForSelection];
    return basicPoints.count * steps.count;
}

- (NSUInteger)scoreForReportsResultView:(VLDReportsResultView *)reportsResultView {
    NSUInteger count = 0;
    for (VLDReportsViewModel *viewModel in self.viewModels) {
        count += viewModel.count;
    }
    return count;
}

#pragma mark - VLDDateIntervalPickerViewDelegate

- (void)dateIntervalPickerViewDidChangeSelection:(VLDDateIntervalPickerView *)dateIntervalPickerView {
    [self setupDataSource];
    [self.lineGraphView reloadGraph];
    [self.reportsResultView reloadResultViewWithMode:self.reportsResultView.mode];
}

@end
