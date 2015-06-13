//
//  VLDBasicPointsViewController.h
//  Velad
//
//  Created by Renzo Crisóstomo on 13/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RLMResults;

@protocol VLDBasicPointsViewControllerDelegate;

@interface VLDBasicPointsViewController : UIViewController

@property (nonatomic, weak) id<VLDBasicPointsViewControllerDelegate> delegate;

@end

@protocol VLDBasicPointsViewControllerDelegate <NSObject>

- (void)basicPointsViewControllerDidChangeProperties:(VLDBasicPointsViewController *)viewController;

@end