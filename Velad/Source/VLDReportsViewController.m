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
#import <MessageUI/MessageUI.h>
#import "VLDProfile.h"
#import "UIView+VLDAdditions.h"
#import "VLDErrorPresenter.h"
#import "VLDReportsModePickerView.h"
#import "NSDate+VLDAdditions.h"

@interface VLDReportsViewController () <BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate, VLDReportsResultViewDataSource, VLDDateIntervalPickerViewDelegate, VLDErrorPresenterDataSource, MFMailComposeViewControllerDelegate, VLDReportsModePickerViewDelegate>

@property (nonatomic, weak) VLDReportsModePickerView *reportsModePickerView;
@property (nonatomic, weak) VLDDateIntervalPickerView *dateIntervalPickerView;
@property (nonatomic, weak) BEMSimpleLineGraphView *lineGraphView;
@property (nonatomic, weak) VLDReportsResultView *reportsResultView;
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic) NSArray *viewModels;
@property (nonatomic) NSDateFormatter *dateFormatter;
@property (nonatomic) NSUInteger lineGraphLastClosestIndex;
@property (nonatomic) VLDErrorPresenter *errorPresenter;

- (void)setupNavigationItem;
- (void)setupLayout;
- (void)setupDataSource;
- (void)setupReportsModePickerView;
- (void)setupChart;
- (void)setupDateIntervalPickerView;
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
    VLDReportsModePickerView *reportsPickerView = [[VLDReportsModePickerView alloc] initWithMode:VLDReportsModeWeekly];
    [view addSubview:reportsPickerView];
    self.reportsModePickerView = reportsPickerView;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
    contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [view addSubview:contentView];
    self.contentView = contentView;
    
    BEMSimpleLineGraphView *lineGraphView = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectZero];
    [contentView addSubview:lineGraphView];
    self.lineGraphView = lineGraphView;
    VLDDateIntervalPickerView *dateIntervalPickerView = [[VLDDateIntervalPickerView alloc] initWithType:VLDDateIntervalPickerViewTypeWeekly];
    [contentView addSubview:dateIntervalPickerView];
    self.dateIntervalPickerView = dateIntervalPickerView;
    VLDReportsResultView *reportsResultView = [[VLDReportsResultView alloc] initWithDataSource:self mode:VLDReportsResultViewModeWeekly];
    [contentView addSubview:reportsResultView];
    self.reportsResultView = reportsResultView;
    
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationItem];
    [self setupLayout];
    [self setupReportsModePickerView];
    [self setupChart];
    [self setupDateIntervalPickerView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupDataSource];
    [self.lineGraphView reloadGraph];
    [self.reportsResultView reloadResultViewWithMode:self.reportsResultView.mode
                                        isUntilToday:[self.dateIntervalPickerView isTodayInCurrentIntervalSelection]];
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
    self.navigationItem.title = @"Informes";
    UIImage *mailImage = [[UIImage imageNamed:@"Mail"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:mailImage
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(onTapMailButton:)];
}

- (void)setupLayout {
    [self.reportsModePickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.reportsModePickerView.superview);
        make.trailing.equalTo(self.reportsModePickerView.superview);
        make.top.equalTo(self.reportsModePickerView.superview);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView.superview);
        make.trailing.equalTo(self.contentView.superview);
        make.top.equalTo(self.reportsModePickerView.mas_bottom);
        make.bottom.equalTo(self.contentView.superview);
    }];
    
    [self.lineGraphView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.dateIntervalPickerView.superview).with.offset(20);
        make.trailing.equalTo(self.dateIntervalPickerView.superview).with.offset(-20);
        make.top.equalTo(self.dateIntervalPickerView.superview).with.offset(20);
        make.height.equalTo(self.dateIntervalPickerView.superview).with.multipliedBy(0.4);
    }];
    [self.dateIntervalPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.dateIntervalPickerView.superview);
        make.trailing.equalTo(self.dateIntervalPickerView.superview);
        make.bottom.equalTo(self.dateIntervalPickerView.superview);
        make.height.equalTo(self.dateIntervalPickerView.superview.superview).with.multipliedBy(0.2);
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
    RLMResults *basicPoints = [VLDBasicPoint objectsWhere:@"enabled == YES"];
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

- (void)setupReportsModePickerView {
    self.reportsModePickerView.delegate = self;
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

- (VLDErrorPresenter *)errorPresenter {
    if (_errorPresenter == nil) {
        _errorPresenter = [[VLDErrorPresenter alloc] initWithDataSource:self];
    }
    return _errorPresenter;
}

- (void)onTapMailButton:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] init];
        [composeViewController.navigationBar setTintColor:[UIColor whiteColor]];
        composeViewController.mailComposeDelegate = self;
        
        NSString *messageBody = @"";
        
        VLDProfile *profile = [[VLDProfile allObjects] firstObject];
        if (profile) {
            messageBody = [NSString stringWithFormat:@"Nombre: %@\nCírculo: %@\nGrupo: %@\n\n", profile.name, profile.circle, profile.group];
        }
        
        VLDReportsMode mode = self.reportsModePickerView.mode;
        
        messageBody = [messageBody stringByAppendingString:[NSString stringWithFormat:@"%@ %@\n\n", mode == VLDReportsModeWeekly ? @"Semana" : @"Mes", self.dateIntervalPickerView.title]];
        
        messageBody = [messageBody stringByAppendingFormat:@"Mi puntaje %@: %@", mode == VLDReportsModeWeekly ? @"esta semana" : @"este mes", self.reportsResultView.content];
        
        [composeViewController setSubject:[NSString stringWithFormat:@"Reporte %@", mode == VLDReportsModeWeekly ? @"semanal" : @"mensual"]];
        [composeViewController setMessageBody:messageBody isHTML:NO];
        [composeViewController addAttachmentData:UIImagePNGRepresentation([self.lineGraphView vld_snapshotImage])
                                        mimeType:@"image/png"
                                        fileName:@"Reporte.png"];
        [self presentViewController:composeViewController
                           animated:YES
                         completion:^{
                             [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
                         }];
    } else {
        [self.errorPresenter presentError:[NSError errorWithDomain:NSStringFromClass(self.class)
                                                              code:INT_MAX
                                                          userInfo:@{@"NSLocalizedDescription" : @"No se ha encontrado una cuenta de correo configurada"}]];
    }
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
    RLMResults *basicPoints = [VLDBasicPoint objectsWhere:@"enabled == YES"];
    if (reportsResultView.mode == VLDReportsModeWeekly) {
        NSUInteger weeklyfrequencyCount = 0;
        for (VLDBasicPoint *basicPoint in basicPoints) {
            if ([self.dateIntervalPickerView isTodayInCurrentIntervalSelection]) {
                weeklyfrequencyCount += [basicPoint possibleWeekDaysCountUntilCurrentWeekDay];
            } else {
                weeklyfrequencyCount += basicPoint.weekDays.count;
            }
        }
        return weeklyfrequencyCount;
    } else {
        NSArray *steps = [self.dateIntervalPickerView dayStepsForSelection];
        NSUInteger monthyfrequencyCount = 0;
        for (NSDictionary *step in steps) {
            NSDate *date = step[VLDDateIntervalPickerViewStepEndKey];
            for (VLDBasicPoint *basicPoint in basicPoints) {
                if ([basicPoint.weekDaySymbols indexOfObject:[date vld_weekdaySymbol]] != NSNotFound) {
                    monthyfrequencyCount++;
                }
            }
            if ([self.dateIntervalPickerView isTodayInCurrentIntervalSelection] &&
                [date vld_isToday]) {
                break;
            }
        }
        return monthyfrequencyCount;
    }
}

- (NSUInteger)scoreForReportsResultView:(VLDReportsResultView *)reportsResultView {
    NSUInteger count = 0;
    for (VLDReportsViewModel *viewModel in self.viewModels) {
        count += viewModel.count;
    }
    return count;
}

#pragma mark - VLDDateIntervalPickerViewDelegate

- (void)dateIntervalPickerView:(VLDDateIntervalPickerView *)dateIntervalPickerView didChangeSelectionWithDirection:(VLDArrowButtonDirection)direction {
    self.lineGraphLastClosestIndex = NSNotFound;
    [self setupDataSource];
    [self.lineGraphView reloadGraph];
    [self.reportsResultView reloadResultViewWithMode:self.reportsResultView.mode
                                        isUntilToday:[self.dateIntervalPickerView isTodayInCurrentIntervalSelection]];
}

#pragma mark - VLDErrorPresenterDataSource

- (UIViewController *)viewControllerForErrorPresenter:(VLDErrorPresenter *)presenter {
    return self;
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - VLDReportsModePickerViewDelegate

- (void)reportsModePickerViewDidChangeMode:(VLDReportsModePickerView *)reportsModePickerView {
    VLDReportsMode mode = self.reportsModePickerView.mode;
    self.lineGraphLastClosestIndex = NSNotFound;
    [self.dateIntervalPickerView resetPicketWithType:mode == VLDReportsModeWeekly? VLDDateIntervalPickerViewTypeWeekly : VLDDateIntervalPickerViewTypeMonthly];
    [self setupDataSource];
    self.lineGraphView.animationGraphEntranceTime = mode == VLDReportsModeWeekly ? 1 : 1.5;
    [self.lineGraphView reloadGraph];
    [self.reportsResultView reloadResultViewWithMode:mode == VLDReportsModeWeekly? VLDReportsResultViewModeWeekly : VLDReportsResultViewModeMonthly
                                        isUntilToday:[self.dateIntervalPickerView isTodayInCurrentIntervalSelection]];
}

@end
