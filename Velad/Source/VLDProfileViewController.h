//
//  VLDProfileViewController.h
//  Velad
//
//  Created by Renzo Crisóstomo on 16/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XLForm/XLForm.h>

@protocol VLDProfileViewControllerDelegate;

extern NSString *const VLDProfileViewControllerConfigureLaterKey;

@interface VLDProfileViewController : XLFormViewController

@property (nonatomic, weak) id<VLDProfileViewControllerDelegate> delegate;

- (instancetype)initWithConfigureLaterEnabled:(BOOL)configureLaterEnabled NS_DESIGNATED_INITIALIZER;

@end

@protocol VLDProfileViewControllerDelegate <NSObject>

- (void)profileViewControllerDidFinishEditingProfile:(VLDProfileViewController *)controller;

@end
