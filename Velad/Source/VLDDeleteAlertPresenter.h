//
//  VLDDeleteAlarmPresenter.h
//  Velad
//
//  Created by Renzo Crisóstomo on 16/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VLDDeleteAlertPresenterDataSource;
@protocol VLDDeleteAlertPresenterDelegate;

@class VLDBasicPoint;

@interface VLDDeleteAlertPresenter : NSObject

@property (nonatomic, weak) id<VLDDeleteAlertPresenterDelegate> delegate;

- (instancetype)initWithDataSource:(id<VLDDeleteAlertPresenterDataSource>)dataSource;
- (void)present;

@end

@protocol VLDDeleteAlertPresenterDataSource <NSObject>

- (UIViewController *)viewControllerForDeleteAlarmPresenter:(VLDDeleteAlertPresenter *)presenter;

@end

@protocol VLDDeleteAlertPresenterDelegate <NSObject>

- (void)deleteAlarmPresenterDidSelectDelete:(VLDDeleteAlertPresenter *)presenter;
- (void)deleteAlarmPresenterDidCancelDelete:(VLDDeleteAlertPresenter *)presenter;

@end
