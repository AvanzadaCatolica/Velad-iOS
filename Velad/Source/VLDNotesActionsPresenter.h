//
//  VLDNotesActionsPresenter.h
//  Velad
//
//  Created by Renzo Crisóstomo on 14/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "XLFormViewController.h"
#import <Realm/Realm.h>

@protocol VLDNotesActionsPresenterDataSource;
@protocol VLDNotesActionsPresenterDelegate;

@interface VLDNotesActionsPresenter : NSObject

@property (nonatomic, weak) id<VLDNotesActionsPresenterDelegate> delegate;

- (instancetype)initWithDataSource:(id<VLDNotesActionsPresenterDataSource>)dataSource;
- (void)present;

@end

@protocol VLDNotesActionsPresenterDataSource <NSObject>

- (RLMResults *)notesForNotesActionsPresenter:(VLDNotesActionsPresenter *)presenter;
- (UIViewController *)viewControllerForNotesActionsPresenter:(VLDNotesActionsPresenter *)presenter;

@end

@protocol VLDNotesActionsPresenterDelegate <NSObject>

- (void)notesActionsPresenterDidDidSelectRegister:(VLDNotesActionsPresenter *)presenter;
- (void)notesActionsPresenterDidSelectMail:(VLDNotesActionsPresenter *)presenter;

@end