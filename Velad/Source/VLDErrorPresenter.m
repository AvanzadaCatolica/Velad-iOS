//
//  VLDErrorPresenter.m
//  Velad
//
//  Created by Renzo Crisóstomo on 14/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDErrorPresenter.h"

@interface VLDErrorPresenter ()

@end

@implementation VLDErrorPresenter

#pragma mark - Life cycle

- (instancetype)initWithDataSource:(id<VLDErrorPresenterDataSource>)dataSource {
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
        UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Aceptar"
                                                                style:UIAlertActionStyleDefault
                                                              handler:nil];
        [alertController addAction:dismissAction];
        UIViewController *viewController = [self.dataSource viewControllerForErrorPresenter:self];
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
