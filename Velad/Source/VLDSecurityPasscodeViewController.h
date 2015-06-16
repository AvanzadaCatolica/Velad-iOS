//
//  VLDSecurityPasscodeViewController.h
//  Velad
//
//  Created by Renzo Crisóstomo on 16/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, VLDSecurityPasscodeViewControllerMode) {
    VLDSecurityPasscodeViewControllerModeCleanRecord,
    VLDSecurityPasscodeViewControllerModeReRecord,
    VLDSecurityPasscodeViewControllerModeRequest
};

extern NSString * const VLDKeychainService;
extern NSString * const VLDKeychainAccount;

@protocol VLDSecurityPasscodeViewControllerDelegate;

@interface VLDSecurityPasscodeViewController : UIViewController

@property (nonatomic, readonly) VLDSecurityPasscodeViewControllerMode mode;
@property (nonatomic, weak) id<VLDSecurityPasscodeViewControllerDelegate> delegate;

- (instancetype)initWithMode:(VLDSecurityPasscodeViewControllerMode)mode;

@end

@protocol VLDSecurityPasscodeViewControllerDelegate <NSObject>

- (void)securityPasscodeViewControllerDidFinish:(VLDSecurityPasscodeViewController *)viewController;

@end
