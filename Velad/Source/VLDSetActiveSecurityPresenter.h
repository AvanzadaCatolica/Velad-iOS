//
//  VLDSetActiveSecurityPresenter.h
//  Velad
//
//  Created by Renzo Crisóstomo on 16/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VLDSetActiveSecurityPresenterDelegate;
@protocol VLDSetActiveSecurityPresenterDataSource;

@interface VLDSetActiveSecurityPresenter : NSObject

@property (nonatomic, weak) id<VLDSetActiveSecurityPresenterDelegate> delegate;

- (instancetype)initWithDataSource:(id<VLDSetActiveSecurityPresenterDataSource>)dataSource;
- (void)present;

@end

@protocol VLDSetActiveSecurityPresenterDataSource <NSObject>

- (UIViewController *)viewControllerForSetActiveSecurityPresenter:(VLDSetActiveSecurityPresenter *)presenter;

@end

@protocol VLDSetActiveSecurityPresenterDelegate <NSObject>

- (void)setActiveSecurityPresenterDidAccept:(VLDSetActiveSecurityPresenter *)presenter;
- (void)setActiveSecurityPresenterDidCancel:(VLDSetActiveSecurityPresenter *)presenter;

@end

