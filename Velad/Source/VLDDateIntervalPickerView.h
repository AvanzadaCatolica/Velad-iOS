//
//  VLDDateIntervalPickerView.h
//  Velad
//
//  Created by Renzo Crisóstomo on 14/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, VLDDateIntervalPickerViewType) {
    VLDDateIntervalPickerViewTypeWeekly,
    VLDDateIntervalPickerViewTypeMonthly
};

@protocol VLDDateIntervalPickerViewDelegate;

@interface VLDDateIntervalPickerView : UIView

@property (nonatomic, readonly) NSDate *selectedStartDate;
@property (nonatomic, readonly) NSDate *selectedEndDate;
@property (nonatomic, weak) id<VLDDateIntervalPickerViewDelegate> delegate;
@property (nonatomic, readonly) VLDDateIntervalPickerViewType type;

- (instancetype)initWithType:(VLDDateIntervalPickerViewType)type;

@end

@protocol VLDDateIntervalPickerViewDelegate <NSObject>

- (void)dateIntervalPickerViewDidChangeSelection:(VLDDateIntervalPickerView *)dateIntervalPickerView;

@end
