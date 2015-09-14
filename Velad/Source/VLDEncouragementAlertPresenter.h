//
//  VLDEncouragementAlertPresenter.h
//  Velad
//
//  Created by Renzo Crisostomo on 14/09/15.
//  Copyright © 2015 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VLDEncouragementAlertPresenterDataSource;

@interface VLDEncouragementAlertPresenter : NSObject

@property (nonatomic, weak) id<VLDEncouragementAlertPresenterDataSource> dataSource;

- (void)present;

@end

@protocol VLDEncouragementAlertPresenterDataSource <NSObject>

- (UIViewController *)viewControllerForEncouragementAlertPresenter:(VLDEncouragementAlertPresenter *)presenter;

@end