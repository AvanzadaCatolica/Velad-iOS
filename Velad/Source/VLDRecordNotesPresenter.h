//
//  VLDRecordNotesPresenter.h
//  Velad
//
//  Created by Renzo Crisóstomo on 13/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class VLDRecord;
@class VLDBasicPoint;
@protocol VLDRecordNotesPresenterDataSource;
@protocol VLDRecordNotesPresenterDelegate;

@interface VLDRecordNotesPresenter : NSObject

@property (nonatomic) VLDRecord *record;
@property (nonatomic, weak) id<VLDRecordNotesPresenterDataSource> dataSource;
@property (nonatomic, weak) id<VLDRecordNotesPresenterDelegate> delegate;

- (instancetype)initWithDataSource:(id<VLDRecordNotesPresenterDataSource>)dataSource NS_DESIGNATED_INITIALIZER;
- (void)present;

@end

@protocol VLDRecordNotesPresenterDataSource <NSObject>

- (VLDBasicPoint *)basicPointForRecordNotesPresenter:(VLDRecordNotesPresenter *)presenter;
- (UIViewController *)viewControllerForRecordNotesPresenter:(VLDRecordNotesPresenter *)presenter;

@optional
- (NSDate *)dateForRecordNotesPresenter:(VLDRecordNotesPresenter *)presenter;

@end

@protocol VLDRecordNotesPresenterDelegate <NSObject>

- (void)recordNotesPresenterDidFinishRecording:(VLDRecordNotesPresenter *)presenter;
- (void)recordNotesPresenterDidCancelRecording:(VLDRecordNotesPresenter *)presenter;

@end