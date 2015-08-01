//
//  VLDNoteViewController.h
//  Velad
//
//  Created by Renzo Crisóstomo on 14/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "XLFormViewController.h"

@class VLDNote;
@protocol VLDNoteViewControllerDelegate;

@interface VLDNoteViewController : XLFormViewController

@property (nonatomic, weak) id<VLDNoteViewControllerDelegate> delegate;

- (instancetype)initWithNote:(VLDNote *)note NS_DESIGNATED_INITIALIZER;

@end

@protocol VLDNoteViewControllerDelegate <NSObject>

- (void)noteViewControllerDidChangeProperties:(VLDNoteViewController *)viewController;

@end
