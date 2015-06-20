//
//  VLDDateIntervalPickerView.m
//  Velad
//
//  Created by Renzo Crisóstomo on 14/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDDateIntervalPickerView.h"
#import <Masonry/Masonry.h>
#import "UIColor+VLDAdditions.h"

@interface VLDDateIntervalPickerView ()

@property (nonatomic) NSDate *selectedStartDate;
@property (nonatomic) NSDate *selectedEndDate;
@property (nonatomic, weak) UILabel *selectedDateIntervalLabel;
@property (nonatomic) NSDateFormatter *dateFormatter;
@property (nonatomic) VLDDateIntervalPickerViewType type;

- (void)setupView;
- (void)setupSelectedDate;
- (void)setupDateFormatter;
- (void)setupSubviews;
- (NSString *)labelTextForCurrentIntervalSelection;
- (void)updateSelectedDateIntervalLabel;
- (void)onTapSelectedDateIntervalLabel:(UITapGestureRecognizer *)tapGestureRecognizer;

@end

NSString * const VLDDateIntervalPickerViewStepStartKey = @"VLDDateIntervalPickerViewStepStartKey";
NSString * const VLDDateIntervalPickerViewStepEndKey = @"VLDDateIntervalPickerViewStepEndKey";
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

- (NSArray *)dayStepsForSelection {
    NSMutableArray *daySteps = [NSMutableArray array];
    NSRange range = [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit
                                                       inUnit:self.type == VLDDateIntervalPickerViewTypeWeekly ? NSWeekCalendarUnit : NSMonthCalendarUnit
                                                      forDate:self.selectedStartDate];
    NSUInteger steps = range.length;
    NSDate *pivotDate = self.selectedStartDate;
    for (NSUInteger index = 0; index < steps; index++) {
        NSTimeInterval timeInterval;
        NSDate *startDate;
        [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit
                                        startDate:&startDate
                                         interval:&timeInterval
                                          forDate:pivotDate];
        NSDate *endDate = [startDate dateByAddingTimeInterval:timeInterval - 1];
        [daySteps addObject:@{VLDDateIntervalPickerViewStepStartKey: startDate,
                              VLDDateIntervalPickerViewStepEndKey: endDate}];
        pivotDate = [startDate dateByAddingTimeInterval:timeInterval];
    }
    return [daySteps copy];
}

- (void)resetPicketWithType:(VLDDateIntervalPickerViewType)type {
    self.type = type;
    [self setupSelectedDate];
    [self setupDateFormatter];
    [self updateSelectedDateIntervalLabel];
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
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 2;
    label.text = [self labelTextForCurrentIntervalSelection];
    label.userInteractionEnabled = YES;
    [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(onTapSelectedDateIntervalLabel:)]];
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
    [self updateSelectedDateIntervalLabel];
    [self setNeedsLayout];
    if ([self.delegate respondsToSelector:@selector(dateIntervalPickerView:didChangeSelectionWithDirection:)]) {
        [self.delegate dateIntervalPickerView:self didChangeSelectionWithDirection:VLDArrowButtonDirectionLeft];
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
    [self updateSelectedDateIntervalLabel];
    [self setNeedsLayout];
    if ([self.delegate respondsToSelector:@selector(dateIntervalPickerView:didChangeSelectionWithDirection:)]) {
        [self.delegate dateIntervalPickerView:self didChangeSelectionWithDirection:VLDArrowButtonDirectionRight];
    }
}

- (BOOL)isTodayInCurrentIntervalSelection {
    NSDate *today = [NSDate date];
    return [self.selectedStartDate compare:today] == NSOrderedAscending && [self.selectedEndDate compare:today] == NSOrderedDescending;
}

- (void)updateSelectedDateIntervalLabel {
    NSString *selectedDateString = [self labelTextForCurrentIntervalSelection];
    NSString *todayString = @"";
    if (![self isTodayInCurrentIntervalSelection]) {
        if (self.type == VLDDateIntervalPickerViewTypeWeekly) {
            todayString = @"\nIr a la semana actual";
        } else if (self.type == VLDDateIntervalPickerViewTypeMonthly) {
            todayString = @"\nIr al mes actual";
        }
    }
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", selectedDateString, todayString]];
    [mutableAttributedString addAttribute:NSFontAttributeName
                                    value:[UIFont systemFontOfSize:[UIFont labelFontSize]]
                                    range:NSMakeRange(0, selectedDateString.length)];
    [mutableAttributedString addAttribute:NSFontAttributeName
                                    value:[UIFont systemFontOfSize:[UIFont labelFontSize] - 4]
                                    range:NSMakeRange(selectedDateString.length, mutableAttributedString.length - selectedDateString.length)];
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName
                                    value:[UIColor vld_mainColor]
                                    range:NSMakeRange(selectedDateString.length, mutableAttributedString.length - selectedDateString.length)];
    self.selectedDateIntervalLabel.attributedText = [mutableAttributedString copy];
}

- (void)onTapSelectedDateIntervalLabel:(UITapGestureRecognizer *)tapGestureRecognizer {
    if ([self isTodayInCurrentIntervalSelection]) {
        return;
    }
    VLDArrowButtonDirection direction = [self.selectedStartDate compare:[NSDate date]] == NSOrderedAscending ? VLDArrowButtonDirectionRight : VLDArrowButtonDirectionLeft;
    [self setupSelectedDate];
    [self updateSelectedDateIntervalLabel];
    [self setNeedsLayout];
    if ([self.delegate respondsToSelector:@selector(dateIntervalPickerView:didChangeSelectionWithDirection:)]) {
        [self.delegate dateIntervalPickerView:self didChangeSelectionWithDirection:direction];
    }
}

@end
