//
//  VLDDateIntervalPickerView.h
//  Velad
//
//  Created by Renzo Crisóstomo on 14/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VLDArrowButton.h"

typedef NS_ENUM(NSUInteger, VLDDateIntervalPickerViewType) {
    VLDDateIntervalPickerViewTypeWeekly,
    VLDDateIntervalPickerViewTypeMonthly
};

extern NSString * const VLDDateIntervalPickerViewStepStartKey;
extern NSString * const VLDDateIntervalPickerViewStepEndKey;

@protocol VLDDateIntervalPickerViewDelegate;

@interface VLDDateIntervalPickerView : UIView

@property (nonatomic, readonly) NSDate *selectedStartDate;
@property (nonatomic, readonly) NSDate *selectedEndDate;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, weak) id<VLDDateIntervalPickerViewDelegate> delegate;
@property (nonatomic, readonly) VLDDateIntervalPickerViewType type;

- (instancetype)initWithType:(VLDDateIntervalPickerViewType)type;
- (NSArray *)dayStepsForSelection;
- (void)resetPicketWithType:(VLDDateIntervalPickerViewType)type;

@end

@protocol VLDDateIntervalPickerViewDelegate <NSObject>

- (void)dateIntervalPickerView:(VLDDateIntervalPickerView *)dateIntervalPickerView didChangeSelectionWithDirection:(VLDArrowButtonDirection)direction;

@end
