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

@interface VLDProfileViewController : XLFormViewController

@property (nonatomic, weak) id<VLDProfileViewControllerDelegate> delegate;

@end

@protocol VLDProfileViewControllerDelegate <NSObject>

- (void)profileViewControllerDidFinishEditingProfile:(VLDProfileViewController *)controller;

@end
