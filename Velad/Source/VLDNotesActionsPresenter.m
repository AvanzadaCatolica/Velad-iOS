//
//  VLDNotesActionsPresenter.m
//  Velad
//
//  Created by Renzo Crisóstomo on 14/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDNotesActionsPresenter.h"
#import "VLDNote.h"
#import "VLDConfession.h"

@interface VLDNotesActionsPresenter () <UIActionSheetDelegate>

@property (nonatomic, weak, readonly) id<VLDNotesActionsPresenterDataSource> dataSource;

- (void)handleRegister;
- (void)handleMail;

@end

@implementation VLDNotesActionsPresenter

#pragma mark - Life cycle

- (instancetype)initWithDataSource:(id<VLDNotesActionsPresenterDataSource>)dataSource {
    self = [super init];
    if (self) {
        _dataSource = dataSource;
    }
    return self;
}

#pragma mark - Private methods

- (void)handleRegister {
    RLMResults *notes = [self.dataSource notesForNotesActionsPresenter:self];
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    NSDate *date = [NSDate date];
    while (notes.count > 0) {
        VLDNote *note = notes.firstObject;
        note.state = VLDNoteStateConfessed;
        note.date = date;
    }
    VLDConfession *confession = [[VLDConfession alloc] init];
    confession.date = date;
    [realm addObject:confession];
    
    [realm commitWriteTransaction];
    if ([self.delegate respondsToSelector:@selector(notesActionsPresenterDidDidSelectRegister:)]) {
        [self.delegate notesActionsPresenterDidDidSelectRegister:self];
    }
}

- (void)handleMail {
    if ([self.delegate respondsToSelector:@selector(notesActionsPresenterDidSelectMail:)]) {
        [self.delegate notesActionsPresenterDidSelectMail:self];
    }
}

#pragma mark - Public methods

- (void)present {
    if ([UIAlertController class]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancelar"
                                                               style:UIAlertActionStyleCancel
                                                             handler:nil];
        [alertController addAction:cancelAction];
        UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"Registrar confesión"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              [self handleRegister];
                                                          }];
        [alertController addAction:addAction];
        UIAlertAction *mailAction = [UIAlertAction actionWithTitle:@"Enviar por correo"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *action) {
                                                               [self handleMail];
                                                           }];
        [alertController addAction:mailAction];
        [[self.dataSource viewControllerForNotesActionsPresenter:self]
         presentViewController:alertController animated:YES completion:nil];
    } else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Cambiar a confesadas todas las notas?"
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancelar"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Registrar confesión", @"Enviar por correo", nil];
        [actionSheet showFromTabBar:[self.dataSource viewControllerForNotesActionsPresenter:self].tabBarController.tabBar];
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    } else if (buttonIndex == actionSheet.firstOtherButtonIndex) {
        [self handleRegister];
    } else if (buttonIndex == actionSheet.firstOtherButtonIndex + 1) {
        [self handleMail];
    }
    
}

@end
