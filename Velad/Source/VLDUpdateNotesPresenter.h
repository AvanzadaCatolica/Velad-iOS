//
//  VLDUpdateNotesPresenter.h
//  Velad
//
//  Created by Renzo Crisóstomo on 14/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "XLFormViewController.h"
#import <Realm/Realm.h>

@protocol VLDUpdateNotesPresenterDataSource;
@protocol VLDUpdateNotesPresenterDelegate;

@interface VLDUpdateNotesPresenter : NSObject

@property (nonatomic, weak) id<VLDUpdateNotesPresenterDelegate> delegate;

- (instancetype)initWithDataSource:(id<VLDUpdateNotesPresenterDataSource>)dataSource;
- (void)present;

@end

@protocol VLDUpdateNotesPresenterDataSource <NSObject>

- (RLMResults *)notesForUpdateNotesPresenter:(VLDUpdateNotesPresenter *)presenter;
- (UIViewController *)viewControllerForUpdatesNotesPresenter:(VLDUpdateNotesPresenter *)presenter;

@end

@protocol VLDUpdateNotesPresenterDelegate <NSObject>

- (void)updateNotesPresenterDidFinishUpdate:(VLDUpdateNotesPresenter *)presenter;

@end