//
//  VLDBasicPointAlertViewController.h
//  Velad
//
//  Created by Renzo Crisóstomo on 14/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XLForm/XLForm.h>

@class VLDBasicPoint;

@interface VLDBasicPointAlertViewController : XLFormViewController

- (instancetype)initWithBasicPoint:(VLDBasicPoint *)basicPoint NS_DESIGNATED_INITIALIZER;

@end
