//
//  VLDReportsResultView.h
//  Velad
//
//  Created by Renzo Crisóstomo on 20/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, VLDReportsResultViewMode) {
    VLDReportsResultViewModeWeekly,
    VLDReportsResultViewModeMonthly
};

@protocol VLDReportsResultViewDataSource;

@interface VLDReportsResultView : UIView

@property (nonatomic, readonly) VLDReportsResultViewMode mode;

- (instancetype)initWithDataSource:(id<VLDReportsResultViewDataSource>)dataSource
                              mode:(VLDReportsResultViewMode)mode;
- (void)reloadResultViewWithMode:(VLDReportsResultViewMode)mode;

@end

@protocol VLDReportsResultViewDataSource <NSObject>

- (NSUInteger)maximumPossibleScoreForReportsResultView:(VLDReportsResultView *)reportsResultView;
- (NSUInteger)scoreForReportsResultView:(VLDReportsResultView *)reportsResultView;

@end
