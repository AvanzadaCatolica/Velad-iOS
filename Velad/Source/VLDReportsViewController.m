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

typedef NS_ENUM(NSUInteger, VLDReportsMode) {
    VLDReportsModeWeekly,
    VLDReportsModeMontly,
};

@interface VLDReportsViewController ()

@property (nonatomic, weak) UISegmentedControl *segmentedControl;
@property (nonatomic, weak) VLDDateIntervalPickerView *dateIntervalPickerView;

- (void)setupNavigationItem;
- (void)onValueChangedSegmentedControl:(id)sender;
- (void)onTapSettingsButton:(id)sender;
- (void)onTapMailButton:(id)sender;
- (void)setupLayout;

@end

@implementation VLDReportsViewController

#pragma mark - Life cycle

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    VLDDateIntervalPickerView *dateIntervalPickerView = [[VLDDateIntervalPickerView alloc] initWithType:VLDDateIntervalPickerViewTypeWeekly];
    [view addSubview:dateIntervalPickerView];
    self.dateIntervalPickerView = dateIntervalPickerView;
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationItem];
    [self setupLayout];
}

- (UIRectEdge)edgesForExtendedLayout {
    return [super edgesForExtendedLayout] ^ UIRectEdgeBottom;
}

#pragma mark - Private methods

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
    [self.dateIntervalPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.dateIntervalPickerView.superview);
        make.trailing.equalTo(self.dateIntervalPickerView.superview);
        make.bottom.equalTo(self.dateIntervalPickerView.superview);
        make.height.equalTo(self.dateIntervalPickerView.superview).with.multipliedBy(0.2);
    }];
}

- (void)onValueChangedSegmentedControl:(id)sender {
    
}

}

- (void)onTapMailButton:(id)sender {
    
}

@end
