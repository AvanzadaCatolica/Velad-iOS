//
//  VLDEncouragementAlertPresenter.m
//  Velad
//
//  Created by Renzo Crisostomo on 14/09/15.
//  Copyright © 2015 MAC. All rights reserved.
//

#import "VLDEncouragementAlertPresenter.h"

@implementation VLDEncouragementAlertPresenter

#pragma mark - Public method

- (void)present {
    NSString *title = @"Felicitaciones";
    NSString *message = @"Estás haciendo un trabajo excelente! \U0001F389 \U0001F38A";
    if ([UIAlertController class]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                                 message:message
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleCancel
                                                             handler:nil];
        [alertController addAction:cancelAction];
        UIViewController *viewController = [self.dataSource viewControllerForEncouragementAlertPresenter:self];
        [viewController presentViewController:alertController
                                     animated:YES
                                   completion:nil];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

@end
