//
//  VLDRecordNotesPresenter.m
//  Velad
//
//  Created by Renzo Crisóstomo on 13/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDRecordNotesPresenter.h"
#import "VLDRecord.h"
#import <Realm/Realm.h>

@interface VLDRecordNotesPresenter () <UIAlertViewDelegate>

- (void)handleNotes:(NSString *)notes;

@end

@implementation VLDRecordNotesPresenter

#pragma mark - Public methods

- (instancetype)initWithDataSource:(id<VLDRecordNotesPresenterDataSource>)dataSource {
    self = [super init];
    if (self) {
        _dataSource = dataSource;
    }
    return self;
}

- (void)present {
    if ([UIAlertController class]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Agregar notas"
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Notas";
            textField.text = self.record.notes;
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancelar"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action) {
                                                                 [self.delegate recordNotesPresenterDidCancelRecording:self];
                                                             }];
        [alertController addAction:cancelAction];
        __weak UIAlertController *weakAlertController = alertController;
        UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"Agregar"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              UITextField *textField = weakAlertController.textFields[0];
                                                              [self handleNotes:textField.text];
                                                          }];
        [alertController addAction:addAction];
        UIViewController *viewController = [self.dataSource viewControllerForRecordNotesPresenter:self];
        [viewController presentViewController:alertController
                                     animated:YES
                                   completion:nil];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Agregar notas"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancelar"
                                                  otherButtonTitles:@"Agregar", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *textField = [alertView textFieldAtIndex:0];
        textField.placeholder = @"Notas";
        textField.text = self.record.notes;
        [alertView show];
    }
}

#pragma mark - Private methods

- (void)handleNotes:(NSString *)notes {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    if (self.record) {
        self.record.notes = notes;
    } else {
        NSDate *date;
        if ([self.dataSource respondsToSelector:@selector(dateForRecordNotesPresenter:)]) {
            date = [self.dataSource dateForRecordNotesPresenter:self];
        } else {
            date = [NSDate date];
        }
        VLDRecord *record = [[VLDRecord alloc] init];
        record.date = date;
        record.basicPoint = [self.dataSource basicPointForRecordNotesPresenter:self];
        record.notes = notes;
        [realm addObject:record];
    }
    [realm commitWriteTransaction];
    if ([self.delegate respondsToSelector:@selector(recordNotesPresenterDidFinishRecording:)]) {
        [self.delegate recordNotesPresenterDidFinishRecording:self];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        [self handleNotes:textField.text];
    } else if (buttonIndex == alertView.cancelButtonIndex) {
        [self.delegate recordNotesPresenterDidCancelRecording:self];
    }
}

@end
