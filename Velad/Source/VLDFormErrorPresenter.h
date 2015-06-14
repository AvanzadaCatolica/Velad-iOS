//
//  VLDFormErrorPresenter.h
//  Velad
//
//  Created by Renzo Crisóstomo on 14/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol VLDFormErrorPresenterDataSource;

@interface VLDFormErrorPresenter : NSObject

@property (nonatomic, weak) id<VLDFormErrorPresenterDataSource> dataSource;

- (instancetype)initWithDataSource:(id<VLDFormErrorPresenterDataSource>)dataSource NS_DESIGNATED_INITIALIZER;
- (void)presentError:(NSError *)error;

@end

@protocol VLDFormErrorPresenterDataSource <NSObject>

- (UIViewController *)viewControllerForFormErrorPresenter:(VLDFormErrorPresenter *)presenter;

@end
