//
//  VLDRestoreDataPresenter.m
//  Velad
//
//  Created by Renzo Crisóstomo on 02/08/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDRestoreDataPresenter.h"

@interface VLDRestoreDataPresenter () <UIActionSheetDelegate>

@property (nonatomic, weak) id<VLDRestoreDataPresenterDataSource> dataSource;

@end

@implementation VLDRestoreDataPresenter

#pragma mark - Public methods

- (instancetype)initWithDataSource:(id<VLDRestoreDataPresenterDataSource>)dataSource {
    self = [super init];
    if (self) {
        _dataSource = dataSource;
    }
    
    return self;
}

- (void)present {
    NSString *title = @"Desea restaurar la información de la aplicación? Los puntos básicos serán restaurados pero la información de perfil y seguridad sera conservada.";
    NSString *action = @"Restaurar";
    if ([UIAlertController class]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancelar"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action) {
                                                                 if ([self.delegate respondsToSelector:@selector(restoreDataPresenterDidCancel:)]) {
                                                                     [self.delegate restoreDataPresenterDidCancel:self];
                                                                 }
                                                             }];
        [alertController addAction:cancelAction];
        UIAlertAction *addAction = [UIAlertAction actionWithTitle:action
                                                            style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction *action) {
                                                              if ([self.delegate respondsToSelector:@selector(restoreDataPresenterDidAccept:)]) {
                                                                  [self.delegate restoreDataPresenterDidAccept:self];
                                                              }
                                                          }];
        [alertController addAction:addAction];
        [[self.dataSource viewControllerForRestoreDataPresenter:self]
         presentViewController:alertController animated:YES completion:nil];
    } else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancelar"
                                                   destructiveButtonTitle:action
                                                        otherButtonTitles:nil];
        [actionSheet showFromTabBar:[self.dataSource viewControllerForRestoreDataPresenter:self].tabBarController.tabBar];
    }
}


@end
