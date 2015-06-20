//
//  VLDDatePickerView.h
//  Velad
//
//  Created by Renzo Crisóstomo on 13/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VLDArrowButton.h"

@protocol VLDDatePickerViewDelegate;

@interface VLDDatePickerView : UIView

@property (nonatomic) NSDate *selectedDate;
@property (nonatomic, weak) id<VLDDatePickerViewDelegate> delegate;

@end

@protocol VLDDatePickerViewDelegate <NSObject>

- (void)datePickerView:(VLDDatePickerView *)datePickerView didChangeSelectionWithDirection:(VLDArrowButtonDirection)direction;

@end
