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

@property (nonatomic) NSDate *selectedStartDate;
@property (nonatomic) NSDate *selectedEndDate;
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

- (instancetype)initWithType:(VLDDateIntervalPickerViewType)type {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _type = type;
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
    NSDate *periodStart;
    NSTimeInterval timeInterval;
    [[NSCalendar currentCalendar] rangeOfUnit:_type == VLDDateIntervalPickerViewTypeWeekly ? NSWeekCalendarUnit : NSMonthCalendarUnit
                                    startDate:&periodStart
                                     interval:&timeInterval
                                      forDate:[NSDate date]];
    _selectedStartDate = periodStart;
    _selectedEndDate = [periodStart dateByAddingTimeInterval:timeInterval - 1];
}

- (void)setupDateFormatter {
    _dateFormatter = [[NSDateFormatter alloc] init];
    if (_type == VLDDateIntervalPickerViewTypeWeekly) {
        _dateFormatter.dateFormat = @"d' de 'MMMM";
    } else {
        _dateFormatter.dateFormat = @"MMMM yyyy";
    }
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
    if (self.type == VLDDateIntervalPickerViewTypeWeekly) {
        NSString *endDateText = [self.dateFormatter stringFromDate:self.selectedEndDate];
        NSDateComponents *startDateComponents = [[NSCalendar currentCalendar]
                                                 components:NSDayCalendarUnit
                                                 fromDate:self.selectedStartDate];
        return [NSString stringWithFormat:@"%ld al %@", (long)startDateComponents.day, endDateText];
    } else if (self.type == VLDDateIntervalPickerViewTypeMonthly) {
        NSString *month = [self.dateFormatter stringFromDate:self.selectedStartDate];
        return [month capitalizedString];
    }
    return nil;
}

- (void)onTapLeftArrow:(id)sender {
    if (self.type == VLDDateIntervalPickerViewTypeWeekly) {
        self.selectedStartDate = [self.selectedStartDate dateByAddingTimeInterval:-kWeekTimeInterval];
        self.selectedEndDate = [self.selectedEndDate dateByAddingTimeInterval:-kWeekTimeInterval];
    } else if (self.type == VLDDateIntervalPickerViewTypeMonthly) {
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        dateComponents.month = -1;
        self.selectedStartDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents
                                                                               toDate:self.selectedStartDate
                                                                              options:0];
        self.selectedEndDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents
                                                                             toDate:self.selectedStartDate
                                                                            options:0];
    }
    self.selectedDateIntervalLabel.text = [self labelTextForCurrentIntervalSelection];
    [self setNeedsLayout];
    if ([self.delegate respondsToSelector:@selector(dateIntervalPickerViewDidChangeSelection:)]) {
        [self.delegate dateIntervalPickerViewDidChangeSelection:self];
    }
}

- (void)onTapRightArrow:(id)sender {
    if (self.type == VLDDateIntervalPickerViewTypeWeekly) {
        self.selectedStartDate = [self.selectedStartDate dateByAddingTimeInterval:kWeekTimeInterval];
        self.selectedEndDate = [self.selectedEndDate dateByAddingTimeInterval:kWeekTimeInterval];
    } else if (self.type == VLDDateIntervalPickerViewTypeMonthly) {
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        dateComponents.month = 1;
        self.selectedStartDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents
                                                                               toDate:self.selectedStartDate
                                                                              options:0];
        self.selectedEndDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents
                                                                             toDate:self.selectedStartDate
                                                                            options:0];
    }
    self.selectedDateIntervalLabel.text = [self labelTextForCurrentIntervalSelection];
    [self setNeedsLayout];
    if ([self.delegate respondsToSelector:@selector(dateIntervalPickerViewDidChangeSelection:)]) {
        [self.delegate dateIntervalPickerViewDidChangeSelection:self];
    }
}

@end
