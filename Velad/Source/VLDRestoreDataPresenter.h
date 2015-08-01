//
//  VLDRestoreDataPresenter.h
//  Velad
//
//  Created by Renzo Crisóstomo on 02/08/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VLDRestoreDataPresenterDelegate;
@protocol VLDRestoreDataPresenterDataSource;

@interface VLDRestoreDataPresenter : NSObject

@property (nonatomic, weak) id<VLDRestoreDataPresenterDelegate> delegate;

- (instancetype)initWithDataSource:(id<VLDRestoreDataPresenterDataSource>)dataSource;
- (void)present;

@end

@protocol VLDRestoreDataPresenterDataSource <NSObject>

- (UIViewController *)viewControllerForRestoreDataPresenter:(VLDRestoreDataPresenter *)presenter;

@end

@protocol VLDRestoreDataPresenterDelegate <NSObject>

- (void)restoreDataPresenterDidAccept:(VLDRestoreDataPresenter *)presenter;
- (void)restoreDataPresenterDidCancel:(VLDRestoreDataPresenter *)presenter;

@end