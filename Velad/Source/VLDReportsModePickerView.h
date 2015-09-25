//
//  VLDReportsModePickerView.h
//  Velad
//
//  Created by Renzo Crisóstomo on 25/07/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, VLDReportsMode) {
    VLDReportsModeWeekly,
    VLDReportsModeMonthly,
};

@protocol VLDReportsModePickerViewDelegate;

@interface VLDReportsModePickerView : UIView

@property (nonatomic, readonly) VLDReportsMode mode;
@property (nonatomic, weak) id<VLDReportsModePickerViewDelegate> delegate;

- (instancetype)initWithMode:(VLDReportsMode)mode;

@end

@protocol VLDReportsModePickerViewDelegate <NSObject>

- (void)reportsModePickerViewDidChangeMode:(VLDReportsModePickerView *)reportsModePickerView;

@end
