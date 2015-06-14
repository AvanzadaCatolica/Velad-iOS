//
//  VLDArrowButton.h
//  Velad
//
//  Created by Renzo Crisóstomo on 14/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, VLDArrowButtonDirection) {
    VLDArrowButtonDirectionLeft,
    VLDArrowButtonDirectionRight
};

@interface VLDArrowButton : UIButton

+ (VLDArrowButton *)buttonWithDirection:(VLDArrowButtonDirection)direction;

@end
