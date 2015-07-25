//
//  VLDDiaryModePickerView.h
//  Velad
//
//  Created by Renzo Crisóstomo on 25/07/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, VLDDiaryMode) {
    VLDDiaryModeAll,
    VLDDiaryModeConfessable,
    VLDDIaryModeGuidance
};

@protocol VLDDiaryModePickerViewDelegate;

@interface VLDDiaryModePickerView : UIView

@property (nonatomic, readonly) VLDDiaryMode mode;
@property (nonatomic, weak) id<VLDDiaryModePickerViewDelegate> delegate;

- (instancetype)initWithMode:(VLDDiaryMode)mode;

@end

@protocol VLDDiaryModePickerViewDelegate <NSObject>

- (void)diaryModePickerViewDidChangeMode:(VLDDiaryModePickerView *)diaryModePickerView;

@end
