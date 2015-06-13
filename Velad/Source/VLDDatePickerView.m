//
//  VLDDatePickerView.m
//  Velad
//
//  Created by Renzo Crisóstomo on 13/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDDatePickerView.h"
#import <Masonry/Masonry.h>

@interface VLDDatePickerView ()

@property (nonatomic, weak) UILabel *selectedDateLabel;
@property (nonatomic) NSDateFormatter *dateFormatter;

- (void)setupSelectedDate;
- (void)setupSubviews;

@end

static CGFloat const kButtonsHorizontalPadding = 40;
static NSTimeInterval const kDayTimeInterval = 24 * 60 * 60;

@implementation VLDDatePickerView

#pragma mark - Public methods

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupSelectedDate];
        [self setupDateFormatter];
        [self setupSubviews];
    }
    
    return self;
}

#pragma mark - Setup methods

- (void)setupSelectedDate {
    NSDateComponents *components = [[NSCalendar currentCalendar]
                                    components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                    fromDate:[NSDate date]];
    _selectedDate = [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (void)setupDateFormatter {
    _dateFormatter = [[NSDateFormatter alloc] init];
    _dateFormatter.dateFormat = @"d' de 'MMMM";
    _dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"es"];
}

- (void)setupSubviews {
    UIButton *leftArrowButton = [[UIButton alloc] init];
    [leftArrowButton setImage:[[UIImage imageNamed:@"LeftArrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                     forState:UIControlStateNormal];
    [self addSubview:leftArrowButton];
    [leftArrowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(leftArrowButton.superview).with.offset(kButtonsHorizontalPadding);
        make.centerY.equalTo(leftArrowButton.superview);
    }];
    [leftArrowButton addTarget:self
                        action:@selector(onTapLeftArrow:)
              forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightArrowButton = [[UIButton alloc] init];
    [rightArrowButton setImage:[[UIImage imageNamed:@"RightArrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                     forState:UIControlStateNormal];
    [self addSubview:rightArrowButton];
    [rightArrowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(rightArrowButton.superview).with.offset(-kButtonsHorizontalPadding);
        make.centerY.equalTo(rightArrowButton.superview);
    }];
    [rightArrowButton addTarget:self
                         action:@selector(onTapRightArrow:)
               forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = [_dateFormatter stringFromDate:_selectedDate];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(label.superview);
    }];
    _selectedDateLabel = label;
}

#pragma mark - Private methods

- (void)onTapLeftArrow:(id)sender {
    self.selectedDate = [self.selectedDate dateByAddingTimeInterval:-kDayTimeInterval];
    self.selectedDateLabel.text = [self.dateFormatter stringFromDate:self.selectedDate];
    [self setNeedsLayout];
    if ([self.delegate respondsToSelector:@selector(datePickerViewDidChangeSelection:)]) {
        [self.delegate datePickerViewDidChangeSelection:self];
    }
}

- (void)onTapRightArrow:(id)sender {
    self.selectedDate = [self.selectedDate dateByAddingTimeInterval:kDayTimeInterval];
    self.selectedDateLabel.text = [self.dateFormatter stringFromDate:self.selectedDate];
    [self setNeedsLayout];
    if ([self.delegate respondsToSelector:@selector(datePickerViewDidChangeSelection:)]) {
        [self.delegate datePickerViewDidChangeSelection:self];
    }
}

@end
