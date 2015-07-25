//
//  VLDReportsModePickerView.m
//  Velad
//
//  Created by Renzo Crisóstomo on 25/07/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDReportsModePickerView.h"
#import "UIColor+VLDAdditions.h"
#import <Masonry/Masonry.h>

@interface VLDReportsModePickerView ()

@property (nonatomic) VLDReportsMode mode;
@property (nonatomic, weak, readonly) UISegmentedControl *segmentedControl;

- (void)setupView;
- (void)setupSubviews;
- (void)onValueChangedSegmentedControl:(id)sender;

@end

static NSInteger const kSegmentedControlOffset = 10;

@implementation VLDReportsModePickerView

#pragma mark - Public methods

- (instancetype)initWithMode:(VLDReportsMode)mode {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _mode = mode;
        [self setupView];
        [self setupSubviews];
    }
    
    return self;
}

#pragma mark - Setup methods

- (void)setupView {
    self.backgroundColor = [UIColor vld_mainColor];
}

- (void)setupSubviews {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectZero];
    bottomView.backgroundColor = [UIColor colorWithRed:167.0/255.0
                                                 green:167.0/255.0
                                                  blue:170.0/255.0
                                                 alpha:1];
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        UIScreen *mainScreen = [UIScreen mainScreen];
        CGFloat scale = [mainScreen respondsToSelector:@selector(nativeScale)] ? mainScreen.nativeScale : mainScreen.scale;
        make.height.equalTo(@(1.0 / scale));
        make.leading.equalTo(bottomView.superview);
        make.trailing.equalTo(bottomView.superview);
        make.bottom.equalTo(bottomView.superview);
    }];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Semanal", @"Mensual"]];
    segmentedControl.selectedSegmentIndex = _mode;
    [segmentedControl addTarget:self
                         action:@selector(onValueChangedSegmentedControl:)
               forControlEvents:UIControlEventValueChanged];
    [self addSubview:segmentedControl];
    [segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(segmentedControl.superview).with.offset(kSegmentedControlOffset);
        make.leading.equalTo(segmentedControl.superview).with.offset(kSegmentedControlOffset);
        make.trailing.equalTo(segmentedControl.superview).with.offset(-kSegmentedControlOffset);
        make.bottom.equalTo(bottomView).with.offset(-kSegmentedControlOffset);
    }];
    _segmentedControl = segmentedControl;
}

#pragma mark - Private methods

- (void)onValueChangedSegmentedControl:(id)sender {
    self.mode = self.segmentedControl.selectedSegmentIndex;
    if ([self.delegate respondsToSelector:@selector(reportsModePickerViewDidChangeMode:)]) {
        [self.delegate reportsModePickerViewDidChangeMode:self];
    }
}

@end
