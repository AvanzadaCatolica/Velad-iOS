//
//  VLDGroupViewController.h
//  Velad
//
//  Created by Renzo Crisóstomo on 01/08/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XLForm/XLForm.h>

@class VLDGroup;
@protocol VLDGroupViewControllerDelegate;

@interface VLDGroupViewController : XLFormViewController

@property (nonatomic, weak) id<VLDGroupViewControllerDelegate> delegate;

- (instancetype)initWithGroup:(VLDGroup *)group NS_DESIGNATED_INITIALIZER;

@end

@protocol VLDGroupViewControllerDelegate <NSObject>

- (void)groupViewController:(VLDGroupViewController *)viewController
      didFinishEditingGroup:(VLDGroup *)basicPoint;

@end
