//
//  VLDNoteFilterViewController.h
//  Velad
//
//  Created by Renzo Crisóstomo on 28/08/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, VLDNoteFilterType) {
    VLDNoteFilterTypeAll,
    VLDNoteFilterTypeRegular,
    VLDNoteFilterTypeConfessable,
    VLDNoteFilterTypeConfessed,
    VLDNoteFilterTypeGuidance,
    VLDNoteFilterTypeDates
};

@protocol VLDNoteFilterViewControllerDelegate;

@interface VLDNoteFilterViewController : UIViewController

@property (nonatomic, readonly) VLDNoteFilterType selectedNoteFilterType;
@property (nonatomic, weak) id<VLDNoteFilterViewControllerDelegate> delegate;

- (instancetype)initWithNoteFilerType:(VLDNoteFilterType)noteFilterType;

@end

@protocol VLDNoteFilterViewControllerDelegate <NSObject>

- (void)noteFilterViewControlerDidFinishFilterSelection:(VLDNoteFilterViewController *)viewController;

@end
