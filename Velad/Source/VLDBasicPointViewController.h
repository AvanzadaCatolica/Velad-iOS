//
//  VLDBasicPointViewController.h
//  Velad
//
//  Created by Renzo Crisóstomo on 14/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XLForm/XLForm.h>

@class VLDBasicPoint;
@protocol VLDBasicPointViewControllerDelegate;

@interface VLDBasicPointViewController : XLFormViewController

@property (nonatomic, weak) id<VLDBasicPointViewControllerDelegate> delegate;

- (instancetype)initWithBasicPoint:(VLDBasicPoint *)basicPoint NS_DESIGNATED_INITIALIZER;

@end

@protocol VLDBasicPointViewControllerDelegate <NSObject>

- (void)basicPointViewController:(VLDBasicPointViewController *)viewController
      didFinishEditingBasicPoint:(VLDBasicPoint *)basicPoint;
- (void)basicPointViewControllerDidCancelEditing:(VLDBasicPointViewController *)viewController;

@end
