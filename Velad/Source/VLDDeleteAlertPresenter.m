//
//  VLDDeleteAlarmPresenter.m
//  Velad
//
//  Created by Renzo Crisóstomo on 16/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDDeleteAlertPresenter.h"
#import "VLDAlert.h"
#import <Realm/Realm.h>

@interface VLDDeleteAlertPresenter () <UIActionSheetDelegate>

@property (nonatomic, weak) id<VLDDeleteAlertPresenterDataSource> dataSource;

@end

@implementation VLDDeleteAlertPresenter

#pragma mark - Public methods

- (instancetype)initWithDataSource:(id<VLDDeleteAlertPresenterDataSource>)dataSource {
    self = [super init];
    if (self) {
        _dataSource = dataSource;
    }
    
    return self;
}

- (void)present {
    if ([UIAlertController class]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Eliminar alertas programadas?"
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancelar"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action) {
                                                                 if ([self.delegate respondsToSelector:@selector(deleteAlarmPresenterDidCancelDelete:)]) {
                                                                     [self.delegate deleteAlarmPresenterDidCancelDelete:self];
                                                                 }
                                                             }];
        [alertController addAction:cancelAction];
        UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"Eliminar"
                                                            style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction *action) {
                                                              if ([self.delegate respondsToSelector:@selector(deleteAlarmPresenterDidSelectDelete:)]) {
                                                                  [self.delegate deleteAlarmPresenterDidSelectDelete:self];
                                                              }
                                                          }];
        [alertController addAction:addAction];
        [[self.dataSource viewControllerForDeleteAlarmPresenter:self]
         presentViewController:alertController animated:YES completion:nil];
    } else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Eliminar alertas programadas?"
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancelar"
                                                   destructiveButtonTitle:@"Eliminar"
                                                        otherButtonTitles:nil];
        [actionSheet showFromTabBar:[self.dataSource viewControllerForDeleteAlarmPresenter:self].tabBarController.tabBar];
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        if ([self.delegate respondsToSelector:@selector(deleteAlarmPresenterDidSelectDelete:)]) {
            [self.delegate deleteAlarmPresenterDidSelectDelete:self];
        }
    } else if (buttonIndex == actionSheet.cancelButtonIndex) {
        if ([self.delegate respondsToSelector:@selector(deleteAlarmPresenterDidCancelDelete:)]) {
            [self.delegate deleteAlarmPresenterDidCancelDelete:self];
        }
    }
}

@end
