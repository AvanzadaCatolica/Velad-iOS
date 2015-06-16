//
//  VLDDateIntervalPickerView.m
//  Velad
//
//  Created by Renzo Crisóstomo on 14/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDDateIntervalPickerView.h"
#import <Masonry/Masonry.h>
#import "VLDArrowButton.h"

@interface VLDDateIntervalPickerView ()

@property (nonatomic, weak) UILabel *selectedDateIntervalLabel;
@property (nonatomic) NSDateFormatter *dateFormatter;

- (void)setupView;
- (void)setupSelectedDate;
- (void)setupDateFormatter;
- (void)setupSubviews;
- (NSString *)labelTextForCurrentIntervalSelection;

@end

static CGFloat const kButtonsHorizontalPadding = 40;
static NSTimeInterval const kWeekTimeInterval = 7 * 24 * 60 * 60;

@implementation VLDDateIntervalPickerView

#pragma mark - Public methods

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        [self setupSelectedDate];
        [self setupDateFormatter];
        [self setupSubviews];
    }
    
    return self;
}

#pragma mark - Setup methods

- (void)setupView {
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)setupSelectedDate {
    NSDate *weekStart;
    NSTimeInterval timeInterval;
    [[NSCalendar currentCalendar] rangeOfUnit:NSWeekCalendarUnit
                                    startDate:&weekStart
                                     interval:&timeInterval
                                      forDate:[NSDate date]];
    _selectedStartDate = weekStart;
    _selectedEndDate = [weekStart dateByAddingTimeInterval:timeInterval - 1];
}

- (void)setupDateFormatter {
    _dateFormatter = [[NSDateFormatter alloc] init];
    _dateFormatter.dateFormat = @"d' de 'MMMM";
    _dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"es"];
}

- (void)setupSubviews {
    VLDArrowButton *leftArrowButton = [VLDArrowButton buttonWithDirection:VLDArrowButtonDirectionLeft];
    [self addSubview:leftArrowButton];
    [leftArrowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(leftArrowButton.superview).with.offset(kButtonsHorizontalPadding);
        make.centerY.equalTo(leftArrowButton.superview);
    }];
    [leftArrowButton addTarget:self
                        action:@selector(onTapLeftArrow:)
              forControlEvents:UIControlEventTouchUpInside];
    
    VLDArrowButton *rightArrowButton = [VLDArrowButton buttonWithDirection:VLDArrowButtonDirectionRight];
    [self addSubview:rightArrowButton];
    [rightArrowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(rightArrowButton.superview).with.offset(-kButtonsHorizontalPadding);
        make.centerY.equalTo(rightArrowButton.superview);
    }];
    [rightArrowButton addTarget:self
                         action:@selector(onTapRightArrow:)
               forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = [self labelTextForCurrentIntervalSelection];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(label.superview);
    }];
    _selectedDateIntervalLabel = label;
}

#pragma mark - Private methods

- (NSString *)labelTextForCurrentIntervalSelection {
    NSString *endDateText = [self.dateFormatter stringFromDate:self.selectedEndDate];
    NSDateComponents *startDateComponents = [[NSCalendar currentCalendar]
                                             components:NSDayCalendarUnit
                                             fromDate:self.selectedStartDate];
    return [NSString stringWithFormat:@"%ld al %@", (long)startDateComponents.day, endDateText];
}

- (void)onTapLeftArrow:(id)sender {
    self.selectedStartDate = [self.selectedStartDate dateByAddingTimeInterval:-kWeekTimeInterval];
    self.selectedEndDate = [self.selectedEndDate dateByAddingTimeInterval:-kWeekTimeInterval];
    self.selectedDateIntervalLabel.text = [self labelTextForCurrentIntervalSelection];
    [self setNeedsLayout];
    if ([self.delegate respondsToSelector:@selector(dateIntervalPickerViewDidChangeSelection:)]) {
        [self.delegate dateIntervalPickerViewDidChangeSelection:self];
    }
}

- (void)onTapRightArrow:(id)sender {
    self.selectedStartDate = [self.selectedStartDate dateByAddingTimeInterval:kWeekTimeInterval];
    self.selectedEndDate = [self.selectedEndDate dateByAddingTimeInterval:kWeekTimeInterval];
    self.selectedDateIntervalLabel.text = [self labelTextForCurrentIntervalSelection];
    [self setNeedsLayout];
    if ([self.delegate respondsToSelector:@selector(dateIntervalPickerViewDidChangeSelection:)]) {
        [self.delegate dateIntervalPickerViewDidChangeSelection:self];
    }
}

@end
