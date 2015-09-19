//
//  VLDErrorPresenter.h
//  Velad
//
//  Created by Renzo Crisóstomo on 14/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol VLDErrorPresenterDataSource;

@interface VLDErrorPresenter : NSObject

@property (nonatomic, weak) id<VLDErrorPresenterDataSource> dataSource;

- (instancetype)initWithDataSource:(id<VLDErrorPresenterDataSource>)dataSource NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
- (void)presentError:(NSError *)error;

@end

@protocol VLDErrorPresenterDataSource <NSObject>

- (UIViewController *)viewControllerForErrorPresenter:(VLDErrorPresenter *)presenter;

@end
