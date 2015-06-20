//
//  VLDDatePickerView.m
//  Velad
//
//  Created by Renzo Crisóstomo on 13/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDDatePickerView.h"
#import <Masonry/Masonry.h>
#import "UIColor+VLDAdditions.h"
#import "NSDate+VLDAdditions.h"

@interface VLDDatePickerView ()

@property (nonatomic, weak) UILabel *selectedDateLabel;
@property (nonatomic) NSDateFormatter *dateFormatter;

- (void)setupView;
- (void)setupSelectedDate;
- (void)setupDateFormatter;
- (void)setupSubviews;
- (void)updateSelectedDateLabel;
- (void)onTapSelectedDateLabel:(UITapGestureRecognizer *)tapGestureRecognizer;

@end

static CGFloat const kButtonsHorizontalPadding = 40;
static NSTimeInterval const kDayTimeInterval = 24 * 60 * 60;

@implementation VLDDatePickerView

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
    NSDateComponents *components = [[NSCalendar currentCalendar]
                                    components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                    fromDate:[NSDate date]];
    self.selectedDate = [[NSCalendar currentCalendar] dateFromComponents:components];
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
    label.userInteractionEnabled = YES;
    [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(onTapSelectedDateLabel:)]];
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(label.superview);
    }];
    _selectedDateLabel = label;
    [self updateSelectedDateLabel];
}

#pragma mark - Private methods

- (void)onTapLeftArrow:(id)sender {
    self.selectedDate = [self.selectedDate dateByAddingTimeInterval:-kDayTimeInterval];
    [self updateSelectedDateLabel];
    [self setNeedsLayout];
    if ([self.delegate respondsToSelector:@selector(datePickerView:didChangeSelectionWithDirection:)]) {
        [self.delegate datePickerView:self didChangeSelectionWithDirection:VLDArrowButtonDirectionLeft];
    }
}

- (void)onTapRightArrow:(id)sender {
    self.selectedDate = [self.selectedDate dateByAddingTimeInterval:kDayTimeInterval];
    [self updateSelectedDateLabel];
    [self setNeedsLayout];
    if ([self.delegate respondsToSelector:@selector(datePickerView:didChangeSelectionWithDirection:)]) {
        [self.delegate datePickerView:self didChangeSelectionWithDirection:VLDArrowButtonDirectionRight];
    }
}

- (void)updateSelectedDateLabel {
    NSString *selectedDateString = [self.dateFormatter stringFromDate:self.selectedDate];
    NSString *todayString = @"";
    if (![self.selectedDate isToday]) {
        todayString = @"\nIr al día actual";
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
    self.selectedDateLabel.attributedText = [mutableAttributedString copy];
}

- (void)onTapSelectedDateLabel:(UITapGestureRecognizer *)tapGestureRecognizer {
    if ([self.selectedDate isToday]) {
        return;
    }
    VLDArrowButtonDirection direction = [self.selectedDate compare:[NSDate date]] == NSOrderedAscending ? VLDArrowButtonDirectionRight : VLDArrowButtonDirectionLeft;
    [self setupSelectedDate];
    [self updateSelectedDateLabel];
    [self setNeedsLayout];
    if ([self.delegate respondsToSelector:@selector(datePickerView:didChangeSelectionWithDirection:)]) {
        [self.delegate datePickerView:self didChangeSelectionWithDirection:direction];
    }
}

@end
