//
//  VLDUpdateNotesPresenter.m
//  Velad
//
//  Created by Renzo Crisóstomo on 14/06/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "VLDUpdateNotesPresenter.h"
#import "VLDNote.h"
#import "VLDConfession.h"

@interface VLDUpdateNotesPresenter () <UIActionSheetDelegate>

@property (nonatomic, weak, readonly) id<VLDUpdateNotesPresenterDataSource> dataSource;

- (void)handleUpdate;

@end

@implementation VLDUpdateNotesPresenter

#pragma mark - Life cycle

- (instancetype)initWithDataSource:(id<VLDUpdateNotesPresenterDataSource>)dataSource {
    self = [super init];
    if (self) {
        _dataSource = dataSource;
    }
    return self;
}

#pragma mark - Private methods

- (void)handleUpdate {
    RLMResults *notes = [self.dataSource notesForUpdateNotesPresenter:self];
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
    if ([self.delegate respondsToSelector:@selector(updateNotesPresenterDidFinishUpdate:)]) {
        [self.delegate updateNotesPresenterDidFinishUpdate:self];
    }
}

#pragma mark - Public methods

- (void)present {
    if ([UIAlertController class]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Cambiar a confesadas todas las notas?"
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancelar"
                                                               style:UIAlertActionStyleCancel
                                                             handler:nil];
        [alertController addAction:cancelAction];
        UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"Cambiar"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              [self handleUpdate];
                                                          }];
        [alertController addAction:addAction];
        [[self.dataSource viewControllerForUpdatesNotesPresenter:self]
         presentViewController:alertController animated:YES completion:nil];
    } else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Cambiar a confesadas todas las notas?"
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancelar"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Cambiar", nil];
        [actionSheet showFromTabBar:[self.dataSource viewControllerForUpdatesNotesPresenter:self].tabBarController.tabBar];
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    [self handleUpdate];
}

@end
