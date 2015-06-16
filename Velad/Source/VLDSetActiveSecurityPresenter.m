//
//  VLDSetActiveSecurityPresenter.m
//  Velad
//
//  Created by Renzo Crisóstomo on 16/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDSetActiveSecurityPresenter.h"
#import "VLDSecurity.h"

@interface VLDSetActiveSecurityPresenter () <UIActionSheetDelegate>

@property (nonatomic, weak) id<VLDSetActiveSecurityPresenterDataSource> dataSource;
@property (nonatomic) VLDSecurity *security;

- (void)setupSecurity;

@end

@implementation VLDSetActiveSecurityPresenter

#pragma mark - Public methods

- (instancetype)initWithDataSource:(id<VLDSetActiveSecurityPresenterDataSource>)dataSource {
    self = [super init];
    if (self) {
        _dataSource = dataSource;
        [self setupSecurity];
    }
    
    return self;
}

- (void)present {
    NSString *title = self.security.isEnabled ? @"Desea desactivar la seguridad? Su contraseña será borrada" : @"Desea activar la seguridad? Deberá grabar una contraseña y esta será solicita para usar la aplicación";
    NSString *action = self.security.isEnabled ? @"Desactivar" : @"Activar";
    if ([UIAlertController class]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancelar"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action) {
                                                                 if ([self.delegate respondsToSelector:@selector(setActiveSecurityPresenterDidCancel:)]) {
                                                                     [self.delegate setActiveSecurityPresenterDidCancel:self];
                                                                 }
                                                             }];
        [alertController addAction:cancelAction];
        UIAlertAction *addAction = [UIAlertAction actionWithTitle:action
                                                            style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction *action) {
                                                              if ([self.delegate respondsToSelector:@selector(setActiveSecurityPresenterDidAccept:)]) {
                                                                  [self.delegate setActiveSecurityPresenterDidAccept:self];
                                                              }
                                                          }];
        [alertController addAction:addAction];
        [[self.dataSource viewControllerForSetActiveSecurityPresenter:self]
         presentViewController:alertController animated:YES completion:nil];
    } else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancelar"
                                                   destructiveButtonTitle:action
                                                        otherButtonTitles:nil];
        [actionSheet showFromTabBar:[self.dataSource viewControllerForSetActiveSecurityPresenter:self].tabBarController.tabBar];
    }
}

#pragma mark - Setup methods

- (void)setupSecurity {
    _security = [[VLDSecurity allObjects] firstObject];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        if ([self.delegate respondsToSelector:@selector(setActiveSecurityPresenterDidAccept:)]) {
            [self.delegate setActiveSecurityPresenterDidAccept:self];
        }
    } else if (buttonIndex == actionSheet.cancelButtonIndex) {
        if ([self.delegate respondsToSelector:@selector(setActiveSecurityPresenterDidCancel:)]) {
            [self.delegate setActiveSecurityPresenterDidCancel:self];
        }
    }
}

@end