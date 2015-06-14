//
//  VLDFormErrorPresenter.m
//  Velad
//
//  Created by Renzo Crisóstomo on 14/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDFormErrorPresenter.h"

@interface VLDFormErrorPresenter ()

@end

@implementation VLDFormErrorPresenter

#pragma mark - Life cycle

- (instancetype)initWithDataSource:(id<VLDFormErrorPresenterDataSource>)dataSource {
    self = [super init];
    if (self) {
        _dataSource = dataSource;
    }
    return self;
}

#pragma mark - Public methods

- (void)presentError:(NSError *)error {
    if ([UIAlertController class]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                 message:error.userInfo[@"NSLocalizedDescription"]
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Aceptar"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
        [alertController addAction:cancelAction];
        UIViewController *viewController = [self.dataSource viewControllerForFormErrorPresenter:self];
        [viewController presentViewController:alertController
                                     animated:YES
                                   completion:nil];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:error.userInfo[@"NSLocalizedDescription"]
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Aceptar", nil];
        [alertView show];
    }
}

@end
