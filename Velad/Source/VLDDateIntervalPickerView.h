//
//  VLDDateIntervalPickerView.h
//  Velad
//
//  Created by Renzo Crisóstomo on 14/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VLDDateIntervalPickerViewDelegate;

@interface VLDDateIntervalPickerView : UIView

@property (nonatomic) NSDate *selectedStartDate;
@property (nonatomic) NSDate *selectedEndDate;
@property (nonatomic, weak) id<VLDDateIntervalPickerViewDelegate> delegate;

@end

@protocol VLDDateIntervalPickerViewDelegate <NSObject>

- (void)dateIntervalPickerViewDidChangeSelection:(VLDDateIntervalPickerView *)dateIntervalPickerView;

@end
