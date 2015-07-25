//
//  VLDArrowButton.m
//  Velad
//
//  Created by Renzo Crisóstomo on 14/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDArrowButton.h"

@interface VLDArrowButton ()

+ (UIImage *)imageForDirection:(VLDArrowButtonDirection)direction;

@end

static CGFloat const kArrowButtonPadding = 40;

@implementation VLDArrowButton

#pragma mark - Private methods

+ (UIImage *)imageForDirection:(VLDArrowButtonDirection)direction {
    switch (direction) {
        case VLDArrowButtonDirectionLeft:
            return [[UIImage imageNamed:@"LeftArrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        case VLDArrowButtonDirectionRight:
            return [[UIImage imageNamed:@"RightArrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        case VLDArrowButtonDirectionNone:
            return nil;
    }
}

#pragma mark - Public methods

+ (VLDArrowButton *)buttonWithDirection:(VLDArrowButtonDirection)direction {
    VLDArrowButton *arrowButton = [[VLDArrowButton alloc] init];
    [arrowButton setImage:[self imageForDirection:direction]
                 forState:UIControlStateNormal];
    return arrowButton;
}

- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    return CGSizeMake(size.width + kArrowButtonPadding, size.height + kArrowButtonPadding);
    
}

@end
